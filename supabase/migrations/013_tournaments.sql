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
