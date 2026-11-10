-- Friends, mission claims, achievement unlocks + RLS
-- Apply AFTER 001–003. Paste entire file into SQL Editor, then Run.

-- 1) Friendships
create table if not exists public.friendships (
  id uuid primary key default gen_random_uuid(),
  requester_id uuid not null references public.profiles (id) on delete cascade,
  addressee_id uuid not null references public.profiles (id) on delete cascade,
  status text not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint friendships_status_check check (status in ('pending', 'accepted', 'declined')),
  constraint friendships_not_self check (requester_id <> addressee_id)
);

create unique index if not exists friendships_pair_unique
  on public.friendships (
    least(requester_id, addressee_id),
    greatest(requester_id, addressee_id)
  );

create index if not exists friendships_requester_idx on public.friendships (requester_id, status);
create index if not exists friendships_addressee_idx on public.friendships (addressee_id, status);

create or replace function public.set_friendships_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists friendships_set_updated_at on public.friendships;
create trigger friendships_set_updated_at
before update on public.friendships
for each row execute function public.set_friendships_updated_at();

alter table public.friendships enable row level security;

revoke all on table public.friendships from anon, authenticated;
grant select, insert, update, delete on table public.friendships to authenticated;

drop policy if exists "friendships_select_participants" on public.friendships;
create policy "friendships_select_participants"
on public.friendships for select
to authenticated
using (auth.uid() = requester_id or auth.uid() = addressee_id);

drop policy if exists "friendships_insert_own_request" on public.friendships;
create policy "friendships_insert_own_request"
on public.friendships for insert
to authenticated
with check (
  auth.uid() = requester_id
  and status = 'pending'
);

drop policy if exists "friendships_update_participants" on public.friendships;
create policy "friendships_update_participants"
on public.friendships for update
to authenticated
using (auth.uid() = requester_id or auth.uid() = addressee_id)
with check (auth.uid() = requester_id or auth.uid() = addressee_id);

drop policy if exists "friendships_delete_participants" on public.friendships;
create policy "friendships_delete_participants"
on public.friendships for delete
to authenticated
using (auth.uid() = requester_id or auth.uid() = addressee_id);

-- 2) Mission claims (period-scoped so daily/weekly can reset)
create table if not exists public.mission_claims (
  user_id uuid not null references public.profiles (id) on delete cascade,
  mission_id text not null,
  period_key text not null,
  reward integer not null default 0,
  claimed_at timestamptz not null default now(),
  primary key (user_id, mission_id, period_key),
  constraint mission_claims_reward_nonnegative check (reward >= 0)
);

create index if not exists mission_claims_user_period_idx
  on public.mission_claims (user_id, period_key);

alter table public.mission_claims enable row level security;

revoke all on table public.mission_claims from anon, authenticated;
grant select, insert on table public.mission_claims to authenticated;

drop policy if exists "mission_claims_select_own" on public.mission_claims;
create policy "mission_claims_select_own"
on public.mission_claims for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "mission_claims_insert_own" on public.mission_claims;
create policy "mission_claims_insert_own"
on public.mission_claims for insert
to authenticated
with check (auth.uid() = user_id);

-- 3) Achievement unlocks
create table if not exists public.achievement_unlocks (
  user_id uuid not null references public.profiles (id) on delete cascade,
  achievement_id text not null,
  unlocked_at timestamptz not null default now(),
  primary key (user_id, achievement_id)
);

alter table public.achievement_unlocks enable row level security;

revoke all on table public.achievement_unlocks from anon, authenticated;
grant select, insert on table public.achievement_unlocks to authenticated;

drop policy if exists "achievement_unlocks_select_own" on public.achievement_unlocks;
create policy "achievement_unlocks_select_own"
on public.achievement_unlocks for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "achievement_unlocks_insert_own" on public.achievement_unlocks;
create policy "achievement_unlocks_insert_own"
on public.achievement_unlocks for insert
to authenticated
with check (auth.uid() = user_id);

-- Optional: others can see unlock counts later; for now own-only is enough.
