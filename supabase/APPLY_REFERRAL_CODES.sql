-- Paste into Supabase SQL Editor → Run.
-- Referral codes: one-time welcome bonus (+50) for new users after signup.

alter table public.profiles
  add column if not exists referral_code text;

alter table public.profiles
  add column if not exists referred_by uuid null references public.profiles (id) on delete set null;

-- Default true so existing rows skip the prompt; new signups set false in trigger.
alter table public.profiles
  add column if not exists referral_prompt_seen boolean not null default true;

-- Unique codes (case-insensitive)
create unique index if not exists profiles_referral_code_unique_ci
  on public.profiles (lower(referral_code))
  where referral_code is not null;

alter table public.profiles
  drop constraint if exists profiles_referral_code_format;
alter table public.profiles
  add constraint profiles_referral_code_format check (
    referral_code is null
    or referral_code ~ '^[A-Z0-9_]{3,20}$'
  );

alter table public.profiles
  drop constraint if exists profiles_referred_not_self;
alter table public.profiles
  add constraint profiles_referred_not_self check (
    referred_by is null or referred_by <> id
  );

-- Backfill codes from username for existing rows.
update public.profiles
set referral_code = upper(username)
where referral_code is null
  and username is not null
  and username ~ '^[a-z0-9_]+$';

-- Ensure new profiles get a code.
create or replace function public.profiles_set_referral_code()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.referral_code is null or length(trim(new.referral_code)) = 0 then
    new.referral_code := upper(new.username);
  else
    new.referral_code := upper(trim(new.referral_code));
  end if;
  -- New accounts should see the post-signup referral screen once.
  if tg_op = 'INSERT' then
    new.referral_prompt_seen := false;
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_set_referral_code on public.profiles;
create trigger profiles_set_referral_code
before insert or update of username, referral_code on public.profiles
for each row execute function public.profiles_set_referral_code();

create or replace function public.get_my_referral_status()
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
    'username', p.username,
    'referral_code', p.referral_code,
    'referred_by', p.referred_by,
    'referral_prompt_seen', p.referral_prompt_seen,
    'can_apply', (p.referred_by is null and p.referral_prompt_seen = false)
  );
end;
$$;

revoke all on function public.get_my_referral_status() from public, anon;
grant execute on function public.get_my_referral_status() to authenticated;

create or replace function public.mark_referral_prompt_seen()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  update public.profiles
  set referral_prompt_seen = true, updated_at = now()
  where id = v_uid;

  return jsonb_build_object('status', 'ok');
end;
$$;

revoke all on function public.mark_referral_prompt_seen() from public, anon;
grant execute on function public.mark_referral_prompt_seen() to authenticated;

-- Apply code once: credit +50 welcome bonus to the new user.
create or replace function public.apply_referral_code(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_code text;
  me public.profiles%rowtype;
  ref public.profiles%rowtype;
  v_credit jsonb;
  w public.wallets%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  v_code := upper(trim(coalesce(p_code, '')));
  if char_length(v_code) < 3 or char_length(v_code) > 20 then
    return jsonb_build_object('status', 'error', 'message', 'Enter a valid referral code');
  end if;
  if v_code !~ '^[A-Z0-9_]+$' then
    return jsonb_build_object('status', 'error', 'message', 'Invalid referral code format');
  end if;

  select * into me from public.profiles where id = v_uid for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Profile not found');
  end if;

  if me.referred_by is not null then
    return jsonb_build_object('status', 'error', 'message', 'Referral code already used');
  end if;

  select * into ref
  from public.profiles
  where lower(referral_code) = lower(v_code)
  limit 1;

  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Referral code not found');
  end if;

  if ref.id = v_uid then
    return jsonb_build_object('status', 'error', 'message', 'You cannot use your own code');
  end if;

  update public.profiles
  set referred_by = ref.id,
      referral_prompt_seen = true,
      updated_at = now()
  where id = v_uid;

  v_credit := public._wallet_apply(
    v_uid,
    50,
    'credit',
    'referral_bonus',
    'referral_bonus_' || v_uid::text,
    'referral',
    ref.id::text
  );

  if coalesce(v_credit->>'status', '') <> 'ok' then
    -- Roll back link if credit failed (rare).
    update public.profiles
    set referred_by = null, referral_prompt_seen = false, updated_at = now()
    where id = v_uid;
    return v_credit;
  end if;

  select * into w from public.wallets where user_id = v_uid;

  return jsonb_build_object(
    'status', 'ok',
    'bonus', 50,
    'referral_code', ref.referral_code,
    'referrer_username', ref.username,
    'balance_minor', coalesce(w.balance_minor, (v_credit->>'balance_minor')::bigint),
    'currency_code', coalesce(w.currency_code, 'COIN')
  );
end;
$$;

revoke all on function public.apply_referral_code(text) from public, anon;
grant execute on function public.apply_referral_code(text) to authenticated;
