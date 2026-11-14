-- Allow optional screenshots on game reports (PDF UI: screenshots optional).
-- Paste into Supabase SQL Editor → Run.

alter table public.game_reports
  alter column screenshot_path drop not null;

create or replace function public.submit_game_report(
  p_room_id uuid,
  p_reason text,
  p_description text,
  p_screenshot_path text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_room public.multiplayer_rooms%rowtype;
  v_reported uuid;
  v_id uuid;
  v_recent int;
  v_path text;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  if p_reason is null or p_reason not in (
    'harassment','offensive','threatening','spam','inappropriate','cheating','other'
  ) then
    return jsonb_build_object('status', 'error', 'message', 'Invalid reason');
  end if;

  if p_description is null or char_length(trim(p_description)) < 10 then
    return jsonb_build_object('status', 'error', 'message', 'Description too short');
  end if;

  v_path := nullif(trim(coalesce(p_screenshot_path, '')), '');
  if v_path is not null then
    if char_length(v_path) < 5 then
      return jsonb_build_object('status', 'error', 'message', 'Invalid screenshot path');
    end if;
    if split_part(v_path, '/', 1) <> v_uid::text then
      return jsonb_build_object('status', 'error', 'message', 'Invalid screenshot path');
    end if;
  end if;

  select * into v_room from public.multiplayer_rooms where id = p_room_id;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Room not found');
  end if;

  if v_room.player_x is null then
    return jsonb_build_object('status', 'error', 'message', 'Opponent required');
  end if;

  if v_uid = v_room.player_o then
    v_reported := v_room.player_x;
  elsif v_uid = v_room.player_x then
    v_reported := v_room.player_o;
  else
    return jsonb_build_object('status', 'error', 'message', 'Not a room participant');
  end if;

  if v_reported is null or v_reported = v_uid then
    return jsonb_build_object('status', 'error', 'message', 'Cannot report this user');
  end if;

  select count(*) into v_recent
  from public.game_reports
  where room_id = p_room_id and reporter_id = v_uid;
  if v_recent > 0 then
    return jsonb_build_object('status', 'error', 'message', 'Already reported in this match');
  end if;

  insert into public.game_reports (
    room_id, reporter_id, reported_user_id, reason, description, screenshot_path
  ) values (
    p_room_id, v_uid, v_reported, p_reason, trim(p_description), v_path
  )
  returning id into v_id;

  return jsonb_build_object(
    'status', 'ok',
    'report_id', v_id,
    'report_status', 'under_review'
  );
end;
$$;

revoke all on function public.submit_game_report(uuid, text, text, text) from public, anon;
grant execute on function public.submit_game_report(uuid, text, text, text) to authenticated;
