-- C3: Private room create / join / cancel (reuses multiplayer_rooms)
-- Apply AFTER 006. board_size 3|4|5, stake 10|25|50|100.
-- C1 matchmaking rooms keep status 'matched' → 'active' (unchanged path).

-- 1) Schema extensions
alter table public.multiplayer_rooms
  alter column player_x drop not null;

alter table public.multiplayer_rooms
  add column if not exists code text,
  add column if not exists visibility text not null default 'matchmade',
  add column if not exists expires_at timestamptz null;

-- Drop old status check and recreate with C3 states
alter table public.multiplayer_rooms
  drop constraint if exists multiplayer_rooms_status_check;
alter table public.multiplayer_rooms
  add constraint multiplayer_rooms_status_check check (
    status in (
      'waiting',    -- private lobby
      'matched',    -- C1 just paired
      'active',     -- playing
      'finished',   -- completed game
      'completed',  -- alias-friendly completed
      'cancelled',  -- creator cancelled
      'expired',    -- timed out waiting
      'abandoned'
    )
  );

alter table public.multiplayer_rooms
  drop constraint if exists multiplayer_rooms_visibility_check;
alter table public.multiplayer_rooms
  add constraint multiplayer_rooms_visibility_check check (
    visibility in ('matchmade', 'private')
  );

alter table public.multiplayer_rooms
  drop constraint if exists multiplayer_rooms_distinct_players;
alter table public.multiplayer_rooms
  add constraint multiplayer_rooms_distinct_players check (
    player_x is null or player_o <> player_x
  );

-- Unique code among non-null codes
create unique index if not exists multiplayer_rooms_code_unique
  on public.multiplayer_rooms (code)
  where code is not null;

create index if not exists multiplayer_rooms_waiting_code_idx
  on public.multiplayer_rooms (code, status)
  where visibility = 'private';

-- 2) Code generator (no ambiguous 0/O/1/I)
-- Uses random() so pgcrypto / gen_random_bytes is NOT required.
create or replace function public._mp_new_room_code()
returns text
language plpgsql
volatile
security definer
set search_path = public
as $$
declare
  alphabet constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  result text;
  i int;
  idx int;
begin
  result := '';
  for i in 1..6 loop
    idx := 1 + floor(random() * length(alphabet))::int;
    result := result || substr(alphabet, idx, 1);
  end loop;
  return result;
end;
$$;

revoke all on function public._mp_new_room_code() from public, anon, authenticated;

-- Expire stale waiting private rooms
create or replace function public._mp_expire_private_rooms()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.multiplayer_rooms
  set status = 'expired',
      updated_at = now()
  where visibility = 'private'
    and status = 'waiting'
    and expires_at is not null
    and expires_at < now();
end;
$$;

revoke all on function public._mp_expire_private_rooms() from public, anon, authenticated;

-- 3) Create private room
create or replace function public.create_private_room(
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
  v_code text;
  v_room public.multiplayer_rooms%rowtype;
  v_attempt int;
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

  perform public._mp_expire_private_rooms();

  -- One active waiting private room per creator
  if exists (
    select 1 from public.multiplayer_rooms
    where player_o = v_uid
      and visibility = 'private'
      and status = 'waiting'
  ) then
    return jsonb_build_object(
      'status', 'error',
      'message', 'You already have a waiting private room — cancel it first'
    );
  end if;

  for v_attempt in 1..8 loop
    v_code := public._mp_new_room_code();
    begin
      insert into public.multiplayer_rooms (
        board_size, stake, player_o, player_x, status,
        board, current_turn, move_count,
        code, visibility, expires_at, created_at, updated_at
      ) values (
        p_board_size, p_stake, v_uid, null, 'waiting',
        public._mp_empty_board(p_board_size), 'O', 0,
        v_code, 'private', now() + interval '15 minutes', now(), now()
      )
      returning * into v_room;

      return jsonb_build_object(
        'status', 'waiting',
        'room_id', v_room.id,
        'code', v_room.code,
        'board_size', v_room.board_size,
        'stake', v_room.stake,
        'my_mark', 'O',
        'expires_at', v_room.expires_at,
        'room_status', v_room.status
      );
    exception
      when unique_violation then
        continue;
    end;
  end loop;

  return jsonb_build_object('status', 'error', 'message', 'Could not allocate room code');
end;
$$;

revoke all on function public.create_private_room(integer, integer) from public;
grant execute on function public.create_private_room(integer, integer) to authenticated;

-- 4) Join by code (atomic)
create or replace function public.join_private_room(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_code text;
  r public.multiplayer_rooms%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  v_code := upper(trim(coalesce(p_code, '')));
  if v_code = '' or char_length(v_code) < 4 then
    return jsonb_build_object('status', 'error', 'message', 'Enter a valid room code');
  end if;

  perform public._mp_expire_private_rooms();

  select * into r
  from public.multiplayer_rooms
  where code = v_code
  for update;

  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Room not found');
  end if;

  if r.visibility is distinct from 'private' then
    return jsonb_build_object('status', 'error', 'message', 'Room not found');
  end if;

  if r.status = 'expired'
     or (r.expires_at is not null and r.expires_at < now()) then
    update public.multiplayer_rooms
    set status = 'expired', updated_at = now()
    where id = r.id and status = 'waiting';
    return jsonb_build_object('status', 'error', 'message', 'Room expired');
  end if;

  if r.status = 'cancelled' then
    return jsonb_build_object('status', 'error', 'message', 'Room was cancelled');
  end if;

  if r.status is distinct from 'waiting' then
    return jsonb_build_object('status', 'error', 'message', 'Room is not joinable');
  end if;

  if r.player_o = v_uid then
    return jsonb_build_object('status', 'error', 'message', 'You cannot join your own room');
  end if;

  if r.player_x is not null then
    return jsonb_build_object('status', 'error', 'message', 'Room is full');
  end if;

  update public.multiplayer_rooms
  set player_x = v_uid,
      status = 'active',
      board = coalesce(board, public._mp_empty_board(board_size)),
      current_turn = 'O',
      updated_at = now()
  where id = r.id
    and status = 'waiting'
    and player_x is null
  returning * into r;

  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Room is full');
  end if;

  return jsonb_build_object(
    'status', 'matched',
    'room_id', r.id,
    'opponent_id', r.player_o,
    'my_mark', 'X',
    'board_size', r.board_size,
    'stake', r.stake,
    'room_status', r.status,
    'code', r.code
  );
end;
$$;

revoke all on function public.join_private_room(text) from public;
grant execute on function public.join_private_room(text) to authenticated;

-- 5) Cancel waiting private room (creator only)
create or replace function public.cancel_private_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  r public.multiplayer_rooms%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  select * into r
  from public.multiplayer_rooms
  where id = p_room_id
  for update;

  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Room not found');
  end if;

  if r.player_o is distinct from v_uid then
    return jsonb_build_object('status', 'error', 'message', 'Only the host can cancel');
  end if;

  if r.visibility is distinct from 'private' then
    return jsonb_build_object('status', 'error', 'message', 'Not a private room');
  end if;

  if r.status is distinct from 'waiting' then
    return jsonb_build_object('status', 'error', 'message', 'Room cannot be cancelled now');
  end if;

  update public.multiplayer_rooms
  set status = 'cancelled', updated_at = now()
  where id = p_room_id;

  return jsonb_build_object('status', 'cancelled', 'room_id', p_room_id);
end;
$$;

revoke all on function public.cancel_private_room(uuid) from public;
grant execute on function public.cancel_private_room(uuid) to authenticated;

-- 6) Patch get_online_room: waiting stays waiting; null-safe participants; expose code to members
create or replace function public.get_online_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  r public.multiplayer_rooms%rowtype;
  v_mark text;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  if p_room_id is null then
    return jsonb_build_object('status', 'error', 'message', 'room_id required');
  end if;

  perform public._mp_expire_private_rooms();

  select * into r from public.multiplayer_rooms where id = p_room_id;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Room not found');
  end if;

  if v_uid is distinct from r.player_o
     and v_uid is distinct from r.player_x then
    return jsonb_build_object('status', 'error', 'message', 'Not a participant');
  end if;

  -- Expire if needed for this row
  if r.visibility = 'private'
     and r.status = 'waiting'
     and r.expires_at is not null
     and r.expires_at < now() then
    update public.multiplayer_rooms
    set status = 'expired', updated_at = now()
    where id = p_room_id
    returning * into r;
  end if;

  -- C1 matched rooms activate when either player opens the game
  if r.status = 'matched' and r.player_x is not null then
    update public.multiplayer_rooms
    set status = 'active',
        board = coalesce(board, public._mp_empty_board(board_size)),
        updated_at = now()
    where id = p_room_id
    returning * into r;
  end if;

  -- Do NOT auto-activate private waiting rooms here

  if r.board is null then
    update public.multiplayer_rooms
    set board = public._mp_empty_board(board_size), updated_at = now()
    where id = p_room_id
    returning * into r;
  end if;

  if v_uid = r.player_o then
    v_mark := 'O';
  elsif v_uid = r.player_x then
    v_mark := 'X';
  else
    v_mark := 'O';
  end if;

  return jsonb_build_object(
    'status', 'ok',
    'room_id', r.id,
    'board_size', r.board_size,
    'stake', r.stake,
    'player_o', r.player_o,
    'player_x', r.player_x,
    'my_mark', v_mark,
    'board', r.board,
    'current_turn', r.current_turn,
    'move_count', r.move_count,
    'winner', r.winner,
    'room_status', r.status,
    'code', r.code,
    'visibility', r.visibility,
    'expires_at', r.expires_at,
    'updated_at', r.updated_at
  );
end;
$$;

revoke all on function public.get_online_room(uuid) from public;
grant execute on function public.get_online_room(uuid) to authenticated;

-- Moves only when active (reject waiting/cancelled/expired)
create or replace function public.submit_online_move(
  p_room_id uuid,
  p_cell_index integer,
  p_expected_move_count integer
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  r public.multiplayer_rooms%rowtype;
  v_mark text;
  v_board jsonb;
  v_cell jsonb;
  v_n integer;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  select * into r
  from public.multiplayer_rooms
  where id = p_room_id
  for update;

  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Room not found');
  end if;

  if v_uid is distinct from r.player_o
     and v_uid is distinct from r.player_x then
    return jsonb_build_object('status', 'error', 'message', 'Not a participant');
  end if;

  if r.status in ('waiting', 'cancelled', 'expired', 'finished', 'completed', 'abandoned') then
    return jsonb_build_object('status', 'error', 'message', 'Room closed');
  end if;

  if r.status = 'matched' then
    r.status := 'active';
  end if;

  if r.player_x is null then
    return jsonb_build_object('status', 'error', 'message', 'Waiting for opponent');
  end if;

  if r.board is null then
    r.board := public._mp_empty_board(r.board_size);
  end if;

  if p_expected_move_count is distinct from r.move_count then
    return jsonb_build_object(
      'status', 'stale',
      'message', 'Board changed — refresh snapshot',
      'move_count', r.move_count
    );
  end if;

  v_mark := case when v_uid = r.player_o then 'O' else 'X' end;

  if r.current_turn is distinct from v_mark then
    return jsonb_build_object('status', 'error', 'message', 'Not your turn');
  end if;

  v_n := r.board_size * r.board_size;
  if p_cell_index is null or p_cell_index < 0 or p_cell_index >= v_n then
    return jsonb_build_object('status', 'error', 'message', 'Invalid cell');
  end if;

  v_cell := r.board -> p_cell_index;
  if v_cell is not null and v_cell <> 'null'::jsonb then
    return jsonb_build_object('status', 'error', 'message', 'Cell occupied');
  end if;

  v_board := jsonb_set(r.board, array[p_cell_index::text], to_jsonb(v_mark), true);

  update public.multiplayer_rooms
  set board = v_board,
      current_turn = case when v_mark = 'O' then 'X' else 'O' end,
      move_count = r.move_count + 1,
      status = 'active',
      updated_at = now()
  where id = p_room_id
  returning * into r;

  return public.get_online_room(p_room_id);
end;
$$;

revoke all on function public.submit_online_move(uuid, integer, integer) from public;
grant execute on function public.submit_online_move(uuid, integer, integer) to authenticated;
