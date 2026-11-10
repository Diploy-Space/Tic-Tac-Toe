-- C2: Room board state + snapshot/move RPCs + Realtime publication
-- Apply AFTER 005_multiplayer_queue.sql. Paste entire file, then Run.
-- Source of truth = PostgreSQL. Realtime is notify-only; clients always re-fetch.

-- 1) Board columns on rooms
alter table public.multiplayer_rooms
  add column if not exists board jsonb,
  add column if not exists current_turn text not null default 'O',
  add column if not exists move_count integer not null default 0,
  add column if not exists winner text null,
  add column if not exists updated_at timestamptz not null default now();

alter table public.multiplayer_rooms
  drop constraint if exists multiplayer_rooms_current_turn_check;
alter table public.multiplayer_rooms
  add constraint multiplayer_rooms_current_turn_check
  check (current_turn in ('O', 'X'));

alter table public.multiplayer_rooms
  drop constraint if exists multiplayer_rooms_winner_check;
alter table public.multiplayer_rooms
  add constraint multiplayer_rooms_winner_check
  check (winner is null or winner in ('O', 'X', 'draw'));

alter table public.multiplayer_rooms
  drop constraint if exists multiplayer_rooms_move_count_nonnegative;
alter table public.multiplayer_rooms
  add constraint multiplayer_rooms_move_count_nonnegative
  check (move_count >= 0);

-- Empty board helper
create or replace function public._mp_empty_board(p_size integer)
returns jsonb
language sql
immutable
as $$
  select coalesce(
    (select jsonb_agg(null::text)
     from generate_series(1, greatest(p_size, 0) * greatest(p_size, 0))),
    '[]'::jsonb
  );
$$;

revoke all on function public._mp_empty_board(integer) from public, anon, authenticated;

-- Backfill existing matched rooms without a board
update public.multiplayer_rooms
set board = public._mp_empty_board(board_size),
    current_turn = coalesce(current_turn, 'O'),
    move_count = coalesce(move_count, 0),
    updated_at = now()
where board is null;

-- Ensure new rooms from pairing include board (replace join body pieces via new helper)
create or replace function public._mp_init_room_board()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.board is null then
    new.board := public._mp_empty_board(new.board_size);
  end if;
  if new.current_turn is null then
    new.current_turn := 'O';
  end if;
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists multiplayer_rooms_init_board on public.multiplayer_rooms;
create trigger multiplayer_rooms_init_board
before insert or update on public.multiplayer_rooms
for each row execute function public._mp_init_room_board();

-- 2) Snapshot RPC (join / reconnect / after Realtime hint)
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

  select * into r from public.multiplayer_rooms where id = p_room_id;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Room not found');
  end if;

  if v_uid <> r.player_o and v_uid <> r.player_x then
    return jsonb_build_object('status', 'error', 'message', 'Not a participant');
  end if;

  -- Activate matched room on first snapshot fetch
  if r.status = 'matched' then
    update public.multiplayer_rooms
    set status = 'active',
        board = coalesce(board, public._mp_empty_board(board_size)),
        updated_at = now()
    where id = p_room_id
    returning * into r;
  end if;

  if r.board is null then
    update public.multiplayer_rooms
    set board = public._mp_empty_board(board_size), updated_at = now()
    where id = p_room_id
    returning * into r;
  end if;

  v_mark := case when v_uid = r.player_o then 'O' else 'X' end;

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
    'updated_at', r.updated_at
  );
end;
$$;

revoke all on function public.get_online_room(uuid) from public;
grant execute on function public.get_online_room(uuid) to authenticated;

-- 3) Lightweight move submit (C2 sync). Full win/forfeit validation is C4.
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

  if v_uid <> r.player_o and v_uid <> r.player_x then
    return jsonb_build_object('status', 'error', 'message', 'Not a participant');
  end if;

  if r.status in ('finished', 'abandoned') then
    return jsonb_build_object('status', 'error', 'message', 'Room closed');
  end if;

  if r.status = 'matched' then
    r.status := 'active';
  end if;

  if r.board is null then
    r.board := public._mp_empty_board(r.board_size);
  end if;

  -- Stale client (optimistic concurrency)
  if p_expected_move_count is distinct from r.move_count then
    return jsonb_build_object(
      'status', 'stale',
      'message', 'Board changed — refresh snapshot',
      'move_count', r.move_count
    );
  end if;

  v_mark := case when v_uid = r.player_o then 'O' else 'X' end;

  -- Minimal turn gate so both clients can play alternately (hardened in C4)
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

-- 4) Realtime: clients subscribe; still re-fetch snapshot on every event
do $$
begin
  begin
    alter publication supabase_realtime add table public.multiplayer_rooms;
  exception
    when duplicate_object then null;
    when undefined_object then
      raise notice 'supabase_realtime publication missing — enable Realtime in Dashboard';
    when others then
      raise notice 'Realtime add table: %', SQLERRM;
  end;
end $$;

-- Replica identity full helps old/new payloads if needed
alter table public.multiplayer_rooms replica identity full;
