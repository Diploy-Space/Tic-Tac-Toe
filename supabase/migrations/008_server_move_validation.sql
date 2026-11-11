-- C4: Server-side win/draw validation after moves + forfeit + online match settle.
-- Apply AFTER 007 / 007a. Mirrors lib/game/board.dart:
--   board_size 3 → winLength 3; board_size 4 or 5 → winLength 4.
-- Does not change C1 matchmaking or C3 private-room create/join logic.

-- 1) Link cloud matches to rooms (idempotent online settle)
alter table public.matches
  add column if not exists room_id uuid null references public.multiplayer_rooms (id) on delete set null;

create unique index if not exists matches_user_room_unique
  on public.matches (user_id, room_id)
  where room_id is not null;

-- Block client PostgREST inserts of mode=online unless settler sets GUC.
create or replace function public._matches_guard_online_insert()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if new.mode = 'online' then
    if coalesce(current_setting('tic_tac.allow_online_match', true), '')
       is distinct from '1' then
      raise exception 'online matches must be recorded by the server'
        using errcode = '42501';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists matches_guard_online_insert on public.matches;
create trigger matches_guard_online_insert
before insert on public.matches
for each row execute function public._matches_guard_online_insert();

revoke all on function public._matches_guard_online_insert() from public, anon, authenticated;

-- 2) Board helpers (same geometry as Flutter Board.winsAt)
create or replace function public._mp_cell_mark(p_board jsonb, p_index integer)
returns text
language sql
immutable
as $$
  -- jsonb ->> yields SQL NULL for JSON null; 'O'/'X' without quotes.
  select case
    when p_board is null or p_index is null then null
    else p_board ->> p_index
  end;
$$;

revoke all on function public._mp_cell_mark(jsonb, integer) from public, anon, authenticated;

create or replace function public._mp_win_length(p_board_size integer)
returns integer
language sql
immutable
as $$
  select case when p_board_size = 3 then 3 else 4 end;
$$;

revoke all on function public._mp_win_length(integer) from public, anon, authenticated;

create or replace function public._mp_wins_at(
  p_board jsonb,
  p_board_size integer,
  p_index integer,
  p_mark text
)
returns boolean
language plpgsql
immutable
as $$
declare
  v_need integer := public._mp_win_length(p_board_size);
  v_r integer;
  v_c integer;
  v_dr integer;
  v_dc integer;
  v_s integer;
  v_rr integer;
  v_cc integer;
  v_count integer;
begin
  if p_board is null or p_board_size is null or p_index is null or p_mark is null then
    return false;
  end if;
  if public._mp_cell_mark(p_board, p_index) is distinct from p_mark then
    return false;
  end if;

  v_r := p_index / p_board_size;
  v_c := p_index % p_board_size;

  for v_dr, v_dc in
    select * from (values (0, 1), (1, 0), (1, 1), (1, -1)) as t(dr, dc)
  loop
    v_count := 1;
    foreach v_s in array array[-1, 1] loop
      v_rr := v_r + v_dr * v_s;
      v_cc := v_c + v_dc * v_s;
      while v_rr >= 0 and v_rr < p_board_size
        and v_cc >= 0 and v_cc < p_board_size
        and public._mp_cell_mark(p_board, v_rr * p_board_size + v_cc) = p_mark
      loop
        v_count := v_count + 1;
        v_rr := v_rr + v_dr * v_s;
        v_cc := v_cc + v_dc * v_s;
      end loop;
    end loop;
    if v_count >= v_need then
      return true;
    end if;
  end loop;

  return false;
end;
$$;

revoke all on function public._mp_wins_at(jsonb, integer, integer, text)
  from public, anon, authenticated;

create or replace function public._mp_board_is_full(p_board jsonb, p_board_size integer)
returns boolean
language plpgsql
immutable
as $$
declare
  v_n integer := p_board_size * p_board_size;
  v_i integer;
begin
  if p_board is null or jsonb_typeof(p_board) is distinct from 'array' then
    return false;
  end if;
  if jsonb_array_length(p_board) is distinct from v_n then
    return false;
  end if;
  for v_i in 0 .. v_n - 1 loop
    if public._mp_cell_mark(p_board, v_i) is null then
      return false;
    end if;
  end loop;
  return true;
end;
$$;

revoke all on function public._mp_board_is_full(jsonb, integer)
  from public, anon, authenticated;

-- 3) Record both players' online results (idempotent per user+room)
create or replace function public._mp_settle_online_room(p_room_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  r public.multiplayer_rooms%rowtype;
  v_o_result text;
  v_x_result text;
  v_o_delta integer;
  v_x_delta integer;
begin
  select * into r from public.multiplayer_rooms where id = p_room_id;
  if not found then
    return;
  end if;
  if r.winner is null or r.player_o is null or r.player_x is null then
    return;
  end if;

  if r.winner = 'draw' then
    v_o_result := 'draw';
    v_x_result := 'draw';
    v_o_delta := 0;
    v_x_delta := 0;
  elsif r.winner = 'O' then
    v_o_result := 'win';
    v_x_result := 'loss';
    v_o_delta := r.stake;
    v_x_delta := -r.stake;
  elsif r.winner = 'X' then
    v_o_result := 'loss';
    v_x_result := 'win';
    v_o_delta := -r.stake;
    v_x_delta := r.stake;
  else
    return;
  end if;

  perform set_config('tic_tac.allow_online_match', '1', true);

  insert into public.matches (
    id, user_id, opponent_user_id, opponent_name, result, board_size, mode,
    difficulty, stake, coin_delta, played_at, room_id
  )
  select
    gen_random_uuid(), r.player_o, r.player_x, null, v_o_result, r.board_size,
    'online', null, r.stake, v_o_delta, now(), r.id
  where not exists (
    select 1 from public.matches m
    where m.user_id = r.player_o and m.room_id = r.id
  );

  insert into public.matches (
    id, user_id, opponent_user_id, opponent_name, result, board_size, mode,
    difficulty, stake, coin_delta, played_at, room_id
  )
  select
    gen_random_uuid(), r.player_x, r.player_o, null, v_x_result, r.board_size,
    'online', null, r.stake, v_x_delta, now(), r.id
  where not exists (
    select 1 from public.matches m
    where m.user_id = r.player_x and m.room_id = r.id
  );
end;
$$;

revoke all on function public._mp_settle_online_room(uuid)
  from public, anon, authenticated;

-- 4) Hardened move submit (same signature — Flutter unchanged)
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
  v_winner text;
  v_next_turn text;
  v_status text;
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

  if r.winner is not null
     or r.status in (
       'waiting', 'cancelled', 'expired', 'finished', 'completed', 'abandoned'
     ) then
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

  v_n := r.board_size * r.board_size;
  if jsonb_typeof(r.board) is distinct from 'array'
     or jsonb_array_length(r.board) is distinct from v_n then
    return jsonb_build_object('status', 'error', 'message', 'Invalid board state');
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

  if p_cell_index is null or p_cell_index < 0 or p_cell_index >= v_n then
    return jsonb_build_object('status', 'error', 'message', 'Invalid cell');
  end if;

  v_cell := r.board -> p_cell_index;
  if v_cell is not null and v_cell <> 'null'::jsonb then
    return jsonb_build_object('status', 'error', 'message', 'Cell occupied');
  end if;

  v_board := jsonb_set(r.board, array[p_cell_index::text], to_jsonb(v_mark), true);

  -- Server-derived terminal state (never trust client)
  if public._mp_wins_at(v_board, r.board_size, p_cell_index, v_mark) then
    v_winner := v_mark;
    v_status := 'finished';
    v_next_turn := v_mark;
  elsif public._mp_board_is_full(v_board, r.board_size) then
    v_winner := 'draw';
    v_status := 'finished';
    v_next_turn := v_mark;
  else
    v_winner := null;
    v_status := 'active';
    v_next_turn := case when v_mark = 'O' then 'X' else 'O' end;
  end if;

  update public.multiplayer_rooms
  set board = v_board,
      current_turn = v_next_turn,
      move_count = r.move_count + 1,
      winner = v_winner,
      status = v_status,
      updated_at = now()
  where id = p_room_id
  returning * into r;

  if v_winner is not null then
    perform public._mp_settle_online_room(p_room_id);
  end if;

  return public.get_online_room(p_room_id);
end;
$$;

revoke all on function public.submit_online_move(uuid, integer, integer) from public;
grant execute on function public.submit_online_move(uuid, integer, integer) to authenticated;

-- 5) Forfeit / resign (opponent wins)
create or replace function public.forfeit_online_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  r public.multiplayer_rooms%rowtype;
  v_winner text;
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

  if r.player_x is null then
    return jsonb_build_object('status', 'error', 'message', 'Waiting for opponent');
  end if;

  if r.winner is not null
     or r.status in (
       'waiting', 'cancelled', 'expired', 'finished', 'completed', 'abandoned'
     ) then
    return public.get_online_room(p_room_id);
  end if;

  if r.status not in ('matched', 'active') then
    return jsonb_build_object('status', 'error', 'message', 'Room closed');
  end if;

  v_winner := case when v_uid = r.player_o then 'X' else 'O' end;

  update public.multiplayer_rooms
  set winner = v_winner,
      status = 'finished',
      updated_at = now()
  where id = p_room_id;

  perform public._mp_settle_online_room(p_room_id);

  return public.get_online_room(p_room_id);
end;
$$;

revoke all on function public.forfeit_online_room(uuid) from public;
grant execute on function public.forfeit_online_room(uuid) to authenticated;
