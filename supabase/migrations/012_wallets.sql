-- Server-authoritative wallet. Apply AFTER 001_profiles (+ 011 for _is_admin optional).
-- Clients may SELECT own wallet/tx; balance changes ONLY via RPCs.

create table if not exists public.wallets (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  balance_minor bigint not null default 500
    check (balance_minor >= 0),
  currency_code text not null default 'COIN'
    check (char_length(currency_code) between 3 and 8),
  migrated_from_local_at timestamptz null,
  updated_at timestamptz not null default now()
);

create table if not exists public.wallet_transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  amount_minor bigint not null check (amount_minor > 0),
  direction text not null check (direction in ('credit', 'debit')),
  reason text not null,
  ref_type text null,
  ref_id text null,
  currency_code text not null default 'COIN',
  idempotency_key text not null,
  balance_after bigint not null check (balance_after >= 0),
  created_at timestamptz not null default now(),
  constraint wallet_transactions_idempotency_unique unique (idempotency_key)
);

create index if not exists wallet_transactions_user_created_idx
  on public.wallet_transactions (user_id, created_at desc);

alter table public.wallets enable row level security;
alter table public.wallet_transactions enable row level security;

revoke all on table public.wallets from anon, authenticated;
revoke all on table public.wallet_transactions from anon, authenticated;
grant select on table public.wallets to authenticated;
grant select on table public.wallet_transactions to authenticated;

drop policy if exists "wallets_select_own" on public.wallets;
create policy "wallets_select_own"
on public.wallets for select to authenticated
using (auth.uid() = user_id);

drop policy if exists "wallet_tx_select_own" on public.wallet_transactions;
create policy "wallet_tx_select_own"
on public.wallet_transactions for select to authenticated
using (auth.uid() = user_id);

-- Ensure wallet row for every profile
create or replace function public._ensure_wallet(p_uid uuid)
returns public.wallets
language plpgsql
security definer
set search_path = public
as $$
declare
  w public.wallets%rowtype;
begin
  insert into public.wallets (user_id)
  values (p_uid)
  on conflict (user_id) do nothing;
  select * into w from public.wallets where user_id = p_uid;
  return w;
end;
$$;

revoke all on function public._ensure_wallet(uuid) from public, anon, authenticated;

-- Auto-create wallet when profile is created
create or replace function public._wallet_on_profile()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public._ensure_wallet(new.id);
  return new;
end;
$$;

drop trigger if exists profiles_create_wallet on public.profiles;
create trigger profiles_create_wallet
after insert on public.profiles
for each row execute function public._wallet_on_profile();

-- Backfill
insert into public.wallets (user_id)
select p.id from public.profiles p
on conflict (user_id) do nothing;

create or replace function public.get_my_wallet()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  w public.wallets%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  w := public._ensure_wallet(v_uid);
  return jsonb_build_object(
    'status', 'ok',
    'balance_minor', w.balance_minor,
    'currency_code', w.currency_code,
    'migrated_from_local_at', w.migrated_from_local_at,
    'updated_at', w.updated_at
  );
end;
$$;

revoke all on function public.get_my_wallet() from public, anon;
grant execute on function public.get_my_wallet() to authenticated;

create or replace function public.list_my_wallet_transactions(p_limit int default 50)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_limit int := greatest(1, least(coalesce(p_limit, 50), 100));
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  return jsonb_build_object(
    'status', 'ok',
    'items', coalesce((
      select jsonb_agg(to_jsonb(t) order by t.created_at desc)
      from (
        select id, amount_minor, direction, reason, ref_type, ref_id,
               currency_code, balance_after, created_at, idempotency_key
        from public.wallet_transactions
        where user_id = v_uid
        order by created_at desc
        limit v_limit
      ) t
    ), '[]'::jsonb)
  );
end;
$$;

revoke all on function public.list_my_wallet_transactions(int) from public, anon;
grant execute on function public.list_my_wallet_transactions(int) to authenticated;

-- Internal credit/debit (idempotent). Not granted to clients directly for arbitrary use —
-- exposed as thin wrappers for app-allowed reasons.
create or replace function public._wallet_apply(
  p_uid uuid,
  p_amount bigint,
  p_direction text,
  p_reason text,
  p_idempotency_key text,
  p_ref_type text default null,
  p_ref_id text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  w public.wallets%rowtype;
  existing public.wallet_transactions%rowtype;
  v_after bigint;
begin
  if p_uid is null or p_amount is null or p_amount <= 0 then
    return jsonb_build_object('status', 'error', 'message', 'Invalid amount');
  end if;
  if p_direction not in ('credit', 'debit') then
    return jsonb_build_object('status', 'error', 'message', 'Invalid direction');
  end if;
  if p_idempotency_key is null or length(trim(p_idempotency_key)) < 4 then
    return jsonb_build_object('status', 'error', 'message', 'Idempotency key required');
  end if;

  select * into existing
  from public.wallet_transactions
  where idempotency_key = p_idempotency_key;
  if found then
    select * into w from public.wallets where user_id = p_uid;
    return jsonb_build_object(
      'status', 'ok',
      'duplicate', true,
      'balance_minor', w.balance_minor,
      'currency_code', w.currency_code,
      'transaction_id', existing.id
    );
  end if;

  w := public._ensure_wallet(p_uid);
  perform 1 from public.wallets where user_id = p_uid for update;
  select * into w from public.wallets where user_id = p_uid;

  if p_direction = 'debit' then
    if w.balance_minor < p_amount then
      return jsonb_build_object('status', 'error', 'message', 'Insufficient balance');
    end if;
    v_after := w.balance_minor - p_amount;
  else
    v_after := w.balance_minor + p_amount;
  end if;

  update public.wallets
  set balance_minor = v_after, updated_at = now()
  where user_id = p_uid;

  insert into public.wallet_transactions (
    user_id, amount_minor, direction, reason, ref_type, ref_id,
    currency_code, idempotency_key, balance_after
  ) values (
    p_uid, p_amount, p_direction, p_reason, p_ref_type, p_ref_id,
    w.currency_code, p_idempotency_key, v_after
  )
  returning * into existing;

  return jsonb_build_object(
    'status', 'ok',
    'duplicate', false,
    'balance_minor', v_after,
    'currency_code', w.currency_code,
    'transaction_id', existing.id
  );
end;
$$;

revoke all on function public._wallet_apply(uuid, bigint, text, text, text, text, text)
  from public, anon, authenticated;

-- One-time migrate: take min(claimed, 5000) once; ignore thereafter.
create or replace function public.migrate_local_coins(p_claimed_balance bigint)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  w public.wallets%rowtype;
  v_claim bigint;
  v_delta bigint;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  w := public._ensure_wallet(v_uid);
  if w.migrated_from_local_at is not null then
    return jsonb_build_object(
      'status', 'ok',
      'already_migrated', true,
      'balance_minor', w.balance_minor,
      'currency_code', w.currency_code
    );
  end if;

  v_claim := greatest(0, least(coalesce(p_claimed_balance, 0), 5000));
  -- Set balance to max(server default/current, capped claim) without double-counting grants.
  if v_claim > w.balance_minor then
    v_delta := v_claim - w.balance_minor;
    perform public._wallet_apply(
      v_uid, v_delta, 'credit', 'local_migrate',
      'migrate:' || v_uid::text, 'migration', v_uid::text
    );
  end if;

  update public.wallets
  set migrated_from_local_at = now(), updated_at = now()
  where user_id = v_uid;

  select * into w from public.wallets where user_id = v_uid;
  return jsonb_build_object(
    'status', 'ok',
    'already_migrated', false,
    'balance_minor', w.balance_minor,
    'currency_code', w.currency_code
  );
end;
$$;

revoke all on function public.migrate_local_coins(bigint) from public, anon;
grant execute on function public.migrate_local_coins(bigint) to authenticated;

-- App-facing debit/credit for allowed reasons (tournament entry, match settle, etc.)
create or replace function public.wallet_debit(
  p_amount bigint,
  p_reason text,
  p_idempotency_key text,
  p_ref_type text default null,
  p_ref_id text default null
)
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
  if p_reason is null or p_reason not in (
    'tournament_entry', 'match_stake', 'shop_cosmetic', 'challenge_stake', 'admin_adjust'
  ) then
    return jsonb_build_object('status', 'error', 'message', 'Reason not allowed');
  end if;
  if p_reason = 'admin_adjust' then
    return jsonb_build_object('status', 'error', 'message', 'Admin only');
  end if;
  return public._wallet_apply(
    v_uid, p_amount, 'debit', p_reason, p_idempotency_key, p_ref_type, p_ref_id
  );
end;
$$;

revoke all on function public.wallet_debit(bigint, text, text, text, text) from public, anon;
grant execute on function public.wallet_debit(bigint, text, text, text, text) to authenticated;

create or replace function public.wallet_credit(
  p_amount bigint,
  p_reason text,
  p_idempotency_key text,
  p_ref_type text default null,
  p_ref_id text default null
)
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
  -- Client may only claim non-privileged credits (daily/ad demo paths still local until AdMob SSV).
  if p_reason is null or p_reason not in (
    'match_reward', 'tournament_prize', 'daily_reward', 'ad_reward', 'iap_grant'
  ) then
    return jsonb_build_object('status', 'error', 'message', 'Reason not allowed');
  end if;
  -- Block client-side prize/reward abuse: only match_reward & daily_reward & ad_reward & iap for now
  -- with idempotency. Tournament prize should be server-only later.
  if p_reason = 'tournament_prize' then
    return jsonb_build_object('status', 'error', 'message', 'Server only');
  end if;
  return public._wallet_apply(
    v_uid, p_amount, 'credit', p_reason, p_idempotency_key, p_ref_type, p_ref_id
  );
end;
$$;

revoke all on function public.wallet_credit(bigint, text, text, text, text) from public, anon;
grant execute on function public.wallet_credit(bigint, text, text, text, text) to authenticated;
