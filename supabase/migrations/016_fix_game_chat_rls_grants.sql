-- HOTFIX: in-game chat RLS was broken.
-- Symptom: insert/select on game_chat_messages returns:
--   permission denied for function _mp_is_room_participant
-- Cause: 010 revoked EXECUTE from authenticated, but RLS policies call that fn.
-- Fix: grant EXECUTE on the security-definer helpers to authenticated.
--
-- Paste into Supabase SQL Editor → Run.

grant execute on function public._mp_is_room_participant(uuid, uuid)
  to authenticated;

grant execute on function public._mp_can_react_to_message(uuid, uuid)
  to authenticated;

-- Keep anon blocked
revoke all on function public._mp_is_room_participant(uuid, uuid) from anon;
revoke all on function public._mp_can_react_to_message(uuid, uuid) from anon;

-- Also ensure Realtime publication (safe if already added)
do $$
begin
  begin
    alter publication supabase_realtime add table public.game_chat_messages;
  exception when duplicate_object then null; when others then null;
  end;
  begin
    alter publication supabase_realtime add table public.game_chat_reactions;
  exception when duplicate_object then null; when others then null;
  end;
end $$;

alter table public.game_chat_messages replica identity full;
alter table public.game_chat_reactions replica identity full;
