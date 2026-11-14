-- Paste into Supabase SQL Editor → Run.
-- Challenge privacy + notification prefs on profiles (own row via RPC only).

alter table public.profiles
  add column if not exists challenge_who smallint not null default 0;

alter table public.profiles
  add column if not exists notify_challenge_requests boolean not null default true;

alter table public.profiles
  add column if not exists notify_match_invites boolean not null default true;

alter table public.profiles
  add column if not exists notify_match_results boolean not null default true;

alter table public.profiles
  drop constraint if exists profiles_challenge_who_check;
alter table public.profiles
  add constraint profiles_challenge_who_check
  check (challenge_who in (0, 1, 2));

comment on column public.profiles.challenge_who is
  '0=everyone, 1=friends only, 2=nobody';
comment on column public.profiles.notify_match_results is
  'User wants match-result notifications';

create or replace function public.get_my_privacy_prefs()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  p public.profiles%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  select * into p from public.profiles where id = v_uid;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Profile not found');
  end if;

  return jsonb_build_object(
    'status', 'ok',
    'challenge_who', p.challenge_who,
    'notify_challenge_requests', p.notify_challenge_requests,
    'notify_match_invites', p.notify_match_invites,
    'notify_match_results', p.notify_match_results
  );
end;
$$;

revoke all on function public.get_my_privacy_prefs() from public, anon;
grant execute on function public.get_my_privacy_prefs() to authenticated;

create or replace function public.update_my_privacy_prefs(
  p_challenge_who smallint default null,
  p_notify_challenge_requests boolean default null,
  p_notify_match_invites boolean default null,
  p_notify_match_results boolean default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  p public.profiles%rowtype;
  v_who smallint;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  select * into p from public.profiles where id = v_uid for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Profile not found');
  end if;

  v_who := coalesce(p_challenge_who, p.challenge_who);
  if v_who is null or v_who not in (0, 1, 2) then
    return jsonb_build_object('status', 'error', 'message', 'Invalid challenge_who');
  end if;

  update public.profiles
  set challenge_who = v_who,
      notify_challenge_requests = coalesce(
        p_notify_challenge_requests, notify_challenge_requests),
      notify_match_invites = coalesce(
        p_notify_match_invites, notify_match_invites),
      notify_match_results = coalesce(
        p_notify_match_results, notify_match_results),
      updated_at = now()
  where id = v_uid
  returning * into p;

  return jsonb_build_object(
    'status', 'ok',
    'challenge_who', p.challenge_who,
    'notify_challenge_requests', p.notify_challenge_requests,
    'notify_match_invites', p.notify_match_invites,
    'notify_match_results', p.notify_match_results
  );
end;
$$;

revoke all on function public.update_my_privacy_prefs(
  smallint, boolean, boolean, boolean
) from public, anon;
grant execute on function public.update_my_privacy_prefs(
  smallint, boolean, boolean, boolean
) to authenticated;
