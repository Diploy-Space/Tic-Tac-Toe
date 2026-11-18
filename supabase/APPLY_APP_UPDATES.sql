-- Paste into Supabase SQL Editor → Run.
-- In-app updates: public Storage bucket for update.json and release APKs.
-- Anyone can download (the app needs no login to check for updates).
-- Only the dashboard / service role can upload — no client upload policy.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'app-updates',
  'app-updates',
  true,
  209715200, -- 200 MB per file
  array[
    'application/json',
    'application/vnd.android.package-archive',
    'application/octet-stream'
  ]
)
on conflict (id) do update
set public = excluded.public,
    file_size_limit = excluded.file_size_limit,
    allowed_mime_types = excluded.allowed_mime_types;
