-- Paste into Supabase SQL Editor (Challenge → real online match)
-- Accepting a challenge creates a real online room for both players.
-- Apply AFTER 022_challenges.sql.
--
-- * challenges.room_id: set on accept; both clients open that room
--   (the challenger learns it via realtime UPDATE on challenges).
-- * Room stakes 0 (free challenge) and 5 (5-coin challenge) are allowed.
-- * Accept is refused (and the challenge cancelled) if the challenger is
--   already in another match.

alter table public.challenges
  add column if not exists room_id uuid null
    references public.multiplayer_rooms (id) on delete set null;

alter table public.multiplayer_rooms
  drop constraint if exists multiplayer_rooms_stake_check;
alter table public.multiplayer_rooms
  add constraint multiplayer_rooms_stake_check
    check (stake in (0, 5, 10, 25, 50, 100));

-- Busy guard used by challenges only. Rooms nobody opened (matched > 2 min)
-- or nobody moved in (active > 15 min) no longer count, so an unopened
-- challenge room can't block both players forever.
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
    where (r.player_o = p_uid or r.player_x = p_uid)
      and r.player_x is not null
      and (
        (r.status = 'waiting')
        or (r.status = 'matched' and r.updated_at > now() - interval '2 minutes')
        or (r.status = 'active' and r.updated_at > now() - interval '15 minutes')
      )
  );
$$;

revoke all on function public._user_in_active_match(uuid) from public, anon, authenticated;

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
  v_room_id uuid;
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

  if not p_accept then
    update public.challenges
    set status = 'declined', updated_at = now()
    where id = c.id
    returning * into c;
    return jsonb_build_object(
      'status', 'ok',
      'id', c.id,
      'challenge_status', c.status
    );
  end if;

  if public._user_in_active_match(v_uid) then
    return jsonb_build_object(
      'status', 'error',
      'message', 'Finish your current match first'
    );
  end if;

  if public._user_in_active_match(c.challenger_id) then
    update public.challenges set status = 'cancelled', updated_at = now()
    where id = c.id;
    return jsonb_build_object(
      'status', 'error',
      'message', 'Player is already in a match'
    );
  end if;

  -- Challenger plays O (moves first), the accepting player X.
  insert into public.multiplayer_rooms (
    board_size, stake, player_o, player_x, status,
    board, current_turn, move_count, visibility, created_at, updated_at
  ) values (
    3,
    case when c.stake_kind = 'coins5' then 5 else 0 end,
    c.challenger_id, v_uid, 'matched',
    public._mp_empty_board(3), 'O', 0, 'matchmade', now(), now()
  )
  returning id into v_room_id;

  update public.challenges
  set status = 'accepted', room_id = v_room_id, updated_at = now()
  where id = c.id
  returning * into c;

  return jsonb_build_object(
    'status', 'ok',
    'id', c.id,
    'challenge_status', c.status,
    'challenger_id', c.challenger_id,
    'challenged_id', c.challenged_id,
    'stake_kind', c.stake_kind,
    'room_id', v_room_id,
    'my_mark', 'X',
    'board_size', 3,
    'stake', case when c.stake_kind = 'coins5' then 5 else 0 end
  );
end;
$$;

revoke all on function public.respond_challenge(uuid, boolean) from public, anon;
grant execute on function public.respond_challenge(uuid, boolean) to authenticated;
