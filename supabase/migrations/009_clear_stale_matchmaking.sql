-- Fix: join_online_matchmaking must not revive finished/abandoned rooms.
-- leave_online_matchmaking must clear any queue row (not only searching).
-- Apply AFTER 008. Paste into SQL Editor, then Run.

-- 1) Leave clears the whole queue row for this user
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
  where user_id = v_uid;

  return jsonb_build_object('status', 'cancelled');
end;
$$;

revoke all on function public.leave_online_matchmaking() from public;
grant execute on function public.leave_online_matchmaking() to authenticated;

-- 2) Join: only reuse matched queue if the room is still playable
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
  v_room public.multiplayer_rooms%rowtype;
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

  perform pg_advisory_xact_lock(hashtext('mp_queue_' || v_uid::text));

  select * into v_existing
  from public.multiplayer_queue
  where user_id = v_uid
  for update;

  if found then
    if v_existing.status = 'matched' and v_existing.room_id is not null then
      select * into v_room
      from public.multiplayer_rooms
      where id = v_existing.room_id;

      -- Reuse only if room still playable (not finished / abandoned / etc.)
      if found
         and v_room.winner is null
         and v_room.status in ('matched', 'active')
         and v_room.player_o is not null
         and v_room.player_x is not null then
        return public._mp_match_payload(v_uid, v_existing.room_id);
      end if;
      -- Stale matched entry → drop and re-queue
    end if;
    delete from public.multiplayer_queue where user_id = v_uid;
  end if;

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

-- 3) When a room finishes, clear both players from the queue
create or replace function public._mp_clear_queue_for_room(p_room_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from public.multiplayer_queue
  where room_id = p_room_id;
end;
$$;

revoke all on function public._mp_clear_queue_for_room(uuid)
  from public, anon, authenticated;

-- Patch settle to clear queue after recording matches
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

  perform public._mp_clear_queue_for_room(p_room_id);
end;
$$;

revoke all on function public._mp_settle_online_room(uuid)
  from public, anon, authenticated;
