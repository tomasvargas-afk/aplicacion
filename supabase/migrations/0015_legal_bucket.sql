-- Public bucket for static legal documents (privacy policy, terms) that
-- need a stable public URL for App Store/Play Store listings.
insert into storage.buckets (id, name, public)
values ('legal', 'legal', true)
on conflict (id) do nothing;

create policy "legal_public_read" on storage.objects
  for select using (bucket_id = 'legal');
