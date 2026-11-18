-- Push delivery: every new public.notifications row (with push = true) calls
-- the `send-push` Edge Function via pg_net. Replaces a Dashboard webhook.
-- Apply AFTER 027_notifications.sql.
--
-- The shared secret lives in Supabase Vault (name: push_webhook_secret) and
-- must equal the Edge Function secret WEBHOOK_SECRET. Store it with:
--   select vault.create_secret('<secret>', 'push_webhook_secret');

create extension if not exists pg_net;

create or replace function public._send_push_webhook()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_secret text;
begin
  if not new.push then
    return new;
  end if;
  select decrypted_secret into v_secret
  from vault.decrypted_secrets
  where name = 'push_webhook_secret'
  limit 1;
  if v_secret is null then
    return new;
  end if;
  perform net.http_post(
    url := 'https://gaiyalhrcozftudbmzgb.supabase.co/functions/v1/send-push',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-webhook-secret', v_secret
    ),
    -- Same shape as a Supabase Database Webhook payload.
    body := jsonb_build_object(
      'type', 'INSERT',
      'table', 'notifications',
      'schema', 'public',
      'record', to_jsonb(new),
      'old_record', null
    ),
    timeout_milliseconds := 8000
  );
  return new;
exception
  when others then
    -- A push failure must never block the notification itself.
    raise warning 'send-push webhook: %', SQLERRM;
    return new;
end;
$$;

revoke all on function public._send_push_webhook() from public, anon, authenticated;

drop trigger if exists notifications_send_push on public.notifications;
create trigger notifications_send_push
after insert on public.notifications
for each row execute function public._send_push_webhook();
