-- Paste into Supabase SQL Editor → Run.
-- Player ID: a permanent sequential number per player (1, 2, 3 …).
-- The app shows at least 3 digits: 12 → "ID 012", 1300 → "ID 1300".

create sequence if not exists public.profiles_player_no_seq;

alter table public.profiles
add column if not exists player_no bigint;

-- Existing players: number them in sign-up order.
with
    ordered as (
        select id, row_number() over (
                order by created_at, id
            ) as n
        from public.profiles
        where
            player_no is null
    )
update public.profiles p
set
    player_no = (
        select coalesce(max(player_no), 0)
        from public.profiles
    ) + o.n
from ordered o
where
    p.id = o.id;

-- Continue the sequence after the highest number in use.
select setval (
        'public.profiles_player_no_seq', greatest(
            (
                select coalesce(max(player_no), 0)
                from public.profiles
            ), 1
        ), (
            select max(player_no)
            from public.profiles
        ) is not null
    );

-- New players get the next number automatically.
alter table public.profiles
alter column player_no
set default nextval (
    'public.profiles_player_no_seq'
);

alter sequence public.profiles_player_no_seq owned by public.profiles.player_no;

alter table public.profiles alter column player_no set not null;

create unique index if not exists profiles_player_no_unique on public.profiles (player_no);

-- Read-only for clients; nobody can change their own number.
grant
select (player_no) on
table public.profiles to anon, authenticated;