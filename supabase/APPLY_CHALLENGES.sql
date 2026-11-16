-- Paste into Supabase SQL Editor
-- Friend challenges: send / accept / decline + privacy + busy-in-match guard.

create table if not exists public.challenges (
  id uuid primary key default gen_random_uuid(),
  challenger_id uuid not null references public.profiles (id) on delete cascade,
  challenged_id uuid not null references public.profiles (id) on delete cascade,
  stake_kind text not null default 'free',
  status text not null default 'pending',
  expires_at timestamptz not null default (now() + interval '60 seconds'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint challenges_stake_check check (stake_kind in ('free', 'coins5')),
  constraint challenges_status_check check (
    status in ('pending', 'accepted', 'declined', 'cancelled', 'expired')
  ),
  constraint challenges_not_self check (challenger_id <> challenged_id)
);

create index if not exists challenges_challenged_pending_idx
  on public.challenges (challenged_id, status, expires_at desc);

create index if not exists challenges_challenger_pending_idx
  on public.challenges (challenger_id, status, expires_at desc);

create or replace function public.set_challenges_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists challenges_set_updated_at on public.challenges;
create trigger challenges_set_updated_at
before update on public.challenges
for each row execute function public.set_challenges_updated_at();

alter table public.challenges enable row level security;

revoke all on table public.challenges from anon, authenticated;
grant select on table public.challenges to authenticated;

drop policy if exists "challenges_select_participants" on public.challenges;
create policy "challenges_select_participants"
on public.challenges for select
to authenticated
using (auth.uid() = challenger_id or auth.uid() = challenged_id);

do $$
begin
  alter publication supabase_realtime add table public.challenges;
exception
  when duplicate_object then null;
  when undefined_object then
    raise notice 'Realtime publication missing: %', SQLERRM;
end $$;

alter table public.challenges replica identity full;

-- True when target allows challenges from caller (Nobody / Friends / Everyone).
create or replace function public.can_challenge_user(p_target_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_who smallint;
  v_friends boolean := false;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated', 'allowed', false);
  end if;
  if p_target_id is null or p_target_id = v_uid then
    return jsonb_build_object('status', 'ok', 'allowed', false, 'reason', 'self');
  end if;

  select coalesce(challenge_who, 0) into v_who
  from public.profiles where id = p_target_id;
  if not found then
    return jsonb_build_object('status', 'ok', 'allowed', false, 'reason', 'missing');
  end if;

  if v_who = 2 then
    return jsonb_build_object('status', 'ok', 'allowed', false, 'reason', 'nobody');
  end if;

  if v_who = 1 then
    select exists (
      select 1 from public.friendships f
      where f.status = 'accepted'
        and (
          (f.requester_id = v_uid and f.addressee_id = p_target_id)
          or (f.requester_id = p_target_id and f.addressee_id = v_uid)
        )
    ) into v_friends;
    if not v_friends then
      return jsonb_build_object('status', 'ok', 'allowed', false, 'reason', 'friends_only');
    end if;
  end if;

  return jsonb_build_object('status', 'ok', 'allowed', true, 'challenge_who', v_who);
end;
$$;

revoke all on function public.can_challenge_user(uuid) from public, anon;
grant execute on function public.can_challenge_user(uuid) to authenticated;

create or replace function public._user_in_active_match(p_uid uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.multiplayer_rooms r
    where r.status in ('waiting', 'matched', 'active')
      and (r.player_o = p_uid or r.player_x = p_uid)
      and r.player_x is not null
  );
$$;

revoke all on function public._user_in_active_match(uuid) from public, anon, authenticated;

create or replace function public.send_challenge(
  p_challenged_id uuid,
  p_stake_kind text default 'free'
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_gate jsonb;
  v_id uuid;
  v_exp timestamptz := now() + interval '60 seconds';
  v_stake text := lower(trim(coalesce(p_stake_kind, 'free')));
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  if v_stake not in ('free', 'coins5') then
    return jsonb_build_object('status', 'error', 'message', 'Invalid stake');
  end if;

  v_gate := public.can_challenge_user(p_challenged_id);
  if coalesce((v_gate->>'allowed')::boolean, false) is not true then
    return jsonb_build_object(
      'status', 'error',
      'message', case coalesce(v_gate->>'reason', '')
        when 'nobody' then 'This player does not accept challenges'
        when 'friends_only' then 'Only friends can challenge this player'
        else 'Cannot challenge this player'
      end
    );
  end if;

  if public._user_in_active_match(p_challenged_id) then
    return jsonb_build_object(
      'status', 'error',
      'message', 'Player is already in a match'
    );
  end if;

  if public._user_in_active_match(v_uid) then
    return jsonb_build_object(
      'status', 'error',
      'message', 'Finish your current match before challenging'
    );
  end if;

  -- Expire older pending between the pair.
  update public.challenges
  set status = 'expired', updated_at = now()
  where status = 'pending'
    and expires_at <= now()
    and (challenger_id = v_uid or challenged_id = v_uid);

  if exists (
    select 1 from public.challenges c
    where c.status = 'pending'
      and c.expires_at > now()
      and c.challenger_id = v_uid
      and c.challenged_id = p_challenged_id
  ) then
    return jsonb_build_object('status', 'error', 'message', 'Challenge already pending');
  end if;

  insert into public.challenges (
    challenger_id, challenged_id, stake_kind, status, expires_at
  ) values (
    v_uid, p_challenged_id, v_stake, 'pending', v_exp
  )
  returning id into v_id;

  return jsonb_build_object(
    'status', 'ok',
    'id', v_id,
    'expires_at', v_exp
  );
end;
$$;

revoke all on function public.send_challenge(uuid, text) from public, anon;
grant execute on function public.send_challenge(uuid, text) to authenticated;

create or replace function public.respond_challenge(
  p_challenge_id uuid,
  p_accept boolean
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  c public.challenges%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  select * into c from public.challenges where id = p_challenge_id for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Challenge not found');
  end if;

  if c.challenged_id is distinct from v_uid then
    return jsonb_build_object('status', 'error', 'message', 'Not your challenge');
  end if;

  if c.status <> 'pending' then
    return jsonb_build_object('status', 'error', 'message', 'Challenge already closed');
  end if;

  if c.expires_at <= now() then
    update public.challenges set status = 'expired', updated_at = now()
    where id = c.id;
    return jsonb_build_object('status', 'error', 'message', 'Challenge expired');
  end if;

  if p_accept and public._user_in_active_match(v_uid) then
    return jsonb_build_object(
      'status', 'error',
      'message', 'Finish your current match first'
    );
  end if;

  update public.challenges
  set status = case when p_accept then 'accepted' else 'declined' end,
      updated_at = now()
  where id = c.id
  returning * into c;

  return jsonb_build_object(
    'status', 'ok',
    'id', c.id,
    'challenge_status', c.status,
    'challenger_id', c.challenger_id,
    'challenged_id', c.challenged_id,
    'stake_kind', c.stake_kind
  );
end;
$$;

revoke all on function public.respond_challenge(uuid, boolean) from public, anon;
grant execute on function public.respond_challenge(uuid, boolean) to authenticated;

create or replace function public.cancel_challenge(p_challenge_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  c public.challenges%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  select * into c from public.challenges where id = p_challenge_id for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Challenge not found');
  end if;
  if c.challenger_id is distinct from v_uid then
    return jsonb_build_object('status', 'error', 'message', 'Only sender can cancel');
  end if;
  if c.status <> 'pending' then
    return jsonb_build_object('status', 'error', 'message', 'Challenge already closed');
  end if;
  update public.challenges set status = 'cancelled', updated_at = now()
  where id = c.id;
  return jsonb_build_object('status', 'ok');
end;
$$;

revoke all on function public.cancel_challenge(uuid) from public, anon;
grant execute on function public.cancel_challenge(uuid) to authenticated;
