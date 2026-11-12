-- Chat reporting + account suspension + appeals.
-- Apply AFTER 010_game_chat.sql. Paste into SQL Editor, then Run.
-- Admin: set profiles.is_admin = true for trusted operator UUIDs via SQL Editor.

-- ---------------------------------------------------------------------------
-- 1) Profile moderation fields
-- ---------------------------------------------------------------------------
alter table public.profiles
  add column if not exists is_admin boolean not null default false;

alter table public.profiles
  add column if not exists account_status text not null default 'active';

alter table public.profiles
  drop constraint if exists profiles_account_status_check;
alter table public.profiles
  add constraint profiles_account_status_check
  check (account_status in ('active', 'suspended', 'under_review'));

alter table public.profiles
  add column if not exists suspension_reason text null;

alter table public.profiles
  add column if not exists suspended_at timestamptz null;

-- Own-row status readable for route guards; public_profiles stays public-safe.
grant select (
  id, username, avatar_url, created_at,
  account_status, suspension_reason, suspended_at
) on table public.profiles to authenticated;

-- Clients must never self-update moderation fields / is_admin.
-- Keep avatar update policy; block account_status changes from client UPDATE.

create or replace function public.profiles_block_moderation_self_update()
returns trigger
language plpgsql
as $$
begin
  if auth.uid() is not null
     and auth.uid() = new.id
     and coalesce(auth.jwt() ->> 'role', '') <> 'service_role' then
    if new.is_admin is distinct from old.is_admin then
      raise exception 'Cannot change admin flag';
    end if;
    if new.account_status is distinct from old.account_status
       or new.suspension_reason is distinct from old.suspension_reason
       or new.suspended_at is distinct from old.suspended_at then
      raise exception 'Cannot change account moderation fields';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_block_moderation_self_update on public.profiles;
create trigger profiles_block_moderation_self_update
before update on public.profiles
for each row execute function public.profiles_block_moderation_self_update();

create or replace function public._is_admin(p_uid uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = p_uid and p.is_admin is true
  );
$$;

revoke all on function public._is_admin(uuid) from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2) Reports
-- ---------------------------------------------------------------------------
create table if not exists public.game_reports (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references public.multiplayer_rooms (id) on delete cascade,
  reporter_id uuid not null references public.profiles (id) on delete cascade,
  reported_user_id uuid not null references public.profiles (id) on delete cascade,
  reason text not null,
  description text not null,
  screenshot_path text not null,
  status text not null default 'pending',
  admin_notes text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint game_reports_reason_check check (
    reason in (
      'harassment',
      'offensive',
      'threatening',
      'spam',
      'inappropriate',
      'cheating',
      'other'
    )
  ),
  constraint game_reports_status_check check (
    status in ('pending', 'under_review', 'resolved', 'dismissed')
  ),
  constraint game_reports_description_len check (
    char_length(trim(description)) between 10 and 2000
  ),
  constraint game_reports_not_self check (reporter_id <> reported_user_id)
);

create index if not exists game_reports_reporter_idx
  on public.game_reports (reporter_id, created_at desc);
create index if not exists game_reports_reported_idx
  on public.game_reports (reported_user_id, created_at desc);
create index if not exists game_reports_status_idx
  on public.game_reports (status, created_at desc);
create index if not exists game_reports_room_idx
  on public.game_reports (room_id);

create or replace function public.set_game_reports_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists game_reports_set_updated_at on public.game_reports;
create trigger game_reports_set_updated_at
before update on public.game_reports
for each row execute function public.set_game_reports_updated_at();

alter table public.game_reports enable row level security;
revoke all on table public.game_reports from anon, authenticated;
grant select, insert on table public.game_reports to authenticated;

drop policy if exists "reports_select_own_or_admin" on public.game_reports;
create policy "reports_select_own_or_admin"
on public.game_reports for select
to authenticated
using (
  reporter_id = auth.uid()
  or public._is_admin(auth.uid())
);

-- Direct inserts blocked; use submit_game_report RPC (server validates opponent).
drop policy if exists "reports_no_direct_insert" on public.game_reports;
-- No insert policy for clients → insert only via security definer RPC.

-- ---------------------------------------------------------------------------
-- 3) Suspensions (history)
-- ---------------------------------------------------------------------------
create table if not exists public.user_suspensions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  report_id uuid null references public.game_reports (id) on delete set null,
  reason text not null,
  status text not null default 'suspended',
  suspended_by uuid not null references public.profiles (id) on delete restrict,
  suspended_at timestamptz not null default now(),
  reinstated_at timestamptz null,
  admin_notes text null,
  constraint user_suspensions_status_check check (
    status in ('suspended', 'reinstated')
  ),
  constraint user_suspensions_reason_len check (
    char_length(trim(reason)) between 3 and 1000
  )
);

create index if not exists user_suspensions_user_idx
  on public.user_suspensions (user_id, suspended_at desc);
create index if not exists user_suspensions_active_idx
  on public.user_suspensions (user_id)
  where status = 'suspended';

alter table public.user_suspensions enable row level security;
revoke all on table public.user_suspensions from anon, authenticated;
grant select on table public.user_suspensions to authenticated;

drop policy if exists "suspensions_select_own_or_admin" on public.user_suspensions;
create policy "suspensions_select_own_or_admin"
on public.user_suspensions for select
to authenticated
using (
  user_id = auth.uid()
  or public._is_admin(auth.uid())
);

-- ---------------------------------------------------------------------------
-- 4) Appeals
-- ---------------------------------------------------------------------------
create table if not exists public.user_appeals (
  id uuid primary key default gen_random_uuid(),
  suspension_id uuid not null references public.user_suspensions (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  appeal_message text not null,
  status text not null default 'pending',
  admin_notes text null,
  reviewed_by uuid null references public.profiles (id) on delete set null,
  submitted_at timestamptz not null default now(),
  reviewed_at timestamptz null,
  constraint user_appeals_status_check check (
    status in ('pending', 'under_review', 'approved', 'rejected')
  ),
  constraint user_appeals_message_len check (
    char_length(trim(appeal_message)) between 20 and 2000
  )
);

create unique index if not exists user_appeals_one_active_per_suspension
  on public.user_appeals (suspension_id)
  where status in ('pending', 'under_review');

create index if not exists user_appeals_user_idx
  on public.user_appeals (user_id, submitted_at desc);

alter table public.user_appeals enable row level security;
revoke all on table public.user_appeals from anon, authenticated;
grant select on table public.user_appeals to authenticated;

drop policy if exists "appeals_select_own_or_admin" on public.user_appeals;
create policy "appeals_select_own_or_admin"
on public.user_appeals for select
to authenticated
using (
  user_id = auth.uid()
  or public._is_admin(auth.uid())
);

-- ---------------------------------------------------------------------------
-- 5) Storage bucket: private report evidence
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'report-evidence',
  'report-evidence',
  false,
  2097152,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "report_evidence_insert_own" on storage.objects;
create policy "report_evidence_insert_own"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'report-evidence'
  and (storage.foldername(name))[1] = auth.uid()::text
);

-- No public read. Admins read via signed URL RPC / storage admin paths.
drop policy if exists "report_evidence_select_admin" on storage.objects;
create policy "report_evidence_select_admin"
on storage.objects for select
to authenticated
using (
  bucket_id = 'report-evidence'
  and public._is_admin(auth.uid())
);

drop policy if exists "report_evidence_select_own" on storage.objects;
create policy "report_evidence_select_own"
on storage.objects for select
to authenticated
using (
  bucket_id = 'report-evidence'
  and (storage.foldername(name))[1] = auth.uid()::text
);

-- ---------------------------------------------------------------------------
-- 6) Player RPCs
-- ---------------------------------------------------------------------------
create or replace function public.get_my_moderation_status()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_prof public.profiles%rowtype;
  v_susp public.user_suspensions%rowtype;
  v_appeal public.user_appeals%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  select * into v_prof from public.profiles where id = v_uid;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Profile missing');
  end if;

  select * into v_susp
  from public.user_suspensions
  where user_id = v_uid and status = 'suspended'
  order by suspended_at desc
  limit 1;

  if v_susp.id is not null then
    select * into v_appeal
    from public.user_appeals
    where suspension_id = v_susp.id
    order by submitted_at desc
    limit 1;
  end if;

  return jsonb_build_object(
    'status', 'ok',
    'account_status', v_prof.account_status,
    'suspension_reason', v_prof.suspension_reason,
    'suspended_at', v_prof.suspended_at,
    'suspension_id', v_susp.id,
    'suspension_status', v_susp.status,
    'appeal_id', v_appeal.id,
    'appeal_status', v_appeal.status,
    'appeal_submitted_at', v_appeal.submitted_at
  );
end;
$$;

revoke all on function public.get_my_moderation_status() from public, anon;
grant execute on function public.get_my_moderation_status() to authenticated;

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

  if p_screenshot_path is null or char_length(trim(p_screenshot_path)) < 5 then
    return jsonb_build_object('status', 'error', 'message', 'Screenshot required');
  end if;

  -- Path must be under reporter's folder.
  if split_part(p_screenshot_path, '/', 1) <> v_uid::text then
    return jsonb_build_object('status', 'error', 'message', 'Invalid screenshot path');
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

  -- Rate limit: 1 report per room per reporter.
  select count(*) into v_recent
  from public.game_reports
  where room_id = p_room_id and reporter_id = v_uid;
  if v_recent > 0 then
    return jsonb_build_object('status', 'error', 'message', 'Already reported in this match');
  end if;

  insert into public.game_reports (
    room_id, reporter_id, reported_user_id, reason, description, screenshot_path
  ) values (
    p_room_id, v_uid, v_reported, p_reason, trim(p_description), trim(p_screenshot_path)
  )
  returning id into v_id;

  return jsonb_build_object('status', 'ok', 'report_id', v_id);
end;
$$;

revoke all on function public.submit_game_report(uuid, text, text, text) from public, anon;
grant execute on function public.submit_game_report(uuid, text, text, text) to authenticated;

create or replace function public.submit_suspension_appeal(p_appeal_message text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_prof public.profiles%rowtype;
  v_susp public.user_suspensions%rowtype;
  v_id uuid;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  if p_appeal_message is null or char_length(trim(p_appeal_message)) < 20 then
    return jsonb_build_object('status', 'error', 'message', 'Appeal message too short');
  end if;

  select * into v_prof from public.profiles where id = v_uid;
  if not found or v_prof.account_status not in ('suspended', 'under_review') then
    return jsonb_build_object('status', 'error', 'message', 'Account is not suspended');
  end if;

  select * into v_susp
  from public.user_suspensions
  where user_id = v_uid and status = 'suspended'
  order by suspended_at desc
  limit 1;

  if not found then
    return jsonb_build_object('status', 'error', 'message', 'No active suspension');
  end if;

  if exists (
    select 1 from public.user_appeals a
    where a.suspension_id = v_susp.id
      and a.status in ('pending', 'under_review')
  ) then
    return jsonb_build_object('status', 'error', 'message', 'Appeal already submitted');
  end if;

  insert into public.user_appeals (suspension_id, user_id, appeal_message, status)
  values (v_susp.id, v_uid, trim(p_appeal_message), 'pending')
  returning id into v_id;

  update public.profiles
  set account_status = 'under_review'
  where id = v_uid;

  return jsonb_build_object(
    'status', 'ok',
    'appeal_id', v_id,
    'suspension_id', v_susp.id,
    'account_status', 'under_review'
  );
end;
$$;

revoke all on function public.submit_suspension_appeal(text) from public, anon;
grant execute on function public.submit_suspension_appeal(text) to authenticated;

-- ---------------------------------------------------------------------------
-- 7) Admin RPCs (require profiles.is_admin)
-- ---------------------------------------------------------------------------
create or replace function public.admin_list_reports(p_limit int default 50)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_rows jsonb;
begin
  if not public._is_admin(v_uid) then
    return jsonb_build_object('status', 'error', 'message', 'Forbidden');
  end if;

  select coalesce(jsonb_agg(to_jsonb(r) order by r.created_at desc), '[]'::jsonb)
  into v_rows
  from (
    select
      g.id, g.room_id, g.reporter_id, g.reported_user_id,
      g.reason, g.description, g.screenshot_path, g.status,
      g.admin_notes, g.created_at, g.updated_at,
      rp.username as reporter_username,
      rd.username as reported_username
    from public.game_reports g
    left join public.profiles rp on rp.id = g.reporter_id
    left join public.profiles rd on rd.id = g.reported_user_id
    order by g.created_at desc
    limit greatest(1, least(coalesce(p_limit, 50), 200))
  ) r;

  return jsonb_build_object('status', 'ok', 'reports', v_rows);
end;
$$;

revoke all on function public.admin_list_reports(int) from public, anon;
grant execute on function public.admin_list_reports(int) to authenticated;

create or replace function public.admin_update_report(
  p_report_id uuid,
  p_status text,
  p_admin_notes text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
begin
  if not public._is_admin(v_uid) then
    return jsonb_build_object('status', 'error', 'message', 'Forbidden');
  end if;
  if p_status not in ('pending', 'under_review', 'resolved', 'dismissed') then
    return jsonb_build_object('status', 'error', 'message', 'Invalid status');
  end if;

  update public.game_reports
  set status = p_status,
      admin_notes = coalesce(p_admin_notes, admin_notes)
  where id = p_report_id;

  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Report not found');
  end if;

  return jsonb_build_object('status', 'ok');
end;
$$;

revoke all on function public.admin_update_report(uuid, text, text) from public, anon;
grant execute on function public.admin_update_report(uuid, text, text) to authenticated;

create or replace function public.admin_suspend_user(
  p_user_id uuid,
  p_reason text,
  p_report_id uuid default null,
  p_admin_notes text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_id uuid;
begin
  if not public._is_admin(v_uid) then
    return jsonb_build_object('status', 'error', 'message', 'Forbidden');
  end if;
  if p_user_id is null or p_user_id = v_uid then
    return jsonb_build_object('status', 'error', 'message', 'Invalid user');
  end if;
  if p_reason is null or char_length(trim(p_reason)) < 3 then
    return jsonb_build_object('status', 'error', 'message', 'Reason required');
  end if;
  if public._is_admin(p_user_id) then
    return jsonb_build_object('status', 'error', 'message', 'Cannot suspend an admin');
  end if;

  insert into public.user_suspensions (
    user_id, report_id, reason, status, suspended_by, admin_notes
  ) values (
    p_user_id, p_report_id, trim(p_reason), 'suspended', v_uid, p_admin_notes
  )
  returning id into v_id;

  update public.profiles
  set account_status = 'suspended',
      suspension_reason = trim(p_reason),
      suspended_at = now()
  where id = p_user_id;

  if p_report_id is not null then
    update public.game_reports
    set status = 'resolved',
        admin_notes = coalesce(p_admin_notes, admin_notes)
    where id = p_report_id;
  end if;

  return jsonb_build_object('status', 'ok', 'suspension_id', v_id);
end;
$$;

revoke all on function public.admin_suspend_user(uuid, text, uuid, text) from public, anon;
grant execute on function public.admin_suspend_user(uuid, text, uuid, text) to authenticated;

create or replace function public.admin_list_appeals(p_limit int default 50)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_rows jsonb;
begin
  if not public._is_admin(v_uid) then
    return jsonb_build_object('status', 'error', 'message', 'Forbidden');
  end if;

  select coalesce(jsonb_agg(to_jsonb(r) order by r.submitted_at desc), '[]'::jsonb)
  into v_rows
  from (
    select
      a.id, a.suspension_id, a.user_id, a.appeal_message, a.status,
      a.admin_notes, a.reviewed_by, a.submitted_at, a.reviewed_at,
      p.username,
      s.reason as suspension_reason,
      s.report_id
    from public.user_appeals a
    join public.profiles p on p.id = a.user_id
    join public.user_suspensions s on s.id = a.suspension_id
    order by a.submitted_at desc
    limit greatest(1, least(coalesce(p_limit, 50), 200))
  ) r;

  return jsonb_build_object('status', 'ok', 'appeals', v_rows);
end;
$$;

revoke all on function public.admin_list_appeals(int) from public, anon;
grant execute on function public.admin_list_appeals(int) to authenticated;

create or replace function public.admin_review_appeal(
  p_appeal_id uuid,
  p_decision text,
  p_admin_notes text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_appeal public.user_appeals%rowtype;
begin
  if not public._is_admin(v_uid) then
    return jsonb_build_object('status', 'error', 'message', 'Forbidden');
  end if;
  if p_decision not in ('approved', 'rejected') then
    return jsonb_build_object('status', 'error', 'message', 'Invalid decision');
  end if;

  select * into v_appeal from public.user_appeals where id = p_appeal_id;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Appeal not found');
  end if;
  if v_appeal.status in ('approved', 'rejected') then
    return jsonb_build_object('status', 'error', 'message', 'Appeal already reviewed');
  end if;

  update public.user_appeals
  set status = p_decision,
      admin_notes = coalesce(p_admin_notes, admin_notes),
      reviewed_by = v_uid,
      reviewed_at = now()
  where id = p_appeal_id;

  if p_decision = 'approved' then
    update public.user_suspensions
    set status = 'reinstated',
        reinstated_at = now(),
        admin_notes = coalesce(p_admin_notes, admin_notes)
    where id = v_appeal.suspension_id
      and status = 'suspended';

    update public.profiles
    set account_status = 'active',
        suspension_reason = null,
        suspended_at = null
    where id = v_appeal.user_id;
  else
    -- Rejected: remain suspended (clear under_review marker).
    update public.profiles
    set account_status = 'suspended'
    where id = v_appeal.user_id
      and account_status <> 'active';
  end if;

  return jsonb_build_object('status', 'ok', 'decision', p_decision);
end;
$$;

revoke all on function public.admin_review_appeal(uuid, text, text) from public, anon;
grant execute on function public.admin_review_appeal(uuid, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- 8) Realtime for live suspension detection (own profile row)
-- ---------------------------------------------------------------------------
do $$
begin
  begin
    alter publication supabase_realtime add table public.profiles;
  exception
    when duplicate_object then null;
    when undefined_object then
      raise notice 'supabase_realtime publication missing';
    when others then
      raise notice 'Realtime add profiles: %', SQLERRM;
  end;
end $$;

alter table public.profiles replica identity full;

-- Promote an admin (run manually with a real user UUID):
-- update public.profiles set is_admin = true where id = '<admin-uuid>';
