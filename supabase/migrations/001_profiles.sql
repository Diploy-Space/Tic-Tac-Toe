-- Profiles table + triggers + RLS
-- Run in Supabase SQL Editor (Production).

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text not null,
  avatar_url text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_username_length check (char_length(username) between 3 and 20),
  constraint profiles_username_format check (username ~ '^[a-z0-9_]+$')
);

create unique index if not exists profiles_username_unique_ci
  on public.profiles (lower(username));

create or replace function public.set_profiles_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_profiles_updated_at();

-- Creates one profile per auth user from metadata key: username
create or replace function public.handle_new_user_profile()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  raw_name text;
  base_name text;
  final_name text;
  suffix int := 0;
begin
  raw_name := coalesce(new.raw_user_meta_data->>'username', '');
  base_name := lower(regexp_replace(trim(raw_name), '[^a-z0-9_]', '', 'g'));

  if char_length(base_name) < 3 then
    base_name := 'player_' || substr(replace(new.id::text, '-', ''), 1, 8);
  end if;
  if char_length(base_name) > 20 then
    base_name := substr(base_name, 1, 20);
  end if;

  final_name := base_name;
  while exists (select 1 from public.profiles p where lower(p.username) = final_name) loop
    suffix := suffix + 1;
    final_name := substr(base_name, 1, greatest(3, 20 - char_length(suffix::text) - 1))
                  || '_' || suffix::text;
  end loop;

  insert into public.profiles (id, username)
  values (new.id, final_name)
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created_profile on auth.users;
create trigger on_auth_user_created_profile
after insert on auth.users
for each row execute function public.handle_new_user_profile();

-- Backfill existing auth users
do $$
declare
  r record;
  raw_name text;
  base_name text;
  final_name text;
  suffix int;
begin
  for r in select id, raw_user_meta_data from auth.users loop
    if exists (select 1 from public.profiles p where p.id = r.id) then
      continue;
    end if;
    raw_name := coalesce(r.raw_user_meta_data->>'username', '');
    base_name := lower(regexp_replace(trim(raw_name), '[^a-z0-9_]', '', 'g'));
    if char_length(base_name) < 3 then
      base_name := 'player_' || substr(replace(r.id::text, '-', ''), 1, 8);
    end if;
    if char_length(base_name) > 20 then
      base_name := substr(base_name, 1, 20);
    end if;
    final_name := base_name;
    suffix := 0;
    while exists (select 1 from public.profiles p where lower(p.username) = final_name) loop
      suffix := suffix + 1;
      final_name := substr(base_name, 1, greatest(3, 20 - char_length(suffix::text) - 1))
                    || '_' || suffix::text;
    end loop;
    insert into public.profiles (id, username) values (r.id, final_name);
  end loop;
end $$;

create or replace view public.public_profiles
with (security_invoker = true)
as
select id, username, avatar_url, created_at
from public.profiles;

alter table public.profiles enable row level security;

revoke all on table public.profiles from anon, authenticated;
grant select (id, username, avatar_url, created_at) on table public.profiles to anon, authenticated;
grant update (avatar_url, updated_at) on table public.profiles to authenticated;
grant select on public.public_profiles to anon, authenticated;

drop policy if exists "profiles_select_public_fields" on public.profiles;
create policy "profiles_select_public_fields"
on public.profiles for select
to anon, authenticated
using (true);

drop policy if exists "profiles_update_own_avatar" on public.profiles;
create policy "profiles_update_own_avatar"
on public.profiles for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);
