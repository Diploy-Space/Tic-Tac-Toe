-- Fix: ensure in-game chat tables are in supabase_realtime publication.
-- If chat send works but the other player never sees messages live, run this.
-- Paste into Supabase SQL Editor → Run.

do $$
begin
  begin
    alter publication supabase_realtime add table public.game_chat_messages;
  exception
    when duplicate_object then null;
    when undefined_table then
      raise notice 'game_chat_messages missing — apply 010_game_chat.sql first';
    when undefined_object then
      raise notice 'supabase_realtime publication missing — enable Realtime in Dashboard';
    when others then
      raise notice 'Realtime add game_chat_messages: %', SQLERRM;
  end;
  begin
    alter publication supabase_realtime add table public.game_chat_reactions;
  exception
    when duplicate_object then null;
    when undefined_table then
      raise notice 'game_chat_reactions missing — apply 010_game_chat.sql first';
    when undefined_object then
      raise notice 'supabase_realtime publication missing — enable Realtime in Dashboard';
    when others then
      raise notice 'Realtime add game_chat_reactions: %', SQLERRM;
  end;
end $$;

alter table public.game_chat_messages replica identity full;
alter table public.game_chat_reactions replica identity full;

-- Verify (optional): should list both tables
-- select schemaname, tablename
-- from pg_publication_tables
-- where pubname = 'supabase_realtime'
--   and tablename in ('game_chat_messages', 'game_chat_reactions');
