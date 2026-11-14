-- Editable profile: username (+ optional phone/country).
-- Paste into Supabase SQL Editor → Run after 014_profile_contact.sql.

create or replace function public.update_my_profile(
  p_username text,
  p_calling_code text default null,
  p_national_number text default null,
  p_country_iso2 text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_user text;
  v_cc text;
  v_iso text;
  v_nat text;
  v_e164 text;
  p public.profiles%rowtype;
  v_update_phone boolean := false;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;

  v_user := lower(trim(coalesce(p_username, '')));
  if char_length(v_user) < 3 or char_length(v_user) > 20 then
    return jsonb_build_object('status', 'error', 'message', 'Username must be 3–20 characters');
  end if;
  if v_user !~ '^[a-z0-9_]+$' then
    return jsonb_build_object(
      'status', 'error',
      'message', 'Username: only a-z, 0-9, underscore'
    );
  end if;

  if exists (
    select 1 from public.profiles x
    where lower(x.username) = v_user and x.id is distinct from v_uid
  ) then
    return jsonb_build_object('status', 'error', 'message', 'Username already taken');
  end if;

  v_cc := trim(coalesce(p_calling_code, ''));
  v_iso := upper(trim(coalesce(p_country_iso2, '')));
  v_nat := regexp_replace(trim(coalesce(p_national_number, '')), '[^0-9]', '', 'g');

  if v_cc <> '' or v_iso <> '' or v_nat <> '' then
    v_update_phone := true;
    if v_cc <> '' and left(v_cc, 1) <> '+' then
      v_cc := '+' || v_cc;
    end if;
    if v_iso = '' or v_cc = '' or v_nat = '' then
      return jsonb_build_object(
        'status', 'error',
        'message', 'Country, calling code and mobile required together'
      );
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
  end if;

  select * into p from public.profiles where id = v_uid for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Profile not found');
  end if;

  if v_update_phone
     and p.country_iso2 is not null
     and p.country_iso2 is distinct from v_iso then
    return jsonb_build_object(
      'status', 'error',
      'message', 'Country is locked. Contact support to change it.'
    );
  end if;

  if v_update_phone then
    update public.profiles
    set username = v_user,
        phone_e164 = v_e164,
        calling_code = v_cc,
        country_iso2 = v_iso,
        updated_at = now()
    where id = v_uid
    returning * into p;
  else
    update public.profiles
    set username = v_user,
        updated_at = now()
    where id = v_uid
    returning * into p;
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

revoke all on function public.update_my_profile(text, text, text, text)
  from public, anon;
grant execute on function public.update_my_profile(text, text, text, text)
  to authenticated;
