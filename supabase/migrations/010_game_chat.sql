-- In-game chat + emoji reactions for real PvP multiplayer rooms only.
-- Apply AFTER 005–009. Paste into SQL Editor, then Run.

-- 1) Messages
create table if not exists public.game_chat_messages (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references public.multiplayer_rooms (id) on delete cascade,
  sender_id uuid not null references public.profiles (id) on delete cascade,
  message text not null,
  created_at timestamptz not null default now(),
  constraint game_chat_messages_nonempty check (char_length(trim(message)) > 0),
  constraint game_chat_messages_max_len check (char_length(message) <= 500)
);

create index if not exists game_chat_messages_room_created_idx
  on public.game_chat_messages (room_id, created_at asc);

alter table public.game_chat_messages enable row level security;

revoke all on table public.game_chat_messages from anon, authenticated;
grant select, insert on table public.game_chat_messages to authenticated;

-- Participant helpers via room membership
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
  from public, anon, authenticated;

drop policy if exists "chat_select_participants" on public.game_chat_messages;
create policy "chat_select_participants"
on public.game_chat_messages for select
to authenticated
using (public._mp_is_room_participant(room_id, auth.uid()));

drop policy if exists "chat_insert_own_as_participant" on public.game_chat_messages;
create policy "chat_insert_own_as_participant"
on public.game_chat_messages for insert
to authenticated
with check (
  sender_id = auth.uid()
  and public._mp_is_room_participant(room_id, auth.uid())
);

-- No update/delete for clients
drop policy if exists "chat_no_update" on public.game_chat_messages;
drop policy if exists "chat_no_delete" on public.game_chat_messages;

-- 2) Emoji reactions (one emoji per user per message; toggle via delete+insert)
create table if not exists public.game_chat_reactions (
  id uuid primary key default gen_random_uuid(),
  message_id uuid not null references public.game_chat_messages (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  emoji text not null,
  created_at timestamptz not null default now(),
  constraint game_chat_reactions_emoji_check check (
    emoji in ('👍', '❤️', '😂', '🔥', '😮', '👏')
  ),
  constraint game_chat_reactions_unique_user unique (message_id, user_id)
);

create index if not exists game_chat_reactions_message_idx
  on public.game_chat_reactions (message_id);

alter table public.game_chat_reactions enable row level security;

revoke all on table public.game_chat_reactions from anon, authenticated;
grant select, insert, delete on table public.game_chat_reactions to authenticated;

create or replace function public._mp_can_react_to_message(p_message_id uuid, p_uid uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.game_chat_messages m
    where m.id = p_message_id
      and public._mp_is_room_participant(m.room_id, p_uid)
  );
$$;

revoke all on function public._mp_can_react_to_message(uuid, uuid)
  from public, anon, authenticated;

drop policy if exists "chat_react_select" on public.game_chat_reactions;
create policy "chat_react_select"
on public.game_chat_reactions for select
to authenticated
using (public._mp_can_react_to_message(message_id, auth.uid()));

drop policy if exists "chat_react_insert" on public.game_chat_reactions;
create policy "chat_react_insert"
on public.game_chat_reactions for insert
to authenticated
with check (
  user_id = auth.uid()
  and public._mp_can_react_to_message(message_id, auth.uid())
);

drop policy if exists "chat_react_delete_own" on public.game_chat_reactions;
create policy "chat_react_delete_own"
on public.game_chat_reactions for delete
to authenticated
using (user_id = auth.uid());

-- 3) Realtime publication
do $$
begin
  begin
    alter publication supabase_realtime add table public.game_chat_messages;
  exception
    when duplicate_object then null;
    when undefined_object then
      raise notice 'supabase_realtime publication missing — enable Realtime in Dashboard';
    when others then
      raise notice 'Realtime add game_chat_messages: %', SQLERRM;
  end;
  begin
    alter publication supabase_realtime add table public.game_chat_reactions;
  exception
    when duplicate_object then null;
    when undefined_object then
      raise notice 'supabase_realtime publication missing — enable Realtime in Dashboard';
    when others then
      raise notice 'Realtime add game_chat_reactions: %', SQLERRM;
  end;
end $$;

alter table public.game_chat_messages replica identity full;
alter table public.game_chat_reactions replica identity full;
