-- Body tracking: weight, body-fat %, and circumference measurements over time.
-- `external_health_sync_id` is reserved for a future phase-2 Google Fit / Apple Health sync.
create table if not exists public.body_measurements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  measured_at date not null default current_date,
  weight_kg numeric,
  body_fat_percent numeric,
  chest_cm numeric,
  waist_cm numeric,
  hip_cm numeric,
  arm_cm numeric,
  thigh_cm numeric,
  notes text,
  external_health_sync_id text,
  created_at timestamptz not null default now()
);

create index if not exists idx_body_measurements_user_date
  on public.body_measurements (user_id, measured_at);
