-- C1: Real Online Matchmaking (queue + atomic pair + minimal matched room)
-- Apply AFTER 001–004. Paste entire file into SQL Editor, then Run.
-- board_size: 3|4|5 (matches Flutter GameArgs / matches.board_size)
-- stake: 10|25|50|100 (matches Flutter showRandomDialog stakes)
-- AI quick_match is unchanged; this path is online-only.

-- 1) Minimal room row created when two players pair (C2/C3 expand lifecycle).
create table if not exists public.multiplayer_rooms (
  id uuid primary key default gen_random_uuid(),
  board_size integer not null,
  stake integer not null,
  player_o uuid not null references public.profiles (id) on delete cascade,
  player_x uuid not null references public.profiles (id) on delete cascade,
  status text not null default 'matched',
  created_at timestamptz not null default now(),
  constraint multiplayer_rooms_board_size_check check (board_size in (3, 4, 5)),
  constraint multiplayer_rooms_stake_check check (stake in (10, 25, 50, 100)),
  constraint multiplayer_rooms_status_check check (
    status in ('matched', 'active', 'finished', 'abandoned')
  ),
  constraint multiplayer_rooms_distinct_players check (player_o <> player_x)
);

create index if not exists multiplayer_rooms_players_idx
  on public.multiplayer_rooms (player_o, player_x);

alter table public.multiplayer_rooms enable row level security;

revoke all on table public.multiplayer_rooms from anon, authenticated;
grant select on table public.multiplayer_rooms to authenticated;

drop policy if exists "multiplayer_rooms_select_participants" on public.multiplayer_rooms;
create policy "multiplayer_rooms_select_participants"
on public.multiplayer_rooms for select
to authenticated
using (auth.uid() = player_o or auth.uid() = player_x);

-- No direct insert/update/delete for clients — only via SECURITY DEFINER RPCs.

-- 2) Queue
create table if not exists public.multiplayer_queue (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  board_size integer not null,
  stake integer not null,
  status text not null default 'searching',
  room_id uuid null references public.multiplayer_rooms (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint multiplayer_queue_board_size_check check (board_size in (3, 4, 5)),
  constraint multiplayer_queue_stake_check check (stake in (10, 25, 50, 100)),
  constraint multiplayer_queue_status_check check (
    status in ('searching', 'matched', 'cancelled')
  )
);

create index if not exists multiplayer_queue_search_idx
  on public.multiplayer_queue (board_size, stake, created_at)
  where status = 'searching';

alter table public.multiplayer_queue enable row level security;

revoke all on table public.multiplayer_queue from anon, authenticated;
grant select on table public.multiplayer_queue to authenticated;

drop policy if exists "multiplayer_queue_select_own" on public.multiplayer_queue;
create policy "multiplayer_queue_select_own"
on public.multiplayer_queue for select
to authenticated
using (auth.uid() = user_id);

-- 3) Stale searching entries (> 60s) → cancelled
create or replace function public._mp_cleanup_stale_queue()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.multiplayer_queue
  set status = 'cancelled',
      updated_at = now()
  where status = 'searching'
    and created_at < now() - interval '60 seconds';
end;
$$;

revoke all on function public._mp_cleanup_stale_queue() from public, anon, authenticated;

-- 4) Join / pair atomically
-- Returns jsonb:
--   { "status": "searching" }
--   { "status": "matched", "room_id": "...", "opponent_id": "...", "my_mark": "O"|"X",
--     "board_size": 3, "stake": 10 }
--   { "status": "error", "message": "..." }
create or replace function public.join_online_matchmaking(
  p_board_size integer,
  p_stake integer
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_opponent public.multiplayer_queue%rowtype;
  v_room_id uuid;
  v_existing public.multiplayer_queue%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  if p_board_size is null or p_board_size not in (3, 4, 5) then
    return jsonb_build_object('status', 'error', 'message', 'Invalid board_size');
  end if;

  if p_stake is null or p_stake not in (10, 25, 50, 100) then
    return jsonb_build_object('status', 'error', 'message', 'Invalid stake');
  end if;

  if not exists (select 1 from public.profiles p where p.id = v_uid) then
    return jsonb_build_object('status', 'error', 'message', 'Profile required');
  end if;

  perform public._mp_cleanup_stale_queue();

  -- Serialize matchmaking for this user
  perform pg_advisory_xact_lock(hashtext('mp_queue_' || v_uid::text));

  select * into v_existing
  from public.multiplayer_queue
  where user_id = v_uid
  for update;

  if found then
    if v_existing.status = 'matched' and v_existing.room_id is not null then
      return public._mp_match_payload(v_uid, v_existing.room_id);
    end if;
    -- Refresh / re-queue same user (no duplicate row)
    delete from public.multiplayer_queue where user_id = v_uid;
  end if;

  -- Lock one compatible opponent (skip locked = concurrent-safe)
  select q.* into v_opponent
  from public.multiplayer_queue q
  where q.status = 'searching'
    and q.board_size = p_board_size
    and q.stake = p_stake
    and q.user_id <> v_uid
    and q.created_at >= now() - interval '60 seconds'
  order by q.created_at asc
  for update of q skip locked
  limit 1;

  if found then
    insert into public.multiplayer_rooms (board_size, stake, player_o, player_x, status)
    values (p_board_size, p_stake, v_opponent.user_id, v_uid, 'matched')
    returning id into v_room_id;

    update public.multiplayer_queue
    set status = 'matched',
        room_id = v_room_id,
        updated_at = now()
    where user_id = v_opponent.user_id;

    insert into public.multiplayer_queue (
      user_id, board_size, stake, status, room_id, created_at, updated_at
    ) values (
      v_uid, p_board_size, p_stake, 'matched', v_room_id, now(), now()
    );

    return public._mp_match_payload(v_uid, v_room_id);
  end if;

  insert into public.multiplayer_queue (
    user_id, board_size, stake, status, room_id, created_at, updated_at
  ) values (
    v_uid, p_board_size, p_stake, 'searching', null, now(), now()
  );

  return jsonb_build_object('status', 'searching');
end;
$$;

revoke all on function public.join_online_matchmaking(integer, integer) from public;
grant execute on function public.join_online_matchmaking(integer, integer) to authenticated;

-- Helper: build matched payload for a participant
create or replace function public._mp_match_payload(p_uid uuid, p_room_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  r public.multiplayer_rooms%rowtype;
  v_mark text;
  v_opponent uuid;
begin
  select * into r from public.multiplayer_rooms where id = p_room_id;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Room not found');
  end if;

  if p_uid = r.player_o then
    v_mark := 'O';
    v_opponent := r.player_x;
  elsif p_uid = r.player_x then
    v_mark := 'X';
    v_opponent := r.player_o;
  else
    return jsonb_build_object('status', 'error', 'message', 'Not a participant');
  end if;

  return jsonb_build_object(
    'status', 'matched',
    'room_id', r.id,
    'opponent_id', v_opponent,
    'my_mark', v_mark,
    'board_size', r.board_size,
    'stake', r.stake
  );
end;
$$;

revoke all on function public._mp_match_payload(uuid, uuid) from public, anon, authenticated;

-- 5) Poll while searching (also surfaces match created by opponent)
create or replace function public.poll_online_matchmaking()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_row public.multiplayer_queue%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  perform public._mp_cleanup_stale_queue();

  select * into v_row
  from public.multiplayer_queue
  where user_id = v_uid;

  if not found then
    return jsonb_build_object('status', 'idle');
  end if;

  if v_row.status = 'matched' and v_row.room_id is not null then
    return public._mp_match_payload(v_uid, v_row.room_id);
  end if;

  if v_row.status = 'cancelled' then
    return jsonb_build_object('status', 'timeout');
  end if;

  if v_row.status = 'searching'
     and v_row.created_at < now() - interval '60 seconds' then
    update public.multiplayer_queue
    set status = 'cancelled', updated_at = now()
    where user_id = v_uid;
    return jsonb_build_object('status', 'timeout');
  end if;

  return jsonb_build_object(
    'status', 'searching',
    'board_size', v_row.board_size,
    'stake', v_row.stake,
    'elapsed_ms', (extract(epoch from (now() - v_row.created_at)) * 1000)::bigint
  );
end;
$$;

revoke all on function public.poll_online_matchmaking() from public;
grant execute on function public.poll_online_matchmaking() to authenticated;

-- 6) Cancel / leave queue
create or replace function public.leave_online_matchmaking()
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

  delete from public.multiplayer_queue
  where user_id = v_uid
    and status = 'searching';

  return jsonb_build_object('status', 'cancelled');
end;
$$;

revoke all on function public.leave_online_matchmaking() from public;
grant execute on function public.leave_online_matchmaking() to authenticated;
