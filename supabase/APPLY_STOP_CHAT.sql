-- Stop Chat: either participant can disable in-match chat for BOTH players.
-- Paste into Supabase SQL Editor → Run.

alter table public.multiplayer_rooms
  add column if not exists chat_stopped boolean not null default false;

-- 1) Stop chat RPC (participants only)
create or replace function public.stop_room_chat(p_room_id uuid)
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
  if p_room_id is null then
    return jsonb_build_object('status', 'error', 'message', 'room_id required');
  end if;

  select * into r from public.multiplayer_rooms where id = p_room_id for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Room not found');
  end if;

  if v_uid is distinct from r.player_o and v_uid is distinct from r.player_x then
    return jsonb_build_object('status', 'error', 'message', 'Not a participant');
  end if;

  if coalesce(r.chat_stopped, false) then
    return jsonb_build_object(
      'status', 'ok',
      'room_id', r.id,
      'chat_stopped', true,
      'message', 'Chat already stopped'
    );
  end if;

  update public.multiplayer_rooms
  set chat_stopped = true,
      updated_at = now()
  where id = p_room_id
  returning * into r;

  return jsonb_build_object(
    'status', 'ok',
    'room_id', r.id,
    'chat_stopped', true
  );
end;
$$;

revoke all on function public.stop_room_chat(uuid) from public, anon;
grant execute on function public.stop_room_chat(uuid) to authenticated;

-- 2) Snapshot includes chat_stopped
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

  if r.visibility = 'private'
     and r.status = 'waiting'
     and r.expires_at is not null
     and r.expires_at < now() then
    update public.multiplayer_rooms
    set status = 'expired', updated_at = now()
    where id = p_room_id
    returning * into r;
  end if;

  if r.status = 'matched' and r.player_x is not null then
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
    'chat_stopped', coalesce(r.chat_stopped, false),
    'updated_at', r.updated_at
  );
end;
$$;

revoke all on function public.get_online_room(uuid) from public;
grant execute on function public.get_online_room(uuid) to authenticated;

-- 3) Block new chat messages when chat is stopped
create or replace function public._mp_is_room_participant(p_room_id uuid, p_uid uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.multiplayer_rooms r
    where r.id = p_room_id
      and p_uid is not null
      and (r.player_o = p_uid or r.player_x = p_uid)
      and r.player_x is not null
  );
$$;

revoke all on function public._mp_is_room_participant(uuid, uuid)
  from public, anon;
grant execute on function public._mp_is_room_participant(uuid, uuid)
  to authenticated;

drop policy if exists "chat_insert_own_as_participant" on public.game_chat_messages;
create policy "chat_insert_own_as_participant"
on public.game_chat_messages for insert
to authenticated
with check (
  sender_id = auth.uid()
  and public._mp_is_room_participant(room_id, auth.uid())
  and exists (
    select 1 from public.multiplayer_rooms r
    where r.id = room_id
      and coalesce(r.chat_stopped, false) = false
  )
);
