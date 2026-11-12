-- Mobile number + country on profiles. Updates only via RPC.

alter table public.profiles
  add column if not exists phone_e164 text null,
  add column if not exists calling_code text null,
  add column if not exists country_iso2 text null;

alter table public.profiles
  drop constraint if exists profiles_calling_code_format;
alter table public.profiles
  add constraint profiles_calling_code_format check (
    calling_code is null or calling_code ~ '^\+[0-9]{1,4}$'
  );

alter table public.profiles
  drop constraint if exists profiles_country_iso2_format;
alter table public.profiles
  add constraint profiles_country_iso2_format check (
    country_iso2 is null or country_iso2 ~ '^[A-Z]{2}$'
  );

alter table public.profiles
  drop constraint if exists profiles_phone_e164_format;
alter table public.profiles
  add constraint profiles_phone_e164_format check (
    phone_e164 is null or phone_e164 ~ '^\+[0-9]{8,15}$'
  );

-- Own full profile (includes contact). Public view stays username/avatar only.
create or replace function public.get_my_profile()
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
    'id', p.id,
    'username', p.username,
    'avatar_url', p.avatar_url,
    'phone_e164', p.phone_e164,
    'calling_code', p.calling_code,
    'country_iso2', p.country_iso2,
    'created_at', p.created_at,
    'updated_at', p.updated_at
  );
end;
$$;

revoke all on function public.get_my_profile() from public, anon;
grant execute on function public.get_my_profile() to authenticated;

create or replace function public.update_my_profile_contact(
  p_calling_code text,
  p_national_number text,
  p_country_iso2 text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_cc text;
  v_iso text;
  v_nat text;
  v_e164 text;
  p public.profiles%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  v_cc := trim(coalesce(p_calling_code, ''));
  if v_cc <> '' and left(v_cc, 1) <> '+' then
    v_cc := '+' || v_cc;
  end if;
  v_iso := upper(trim(coalesce(p_country_iso2, '')));
  v_nat := regexp_replace(trim(coalesce(p_national_number, '')), '[^0-9]', '', 'g');

  if v_iso = '' or v_cc = '' or v_nat = '' then
    return jsonb_build_object('status', 'error', 'message', 'Country, calling code and mobile required');
  end if;
  if v_iso !~ '^[A-Z]{2}$' then
    return jsonb_build_object('status', 'error', 'message', 'Invalid country');
  end if;
  if v_cc !~ '^\+[0-9]{1,4}$' then
    return jsonb_build_object('status', 'error', 'message', 'Invalid calling code');
  end if;
  if char_length(v_nat) < 6 or char_length(v_nat) > 12 then
    return jsonb_build_object('status', 'error', 'message', 'Invalid mobile number');
  end if;

  -- Known pairs (extend later via CountryCurrencyService sync)
  if not (
    (v_iso = 'BD' and v_cc = '+880') or
    (v_iso = 'IN' and v_cc = '+91') or
    (v_iso = 'US' and v_cc = '+1') or
    (v_iso = 'GB' and v_cc = '+44') or
    (v_iso = 'PK' and v_cc = '+92') or
    (v_iso = 'AU' and v_cc = '+61')
  ) then
    return jsonb_build_object('status', 'error', 'message', 'Country / calling code mismatch');
  end if;

  v_e164 := v_cc || v_nat;

  -- Lock country after first set (prevent fee manipulation)
  select * into p from public.profiles where id = v_uid for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Profile not found');
  end if;
  if p.country_iso2 is not null and p.country_iso2 is distinct from v_iso then
    return jsonb_build_object(
      'status', 'error',
      'message', 'Country is locked. Contact support to change it.'
    );
  end if;

  update public.profiles
  set phone_e164 = v_e164,
      calling_code = v_cc,
      country_iso2 = v_iso,
      updated_at = now()
  where id = v_uid
  returning * into p;

  return jsonb_build_object(
    'status', 'ok',
    'id', p.id,
    'username', p.username,
    'avatar_url', p.avatar_url,
    'phone_e164', p.phone_e164,
    'calling_code', p.calling_code,
    'country_iso2', p.country_iso2,
    'created_at', p.created_at,
    'updated_at', p.updated_at
  );
end;
$$;

revoke all on function public.update_my_profile_contact(text, text, text) from public, anon;
grant execute on function public.update_my_profile_contact(text, text, text) to authenticated;
