-- Friends search: by username (contains) or by Player ID (023 player_no).
-- "042", "42" and "PLAYER 042" all find player #42.
-- Apply AFTER 023_player_number.sql.

create or replace function public.search_players(
  p_query text,
  p_limit integer default 20
)
returns table (id uuid, username text, avatar_url text, player_no bigint)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_q text := lower(trim(coalesce(p_query, '')));
  v_digits text := regexp_replace(v_q, '[^0-9]', '', 'g');
  v_no bigint := null;
  v_lim integer := least(greatest(coalesce(p_limit, 20), 1), 50);
begin
  if auth.uid() is null or v_q = '' then
    return;
  end if;
  -- Pure number (optionally "player"/"id" prefixed) → Player ID lookup.
  if v_digits <> '' and length(v_digits) <= 12
     and regexp_replace(v_q, '(player|id|#|\s)', '', 'g') = v_digits then
    v_no := v_digits::bigint;
  end if;

  return query
  select p.id, p.username, p.avatar_url, p.player_no
  from public.profiles p
  where p.id <> auth.uid()
    and (
      (v_no is not null and p.player_no = v_no)
      or (char_length(v_q) >= 2
          and p.username ilike '%' || replace(replace(v_q, '%', ''), '_', '\_') || '%')
    )
  order by
    (v_no is not null and p.player_no = v_no) desc,
    (p.username = v_q) desc,
    (p.username like v_q || '%') desc,
    p.username
  limit v_lim;
end;
$$;

revoke all on function public.search_players (text, integer)
from public, anon;

grant
execute on function public.search_players (text, integer) to authenticated;