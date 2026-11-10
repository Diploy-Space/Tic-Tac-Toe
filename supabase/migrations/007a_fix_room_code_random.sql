-- Hotfix: create_private_room failed when gen_random_bytes (pgcrypto) was missing.
create or replace function public._mp_new_room_code()
returns text
language plpgsql
volatile
security definer
set search_path = public
as $$
declare
  alphabet constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  result text;
  i int;
  idx int;
begin
  result := '';
  for i in 1..6 loop
    idx := 1 + floor(random() * length(alphabet))::int;
    result := result || substr(alphabet, idx, 1);
  end loop;
  return result;
end;
$$;

revoke all on function public._mp_new_room_code() from public, anon, authenticated;
