-- Paste into Supabase SQL Editor → Run.
-- Chat privacy: who may send YOU in-match chat messages.
--   0 = everyone, 1 = friends only, 2 = nobody
-- Enforced by RLS on game_chat_messages (server side), so it applies in
-- real time: if the receiver changes the setting mid-match, the very next
-- message from a non-permitted sender is rejected.

alter table public.profiles
  add column if not exists chat_who smallint not null default 0;

alter table public.profiles
  drop constraint if exists profiles_chat_who_check;
alter table public.profiles
  add constraint profiles_chat_who_check check (chat_who in (0, 1, 2));

comment on column public.profiles.chat_who is
  'Who can send me chat messages: 0=everyone, 1=friends only, 2=nobody';

-- Is p_sender allowed to message the OTHER player of p_room_id?
create or replace function public._chat_allowed(p_room_id uuid, p_sender uuid)
returns boolean
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_other uuid;
  v_who smallint;
begin
  select case when r.player_o = p_sender then r.player_x else r.player_o end
    into v_other
  from public.multiplayer_rooms r
  where r.id = p_room_id
    and (r.player_o = p_sender or r.player_x = p_sender);

  if v_other is null then
    return false;
  end if;

  select coalesce(chat_who, 0) into v_who from public.profiles where id = v_other;
  if v_who is null or v_who = 0 then
    return true;
  end if;
  if v_who = 2 then
    return false;
  end if;

  -- friends only
  return exists (
    select 1 from public.friendships f
    where f.status = 'accepted'
      and (
        (f.requester_id = p_sender and f.addressee_id = v_other)
        or (f.requester_id = v_other and f.addressee_id = p_sender)
      )
  );
end;
$$;

revoke all on function public._chat_allowed(uuid, uuid) from public, anon;
-- authenticated MUST keep EXECUTE — the RLS policy below calls it.
grant execute on function public._chat_allowed(uuid, uuid) to authenticated;

-- For the app: can I message my opponent in this room, and if not, why?
create or replace function public.can_chat_in_room(p_room_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_other uuid;
  v_who smallint;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'allowed', false,
                              'reason', 'auth');
  end if;
  if not public._mp_is_room_participant(p_room_id, v_uid) then
    return jsonb_build_object('status', 'ok', 'allowed', false,
                              'reason', 'not_participant');
  end if;
  if public._chat_allowed(p_room_id, v_uid) then
    return jsonb_build_object('status', 'ok', 'allowed', true);
  end if;

  select case when r.player_o = v_uid then r.player_x else r.player_o end
    into v_other
  from public.multiplayer_rooms r where r.id = p_room_id;
  select coalesce(chat_who, 0) into v_who from public.profiles where id = v_other;

  return jsonb_build_object(
    'status', 'ok',
    'allowed', false,
    'reason', case when v_who = 1 then 'friends_only' else 'nobody' end
  );
end;
$$;

revoke all on function public.can_chat_in_room(uuid) from public, anon;
grant execute on function public.can_chat_in_room(uuid) to authenticated;

-- Enforce on every insert.
drop policy if exists "chat_insert_own_as_participant" on public.game_chat_messages;
create policy "chat_insert_own_as_participant"
on public.game_chat_messages for insert
to authenticated
with check (
  sender_id = auth.uid()
  and public._mp_is_room_participant(room_id, auth.uid())
  and public._chat_allowed(room_id, auth.uid())
);

-- Privacy prefs RPCs now include chat_who.
create or replace function public.get_my_privacy_prefs()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  p public.profiles%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  select * into p from public.profiles where id = v_uid;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Profile not found');
  end if;
  return jsonb_build_object(
    'status', 'ok',
    'challenge_who', p.challenge_who,
    'chat_who', p.chat_who,
    'notify_challenge_requests', p.notify_challenge_requests,
    'notify_match_invites', p.notify_match_invites,
    'notify_match_results', p.notify_match_results
  );
end;
$$;

drop function if exists public.update_my_privacy_prefs(
  smallint, boolean, boolean, boolean);

create or replace function public.update_my_privacy_prefs(
  p_challenge_who smallint default null,
  p_notify_challenge_requests boolean default null,
  p_notify_match_invites boolean default null,
  p_notify_match_results boolean default null,
  p_chat_who smallint default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  p public.profiles%rowtype;
  v_who smallint;
  v_chat smallint;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  select * into p from public.profiles where id = v_uid for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Profile not found');
  end if;

  v_who := coalesce(p_challenge_who, p.challenge_who);
  v_chat := coalesce(p_chat_who, p.chat_who);
  if v_who not in (0, 1, 2) or v_chat not in (0, 1, 2) then
    return jsonb_build_object('status', 'error', 'message', 'Invalid privacy value');
  end if;

  update public.profiles
  set challenge_who = v_who,
      chat_who = v_chat,
      notify_challenge_requests = coalesce(
        p_notify_challenge_requests, notify_challenge_requests),
      notify_match_invites = coalesce(p_notify_match_invites, notify_match_invites),
      notify_match_results = coalesce(p_notify_match_results, notify_match_results),
      updated_at = now()
  where id = v_uid
  returning * into p;

  return jsonb_build_object(
    'status', 'ok',
    'challenge_who', p.challenge_who,
    'chat_who', p.chat_who,
    'notify_challenge_requests', p.notify_challenge_requests,
    'notify_match_invites', p.notify_match_invites,
    'notify_match_results', p.notify_match_results
  );
end;
$$;

revoke all on function public.update_my_privacy_prefs(
  smallint, boolean, boolean, boolean, smallint) from public, anon;
grant execute on function public.update_my_privacy_prefs(
  smallint, boolean, boolean, boolean, smallint) to authenticated;
