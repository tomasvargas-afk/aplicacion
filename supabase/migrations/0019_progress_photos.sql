alter table public.body_measurements
  add column if not exists photo_path text;

-- Private bucket (unlike avatars/recipe-images): body progress photos are
-- sensitive, so they're only ever served via short-lived signed URLs to
-- the owner, never a public URL.
insert into storage.buckets (id, name, public)
values ('progress-photos', 'progress-photos', false)
on conflict (id) do nothing;

create policy "progress_photos_owner_read" on storage.objects
  for select using (
    bucket_id = 'progress-photos' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "progress_photos_owner_write" on storage.objects
  for insert with check (
    bucket_id = 'progress-photos' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "progress_photos_owner_delete" on storage.objects
  for delete using (
    bucket_id = 'progress-photos' and (storage.foldername(name))[1] = auth.uid()::text
  );
