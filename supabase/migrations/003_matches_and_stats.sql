-- Match history + read-only statistics / leaderboard
-- Apply AFTER 001_profiles.sql and 002_avatars_storage.sql.
-- Does not alter profiles, triggers, or avatar storage policies.
--
-- Score formula (must match Flutter PlayerStats): win=10, draw=2, loss=0.
-- Cloud-eligible modes only: ai, quick_match, online.
-- Pass and Play is NOT a valid matches.mode (never stored / never ranked).
-- quick_match = simulated AI random match; online reserved for future real PvP.
--
-- Paste this ENTIRE file into one SQL Editor query, then Run.

-- 1) matches
create table if not exists public.matches (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  opponent_user_id uuid null references public.profiles (id) on delete set null,
  opponent_name text null,
  result text not null,
  board_size integer not null,
  mode text not null,
  difficulty text null,
  stake integer not null default 0,
  coin_delta integer not null default 0,
  played_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  constraint matches_result_check check (result in ('win', 'loss', 'draw')),
  constraint matches_board_size_check check (board_size in (3, 4, 5)),
  constraint matches_mode_check check (mode in ('ai', 'quick_match', 'online')),
  -- NULL is allowed: SQL CHECK treats UNKNOWN as pass
  constraint matches_difficulty_check check (difficulty in ('Easy', 'Medium', 'Hard')),
  constraint matches_stake_nonnegative check (stake >= 0),
  constraint matches_opponent_not_self check (
    opponent_user_id is null or opponent_user_id <> user_id
  )
);

comment on table public.matches is
  'Completed cloud matches for signed-in users. Client may supply id for idempotent inserts.';
comment on column public.matches.mode is
  'ai = vs The Doll; quick_match = simulated random AI; online = future real PvP. No pass_play.';
comment on column public.matches.coin_delta is
  'Per-match coin change only. Not cumulative score.';

create index if not exists matches_user_id_played_at_idx
  on public.matches (user_id, played_at desc);

create index if not exists matches_user_id_mode_result_idx
  on public.matches (user_id, mode, result);

-- 2) RLS
alter table public.matches enable row level security;

revoke all on table public.matches from anon, authenticated;
grant select, insert on table public.matches to authenticated;

drop policy if exists "matches_select_own" on public.matches;
create policy "matches_select_own"
on public.matches for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "matches_insert_own" on public.matches;
create policy "matches_insert_own"
on public.matches for insert
to authenticated
with check (auth.uid() = user_id);

-- 3) Own statistics (RLS + security_invoker)
create or replace view public.my_match_statistics
with (security_invoker = true)
as
select
  m.user_id,
  count(*)::integer as played,
  count(*) filter (where m.result = 'win')::integer as wins,
  count(*) filter (where m.result = 'loss')::integer as losses,
  count(*) filter (where m.result = 'draw')::integer as draws,
  (
    count(*) filter (where m.result = 'win') * 10
    + count(*) filter (where m.result = 'draw') * 2
  )::integer as score,
  case
    when count(*) = 0 then 0::numeric
    else round(
      (count(*) filter (where m.result = 'win'))::numeric / count(*)::numeric,
      4
    )
  end as win_rate
from public.matches m
where m.mode in ('ai', 'quick_match', 'online')
  and m.user_id = auth.uid()
group by m.user_id;

revoke all on public.my_match_statistics from anon, authenticated;
grant select on public.my_match_statistics to authenticated;

-- 4) Public leaderboard (security_invoker = false so aggregates see all eligible matches)
create or replace view public.leaderboard
with (security_invoker = false)
as
with eligible as (
  select
    user_id,
    count(*)::integer as played,
    count(*) filter (where result = 'win')::integer as wins,
    count(*) filter (where result = 'loss')::integer as losses,
    count(*) filter (where result = 'draw')::integer as draws
  from public.matches
  where mode in ('ai', 'quick_match', 'online')
  group by user_id
),
scored as (
  select
    e.user_id,
    e.played,
    e.wins,
    e.losses,
    e.draws,
    (e.wins * 10 + e.draws * 2)::integer as score,
    case
      when e.played = 0 then 0::numeric
      else round(e.wins::numeric / e.played::numeric, 4)
    end as win_rate
  from eligible e
)
select
  p.id as user_id,
  p.username,
  p.avatar_url,
  s.played,
  s.wins,
  s.losses,
  s.draws,
  s.score,
  s.win_rate,
  row_number() over (
    order by s.score desc, s.wins desc, s.win_rate desc, p.id asc
  )::integer as rank
from scored s
join public.profiles p on p.id = s.user_id;

revoke all on public.leaderboard from anon, authenticated;
grant select on public.leaderboard to anon, authenticated;
