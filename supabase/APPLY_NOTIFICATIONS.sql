-- Paste into Supabase SQL Editor (Notification system). Run APPLY_CHALLENGE_MATCH.sql first.
-- Central notification system: history table, FCM device tokens, and
-- triggers that create a notification for every important event.
-- Apply AFTER 026_challenge_match.sql.
--
-- Delivery:
--   * In-app: the client listens to INSERTs on public.notifications (Realtime).
--   * Push (background / closed): a Database Webhook on INSERT into
--     public.notifications calls the `send-push` Edge Function, which sends
--     FCM to every token in public.push_tokens for that user.
--
-- Each row stores `type` + `data` so the app (and the Edge Function) render
-- the text in the user's language; `title` / `body` are English fallbacks.

-- 1) History ------------------------------------------------------------
create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  type text not null,
  title text not null,
  body text not null,
  data jsonb not null default '{}'::jsonb,
  -- false = history only (user turned this category off).
  push boolean not null default true,
  push_sent_at timestamptz null,
  read_at timestamptz null,
  created_at timestamptz not null default now()
);

create index if not exists notifications_user_created_idx on public.notifications (user_id, created_at desc);

alter table public.notifications enable row level security;

revoke all on table public.notifications from anon, authenticated;

grant select on table public.notifications to authenticated;

drop policy if exists "notifications_select_own" on public.notifications;

create policy "notifications_select_own" on public.notifications for
select to authenticated using (auth.uid () = user_id);

do $$
begin
  alter publication supabase_realtime add table public.notifications;

exception when duplicate_object then null;

when undefined_object then raise notice 'Realtime publication missing: %',
SQLERRM;

end $$;

-- 2) Device tokens (private: only RPCs and the Edge Function touch it) ----
create table if not exists public.push_tokens (
    token text primary key,
    user_id uuid not null references public.profiles (id) on delete cascade,
    platform text not null default 'android',
    locale text not null default 'en',
    updated_at timestamptz not null default now()
);

create index if not exists push_tokens_user_idx on public.push_tokens (user_id);

alter table public.push_tokens enable row level security;

revoke all on table public.push_tokens from anon, authenticated;
-- The send-push Edge Function (service role) reads tokens and drops stale ones.
grant select, delete on table public.push_tokens to service_role;

create or replace function public.register_push_token(
  p_token text,
  p_platform text default 'android',
  p_locale text default 'en'
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  if p_token is null or char_length(p_token) < 20 or char_length(p_token) > 4096 then
    return jsonb_build_object('status', 'error', 'message', 'Invalid token');
  end if;
  -- A device belongs to whoever signed in last on it.
  insert into public.push_tokens (token, user_id, platform, locale, updated_at)
  values (
    p_token, v_uid,
    left(coalesce(nullif(trim(p_platform), ''), 'android'), 16),
    left(coalesce(nullif(trim(p_locale), ''), 'en'), 8),
    now()
  )
  on conflict (token) do update
    set user_id = excluded.user_id,
        platform = excluded.platform,
        locale = excluded.locale,
        updated_at = now();
  return jsonb_build_object('status', 'ok');
end;
$$;

revoke all on function public.register_push_token (text, text, text)
from public, anon;

grant
execute on function public.register_push_token (text, text, text) to authenticated;

create or replace function public.unregister_push_token(p_token text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  delete from public.push_tokens
  where token = p_token and user_id = auth.uid();
  return jsonb_build_object('status', 'ok');
end;
$$;

revoke all on function public.unregister_push_token (text)
from public, anon;

grant
execute on function public.unregister_push_token (text) to authenticated;

-- 3) Read state -----------------------------------------------------------
-- p_ids null → mark all of mine read.
create or replace function public.mark_notifications_read(p_ids uuid[] default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_n int;
begin
  if auth.uid() is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  update public.notifications
  set read_at = now()
  where user_id = auth.uid()
    and read_at is null
    and (p_ids is null or id = any (p_ids));
  get diagnostics v_n = row_count;
  return jsonb_build_object('status', 'ok', 'updated', v_n);
end;
$$;

revoke all on function public.mark_notifications_read(uuid[]) from public, anon;

grant execute on function public.mark_notifications_read(uuid[]) to authenticated;

create or replace function public.clear_my_notifications()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  delete from public.notifications where user_id = auth.uid();
  return jsonb_build_object('status', 'ok');
end;
$$;

revoke all on function public.clear_my_notifications ()
from public, anon;

grant
execute on function public.clear_my_notifications () to authenticated;

-- 4) Central helper ---------------------------------------------------------
-- p_pref: 'challenge' | 'invite' | 'result' | null — matches the toggles in
-- Settings → Challenge privacy → Notifications. When off, the row is still
-- kept in history but no push is sent.
create or replace function public._notify(
  p_uid uuid,
  p_type text,
  p_title text,
  p_body text,
  p_data jsonb default '{}'::jsonb,
  p_pref text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_push boolean := true;
begin
  if p_uid is null then
    return;
  end if;
  if p_pref is not null then
    select case p_pref
             when 'challenge' then coalesce(p.notify_challenge_requests, true)
             when 'invite' then coalesce(p.notify_match_invites, true)
             when 'result' then coalesce(p.notify_match_results, true)
             else true
           end
      into v_push
    from public.profiles p where p.id = p_uid;
    v_push := coalesce(v_push, true);
  end if;

  insert into public.notifications (user_id, type, title, body, data, push)
  values (p_uid, p_type, p_title, p_body, coalesce(p_data, '{}'::jsonb), v_push);

  -- Keep history bounded: 90 days.
  delete from public.notifications
  where user_id = p_uid and created_at < now() - interval '90 days';
exception
  when others then
    -- Never break the event that triggered the notification.
    raise warning '_notify failed: %', SQLERRM;
end;
$$;

revoke all on function public._notify (
    uuid,
    text,
    text,
    text,
    jsonb,
    text
)
from public, anon, authenticated;

create or replace function public._username(p_uid uuid)
returns text
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(nullif(trim(username), ''), 'A player')
  from public.profiles where id = p_uid;
$$;

revoke all on function public._username (uuid)
from public, anon, authenticated;

-- 5) Challenges -------------------------------------------------------------
alter table public.challenges
add column if not exists decline_reason text null;

-- Called by the app when a challenge arrives while the player is in a match
-- (offline AI games included, which the server cannot see).
create or replace function public.decline_challenge_busy(p_challenge_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  update public.challenges
  set status = 'declined', decline_reason = 'busy', updated_at = now()
  where id = p_challenge_id
    and challenged_id = v_uid
    and status = 'pending';
  return jsonb_build_object('status', 'ok');
end;
$$;

revoke all on function public.decline_challenge_busy (uuid)
from public, anon;

grant
execute on function public.decline_challenge_busy (uuid) to authenticated;

create or replace function public._notify_challenge()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_from text := public._username(new.challenger_id);
  v_to text := public._username(new.challenged_id);
  v_data jsonb;
begin
  if tg_op = 'INSERT' then
    if new.status = 'pending' then
      v_data := jsonb_build_object(
        'name', v_from, 'challenge_id', new.id, 'stake', new.stake_kind);
      perform public._notify(new.challenged_id, 'challenge_request',
        'New challenge', v_from || ' challenged you to a match', v_data, 'challenge');
    end if;
    return new;
  end if;

  if new.status is not distinct from old.status then
    return new;
  end if;

  v_data := jsonb_build_object('name', v_to, 'challenge_id', new.id);
  if new.status = 'accepted' then
    v_data := v_data || jsonb_build_object('room_id', new.room_id);
    perform public._notify(new.challenger_id, 'challenge_accepted',
      'Challenge accepted', v_to || ' accepted your challenge. Match starting!',
      v_data, 'challenge');
  elsif new.status = 'declined' and new.decline_reason = 'busy' then
    perform public._notify(new.challenger_id, 'challenge_busy',
      'Player is busy', v_to || ' is in a match right now. Try again later.',
      v_data, 'challenge');
  elsif new.status = 'declined' then
    perform public._notify(new.challenger_id, 'challenge_declined',
      'Challenge declined', v_to || ' declined your challenge',
      v_data, 'challenge');
  elsif new.status = 'expired' then
    perform public._notify(new.challenger_id, 'challenge_expired',
      'Challenge expired', v_to || ' did not respond in time',
      v_data, 'challenge');
  elsif new.status = 'cancelled' then
    perform public._notify(new.challenged_id, 'challenge_cancelled',
      'Challenge cancelled', v_from || ' cancelled the challenge',
      jsonb_build_object('name', v_from, 'challenge_id', new.id), 'challenge');
  end if;
  return new;
end;
$$;

drop trigger if exists challenges_notify on public.challenges;

create trigger challenges_notify
after insert or update of status on public.challenges
for each row execute function public._notify_challenge();

-- 6) Private room invitations: someone joined my room ------------------------
create or replace function public._notify_room_join()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
begin
  if new.visibility = 'private'
     and old.player_x is null
     and new.player_x is not null then
    v_name := public._username(new.player_x);
    perform public._notify(new.player_o, 'room_joined',
      'Player joined', v_name || ' joined your private room',
      jsonb_build_object('name', v_name, 'room_id', new.id, 'code', new.code),
      'invite');
  end if;
  return new;
end;
$$;

drop trigger if exists multiplayer_rooms_notify_join on public.multiplayer_rooms;

create trigger multiplayer_rooms_notify_join
after update of player_x on public.multiplayer_rooms
for each row execute function public._notify_room_join();

-- 7) Online match results ----------------------------------------------------
create or replace function public._notify_match_result()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
  v_title text;
begin
  if new.mode <> 'online' or new.opponent_user_id is null then
    return new;
  end if;
  v_name := public._username(new.opponent_user_id);
  v_title := case new.result
               when 'win' then 'You won!'
               when 'loss' then 'You lost'
               else 'Draw'
             end;
  perform public._notify(new.user_id, 'match_result',
    v_title, 'Your match vs ' || v_name || ' has ended',
    jsonb_build_object('name', v_name, 'result', new.result,
                       'room_id', new.room_id, 'coins', new.coin_delta),
    'result');
  return new;
end;
$$;

drop trigger if exists matches_notify_result on public.matches;

create trigger matches_notify_result
after insert on public.matches
for each row execute function public._notify_match_result();

-- 8) Wallet: every successful transaction -----------------------------------
create or replace function public._notify_wallet_tx()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_type text;
  v_title text;
  v_body text;
begin
  -- First-sign-in balance sync is not a real transaction.
  if new.reason = 'local_migrate' then
    return new;
  end if;

  if new.direction = 'debit' then
    v_type := 'coins_debit';
    v_title := 'Coins deducted';
    v_body := new.amount_minor || ' coins deducted. Balance: ' || new.balance_after;
  elsif new.reason = 'iap_grant' then
    v_type := 'coins_purchase';
    v_title := 'Purchase complete';
    v_body := new.amount_minor || ' coins added. Balance: ' || new.balance_after;
  elsif new.reason in ('daily_reward', 'ad_reward', 'match_reward',
                       'tournament_prize', 'referral_bonus') then
    v_type := 'coins_reward';
    v_title := 'Reward received';
    v_body := 'You earned ' || new.amount_minor || ' coins. Balance: ' || new.balance_after;
  else
    v_type := 'coins_credit';
    v_title := 'Coins added';
    v_body := new.amount_minor || ' coins added. Balance: ' || new.balance_after;
  end if;

  perform public._notify(new.user_id, v_type, v_title, v_body,
    jsonb_build_object(
      'amount', new.amount_minor,
      'balance', new.balance_after,
      'reason', new.reason,
      'tx_id', new.id
    ));
  return new;
end;
$$;

drop trigger if exists wallet_transactions_notify on public.wallet_transactions;

create trigger wallet_transactions_notify
after insert on public.wallet_transactions
for each row execute function public._notify_wallet_tx();

-- 9) Friends -----------------------------------------------------------------
create or replace function public._notify_friendship()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
begin
  if tg_op = 'INSERT' and new.status = 'pending' then
    v_name := public._username(new.requester_id);
    perform public._notify(new.addressee_id, 'friend_request',
      'Friend request', v_name || ' wants to be your friend',
      jsonb_build_object('name', v_name, 'user_id', new.requester_id), 'invite');
  elsif tg_op = 'UPDATE' and new.status = 'accepted'
        and old.status is distinct from 'accepted' then
    v_name := public._username(new.addressee_id);
    perform public._notify(new.requester_id, 'friend_accepted',
      'New friend', v_name || ' accepted your friend request',
      jsonb_build_object('name', v_name, 'user_id', new.addressee_id), 'invite');
  end if;
  return new;
end;
$$;

drop trigger if exists friendships_notify on public.friendships;

create trigger friendships_notify
after insert or update of status on public.friendships
for each row execute function public._notify_friendship();

-- 10) Edge Function bookkeeping (service role only) -------------------------
create or replace function public.mark_push_sent(p_id uuid)
returns void
language sql
security definer
set search_path = public
as $$
  update public.notifications set push_sent_at = now() where id = p_id;
$$;

revoke all on function public.mark_push_sent (uuid)
from public, anon, authenticated;
grant execute on function public.mark_push_sent(uuid) to service_role;