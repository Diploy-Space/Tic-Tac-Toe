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
-- Dynamic single-elimination tournaments. Apply AFTER 012_wallets.sql (+ 011 for _is_admin).

create extension if not exists pgcrypto;

create table if not exists public.tournaments (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  entry_fee_minor bigint not null default 25 check (entry_fee_minor >= 0),
  currency_code text not null default 'COIN',
  max_participants int not null check (max_participants between 2 and 256),
  registration_opens_at timestamptz not null default now(),
  registration_closes_at timestamptz not null,
  starts_at timestamptz not null,
  move_timeout_sec int not null default 20 check (move_timeout_sec between 5 and 120),
  join_timeout_sec int not null default 60 check (join_timeout_sec between 15 and 600),
  status text not null default 'registration'
    check (status in (
      'draft', 'registration', 'locked', 'active', 'completed', 'cancelled'
    )),
  seed_salt text not null default encode(gen_random_bytes(8), 'hex'),
  bracket_size int null,
  prize_pool_minor bigint not null default 0,
  winner_id uuid null references public.profiles (id) on delete set null,
  created_by uuid null references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.tournament_registrations (
  id uuid primary key default gen_random_uuid(),
  tournament_id uuid not null references public.tournaments (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  seed int null,
  status text not null default 'registered'
    check (status in ('registered', 'cancelled', 'eliminated', 'active', 'winner')),
  eliminated_round int null,
  paid_minor bigint not null default 0,
  created_at timestamptz not null default now(),
  unique (tournament_id, user_id)
);

create table if not exists public.tournament_rounds (
  id uuid primary key default gen_random_uuid(),
  tournament_id uuid not null references public.tournaments (id) on delete cascade,
  round_index int not null check (round_index >= 1),
  name text not null,
  unique (tournament_id, round_index)
);

create table if not exists public.tournament_matches (
  id uuid primary key default gen_random_uuid(),
  tournament_id uuid not null references public.tournaments (id) on delete cascade,
  round_id uuid not null references public.tournament_rounds (id) on delete cascade,
  match_index int not null,
  player_a uuid null references public.profiles (id) on delete set null,
  player_b uuid null references public.profiles (id) on delete set null,
  winner_id uuid null references public.profiles (id) on delete set null,
  room_id uuid null references public.multiplayer_rooms (id) on delete set null,
  next_match_id uuid null references public.tournament_matches (id) on delete set null,
  next_slot text null check (next_slot is null or next_slot in ('a', 'b')),
  status text not null default 'pending'
    check (status in (
      'pending', 'ready', 'active', 'completed', 'forfeit', 'bye', 'void'
    )),
  join_deadline timestamptz null,
  result_reason text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (tournament_id, round_id, match_index)
);

create index if not exists tournament_registrations_user_idx
  on public.tournament_registrations (user_id);
create index if not exists tournament_matches_tournament_idx
  on public.tournament_matches (tournament_id, status);

alter table public.tournaments enable row level security;
alter table public.tournament_registrations enable row level security;
alter table public.tournament_rounds enable row level security;
alter table public.tournament_matches enable row level security;

revoke all on table public.tournaments from anon, authenticated;
revoke all on table public.tournament_registrations from anon, authenticated;
revoke all on table public.tournament_rounds from anon, authenticated;
revoke all on table public.tournament_matches from anon, authenticated;

grant select on table public.tournaments to authenticated;
grant select on table public.tournament_registrations to authenticated;
grant select on table public.tournament_rounds to authenticated;
grant select on table public.tournament_matches to authenticated;

drop policy if exists "tournaments_select" on public.tournaments;
create policy "tournaments_select" on public.tournaments
for select to authenticated
using (status <> 'draft' or public._is_admin(auth.uid()));

drop policy if exists "treg_select" on public.tournament_registrations;
create policy "treg_select" on public.tournament_registrations
for select to authenticated using (true);

drop policy if exists "trounds_select" on public.tournament_rounds;
create policy "trounds_select" on public.tournament_rounds
for select to authenticated using (true);

drop policy if exists "tmatches_select" on public.tournament_matches;
create policy "tmatches_select" on public.tournament_matches
for select to authenticated using (true);

create or replace function public._next_pow2(n int)
returns int language plpgsql immutable as $$
declare p int := 1;
begin
  if n < 2 then return 2; end if;
  while p < n loop p := p * 2; end loop;
  return p;
end;
$$;

create or replace function public.list_tournaments()
returns jsonb
language plpgsql security definer set search_path = public as $$
declare v_uid uuid := auth.uid();
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  return jsonb_build_object(
    'status', 'ok',
    'items', coalesce((
      select jsonb_agg(to_jsonb(x) order by x.starts_at)
      from (
        select t.id, t.name, t.entry_fee_minor, t.currency_code, t.max_participants,
               t.registration_opens_at, t.registration_closes_at, t.starts_at,
               t.status, t.bracket_size, t.prize_pool_minor, t.winner_id,
               (select count(*)::int from public.tournament_registrations r
                 where r.tournament_id = t.id and r.status <> 'cancelled') as registered_count,
               exists (
                 select 1 from public.tournament_registrations r
                 where r.tournament_id = t.id and r.user_id = v_uid and r.status <> 'cancelled'
               ) as i_am_registered
        from public.tournaments t
        where t.status in ('registration', 'locked', 'active', 'completed')
      ) x
    ), '[]'::jsonb)
  );
end;
$$;
revoke all on function public.list_tournaments() from public, anon;
grant execute on function public.list_tournaments() to authenticated;

create or replace function public.register_for_tournament(p_tournament_id uuid)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  t public.tournaments%rowtype;
  v_count int;
  v_key text;
  v_pay jsonb;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  select * into t from public.tournaments where id = p_tournament_id for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Tournament not found');
  end if;
  if t.status is distinct from 'registration' then
    return jsonb_build_object('status', 'error', 'message', 'Registration closed');
  end if;
  if now() < t.registration_opens_at or now() > t.registration_closes_at then
    return jsonb_build_object('status', 'error', 'message', 'Outside registration window');
  end if;
  if exists (
    select 1 from public.tournament_registrations
    where tournament_id = t.id and user_id = v_uid and status <> 'cancelled'
  ) then
    return jsonb_build_object('status', 'error', 'message', 'Already registered');
  end if;
  select count(*) into v_count from public.tournament_registrations
  where tournament_id = t.id and status <> 'cancelled';
  if v_count >= t.max_participants then
    return jsonb_build_object('status', 'error', 'message', 'Tournament is full');
  end if;

  v_key := 'tournament_entry:' || t.id::text || ':' || v_uid::text;
  if t.entry_fee_minor > 0 then
    v_pay := public._wallet_apply(
      v_uid, t.entry_fee_minor, 'debit', 'tournament_entry',
      v_key, 'tournament', t.id::text
    );
    if v_pay->>'status' is distinct from 'ok' then
      return v_pay;
    end if;
  end if;

  insert into public.tournament_registrations (tournament_id, user_id, status, paid_minor)
  values (t.id, v_uid, 'registered', t.entry_fee_minor)
  on conflict (tournament_id, user_id) do update
    set status = 'registered', paid_minor = excluded.paid_minor
  where public.tournament_registrations.status = 'cancelled';

  update public.tournaments
  set prize_pool_minor = prize_pool_minor + t.entry_fee_minor, updated_at = now()
  where id = t.id;

  return jsonb_build_object('status', 'ok', 'tournament_id', t.id);
end;
$$;
revoke all on function public.register_for_tournament(uuid) from public, anon;
grant execute on function public.register_for_tournament(uuid) to authenticated;

create or replace function public.admin_create_tournament(
  p_name text,
  p_entry_fee bigint,
  p_max_participants int,
  p_registration_closes_at timestamptz,
  p_starts_at timestamptz,
  p_move_timeout_sec int default 20,
  p_join_timeout_sec int default 60
)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  tid uuid;
begin
  if v_uid is null or not public._is_admin(v_uid) then
    return jsonb_build_object('status', 'error', 'message', 'Admin only');
  end if;
  insert into public.tournaments (
    name, entry_fee_minor, max_participants,
    registration_closes_at, starts_at,
    move_timeout_sec, join_timeout_sec, status, created_by
  ) values (
    trim(p_name), greatest(0, coalesce(p_entry_fee, 0)), p_max_participants,
    p_registration_closes_at, p_starts_at,
    coalesce(p_move_timeout_sec, 20), coalesce(p_join_timeout_sec, 60),
    'registration', v_uid
  ) returning id into tid;
  return jsonb_build_object('status', 'ok', 'tournament_id', tid);
end;
$$;
revoke all on function public.admin_create_tournament(text, bigint, int, timestamptz, timestamptz, int, int)
  from public, anon;
grant execute on function public.admin_create_tournament(text, bigint, int, timestamptz, timestamptz, int, int)
  to authenticated;

create or replace function public._tournament_advance(
  p_match_id uuid,
  p_winner_id uuid,
  p_reason text
)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  m public.tournament_matches%rowtype;
  t public.tournaments%rowtype;
  prize_key text;
  both_set boolean;
begin
  select * into m from public.tournament_matches where id = p_match_id for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Match not found');
  end if;
  if m.winner_id is not null and m.status in ('completed', 'bye') then
    return jsonb_build_object('status', 'ok', 'duplicate', true, 'winner_id', m.winner_id);
  end if;
  if p_winner_id is distinct from m.player_a and p_winner_id is distinct from m.player_b then
    return jsonb_build_object('status', 'error', 'message', 'Winner not a participant');
  end if;

  update public.tournament_matches
  set winner_id = p_winner_id,
      status = case when p_reason = 'bye' then 'bye' else 'completed' end,
      result_reason = p_reason,
      updated_at = now()
  where id = m.id;

  update public.tournament_registrations r
  set status = 'eliminated',
      eliminated_round = (select round_index from public.tournament_rounds where id = m.round_id)
  where r.tournament_id = m.tournament_id
    and r.user_id in (m.player_a, m.player_b)
    and r.user_id is distinct from p_winner_id
    and r.status <> 'cancelled';

  if m.next_match_id is not null then
    if m.next_slot = 'a' then
      update public.tournament_matches set player_a = p_winner_id, updated_at = now()
      where id = m.next_match_id;
    else
      update public.tournament_matches set player_b = p_winner_id, updated_at = now()
      where id = m.next_match_id;
    end if;
    select (player_a is not null and player_b is not null) into both_set
    from public.tournament_matches where id = m.next_match_id;
    if both_set then
      update public.tournament_matches nm
      set status = 'ready',
          join_deadline = now() + make_interval(
            secs => (select join_timeout_sec from public.tournaments where id = m.tournament_id)
          ),
          updated_at = now()
      where nm.id = m.next_match_id and nm.status = 'pending';
    end if;
  else
    select * into t from public.tournaments where id = m.tournament_id for update;
    update public.tournaments
    set status = 'completed', winner_id = p_winner_id, updated_at = now()
    where id = m.tournament_id;
    update public.tournament_registrations
    set status = 'winner'
    where tournament_id = m.tournament_id and user_id = p_winner_id;
    if t.prize_pool_minor > 0 then
      prize_key := 'tournament:' || t.id::text || ':prize';
      perform public._wallet_apply(
        p_winner_id, t.prize_pool_minor, 'credit', 'tournament_prize',
        prize_key, 'tournament', t.id::text
      );
    end if;
  end if;
  return jsonb_build_object('status', 'ok', 'winner_id', p_winner_id);
end;
$$;
revoke all on function public._tournament_advance(uuid, uuid, text) from public, anon, authenticated;

create or replace function public.tournament_apply_match_result(
  p_match_id uuid,
  p_winner_id uuid,
  p_reason text default 'played'
)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  m public.tournament_matches%rowtype;
begin
  if v_uid is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  select * into m from public.tournament_matches where id = p_match_id;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Match not found');
  end if;
  if v_uid is distinct from m.player_a
     and v_uid is distinct from m.player_b
     and not public._is_admin(v_uid) then
    return jsonb_build_object('status', 'error', 'message', 'Not allowed');
  end if;
  return public._tournament_advance(p_match_id, p_winner_id, coalesce(p_reason, 'played'));
end;
$$;
revoke all on function public.tournament_apply_match_result(uuid, uuid, text) from public, anon;
grant execute on function public.tournament_apply_match_result(uuid, uuid, text) to authenticated;

create or replace function public.tournament_process_timeouts()
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  m record;
  winner uuid;
  processed int := 0;
begin
  for m in
    select * from public.tournament_matches
    where status = 'ready'
      and join_deadline is not null
      and join_deadline < now()
    for update skip locked
  loop
    if m.player_a is not null and m.player_b is null then
      winner := m.player_a;
    elsif m.player_b is not null and m.player_a is null then
      winner := m.player_b;
    elsif m.player_a is not null and m.player_b is not null then
      update public.tournament_matches
      set status = 'void', result_reason = 'both_timeout', updated_at = now()
      where id = m.id;
      update public.tournament_registrations
      set status = 'eliminated'
      where tournament_id = m.tournament_id and user_id in (m.player_a, m.player_b);
      processed := processed + 1;
      continue;
    else
      update public.tournament_matches
      set status = 'void', result_reason = 'empty', updated_at = now()
      where id = m.id;
      processed := processed + 1;
      continue;
    end if;
    perform public._tournament_advance(m.id, winner, 'join_timeout');
    processed := processed + 1;
  end loop;
  return jsonb_build_object('status', 'ok', 'processed', processed);
end;
$$;
revoke all on function public.tournament_process_timeouts() from public, anon;
grant execute on function public.tournament_process_timeouts() to authenticated;

create or replace function public.admin_generate_bracket(p_tournament_id uuid)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  t public.tournaments%rowtype;
  players uuid[];
  n int;
  bsize int;
  byes int;
  total_rounds int;
  ri int;
  mi int;
  matches_in_round int;
  rid uuid;
  mid uuid;
  next_ids uuid[];
  cur_ids uuid[];
  a_id uuid;
  b_id uuid;
  r1 uuid;
  join_secs int;
begin
  if v_uid is null or not public._is_admin(v_uid) then
    return jsonb_build_object('status', 'error', 'message', 'Admin only');
  end if;
  select * into t from public.tournaments where id = p_tournament_id for update;
  if not found then
    return jsonb_build_object('status', 'error', 'message', 'Not found');
  end if;
  if t.status not in ('registration', 'locked') then
    return jsonb_build_object('status', 'error', 'message', 'Cannot generate bracket now');
  end if;

  select array_agg(user_id order by md5(t.seed_salt || user_id::text))
  into players
  from public.tournament_registrations
  where tournament_id = t.id and status = 'registered';

  n := coalesce(cardinality(players), 0);
  if n < 2 then
    return jsonb_build_object('status', 'error', 'message', 'Need at least 2 players');
  end if;

  bsize := public._next_pow2(n);
  byes := bsize - n;
  join_secs := t.join_timeout_sec;
  total_rounds := 0;
  matches_in_round := bsize / 2;
  while matches_in_round >= 1 loop
    total_rounds := total_rounds + 1;
    matches_in_round := matches_in_round / 2;
  end loop;

  delete from public.tournament_matches where tournament_id = t.id;
  delete from public.tournament_rounds where tournament_id = t.id;

  -- Create rounds + empty matches, link forward
  next_ids := null;
  for ri in reverse 1..total_rounds loop
    matches_in_round := bsize / (2 ^ ri);
    insert into public.tournament_rounds (tournament_id, round_index, name)
    values (
      t.id, ri,
      case
        when matches_in_round = 1 then 'Final'
        when matches_in_round = 2 then 'Semi'
        when matches_in_round = 4 then 'Quarter'
        else 'Round of ' || (matches_in_round * 2)::text
      end
    ) returning id into rid;

    cur_ids := array[]::uuid[];
    for mi in 0..(matches_in_round - 1) loop
      insert into public.tournament_matches (tournament_id, round_id, match_index, status)
      values (t.id, rid, mi, 'pending')
      returning id into mid;
      cur_ids := cur_ids || mid;
      if next_ids is not null then
        update public.tournament_matches
        set next_match_id = next_ids[(mi / 2) + 1],
            next_slot = case when mi % 2 = 0 then 'a' else 'b' end
        where id = mid;
      end if;
    end loop;
    next_ids := cur_ids;
  end loop;

  select id into r1 from public.tournament_rounds
  where tournament_id = t.id and round_index = 1;

  -- Place players into consecutive slots; trailing empties are byes
  for mi in 0..(bsize / 2 - 1) loop
    a_id := case when (mi * 2 + 1) <= n then players[mi * 2 + 1] else null end;
    b_id := case when (mi * 2 + 2) <= n then players[mi * 2 + 2] else null end;
    select id into mid from public.tournament_matches
    where tournament_id = t.id and round_id = r1 and match_index = mi;

    if a_id is not null and b_id is not null then
      update public.tournament_matches
      set player_a = a_id, player_b = b_id, status = 'ready',
          join_deadline = now() + make_interval(secs => join_secs),
          updated_at = now()
      where id = mid;
    elsif a_id is not null then
      update public.tournament_matches
      set player_a = a_id, player_b = null, updated_at = now()
      where id = mid;
      perform public._tournament_advance(mid, a_id, 'bye');
    elsif b_id is not null then
      update public.tournament_matches
      set player_a = null, player_b = b_id, updated_at = now()
      where id = mid;
      perform public._tournament_advance(mid, b_id, 'bye');
    end if;
  end loop;

  update public.tournaments
  set bracket_size = bsize, status = 'active', updated_at = now()
  where id = t.id;

  return jsonb_build_object('status', 'ok', 'bracket_size', bsize, 'byes', byes, 'players', n);
end;
$$;
revoke all on function public.admin_generate_bracket(uuid) from public, anon;
grant execute on function public.admin_generate_bracket(uuid) to authenticated;

create or replace function public.get_tournament_bracket(p_tournament_id uuid)
returns jsonb
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null then
    return jsonb_build_object('status', 'error', 'message', 'Not authenticated');
  end if;
  return jsonb_build_object(
    'status', 'ok',
    'tournament', (select to_jsonb(t) from public.tournaments t where t.id = p_tournament_id),
    'rounds', coalesce((
      select jsonb_agg(to_jsonb(r) order by r.round_index)
      from public.tournament_rounds r where r.tournament_id = p_tournament_id
    ), '[]'::jsonb),
    'matches', coalesce((
      select jsonb_agg(to_jsonb(m) order by m.match_index)
      from public.tournament_matches m where m.tournament_id = p_tournament_id
    ), '[]'::jsonb),
    'registrations', coalesce((
      select jsonb_agg(to_jsonb(x))
      from (
        select r.*, p.username
        from public.tournament_registrations r
        join public.profiles p on p.id = r.user_id
        where r.tournament_id = p_tournament_id
      ) x
    ), '[]'::jsonb)
  );
end;
$$;
revoke all on function public.get_tournament_bracket(uuid) from public, anon;
grant execute on function public.get_tournament_bracket(uuid) to authenticated;
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
