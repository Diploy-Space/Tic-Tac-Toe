-- One-paste fix for broken in-game chat (tested 2026-11-13).
-- Live probe error was:
--   permission denied for function _mp_is_room_participant
-- Supabase Dashboard → SQL Editor → paste all → Run.

grant execute on function public._mp_is_room_participant(uuid, uuid)
  to authenticated;

grant execute on function public._mp_can_react_to_message(uuid, uuid)
  to authenticated;

revoke all on function public._mp_is_room_participant(uuid, uuid) from anon;
revoke all on function public._mp_can_react_to_message(uuid, uuid) from anon;

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
