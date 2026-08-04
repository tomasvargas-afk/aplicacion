create table if not exists public.water_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  logged_date date not null default current_date,
  amount_ml int not null check (amount_ml > 0),
  goal_ml int not null default 2000,
  created_at timestamptz not null default now()
);

create index if not exists idx_water_logs_user_date
  on public.water_logs (user_id, logged_date);

create table if not exists public.sleep_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  sleep_date date not null default current_date,
  hours numeric not null check (hours >= 0 and hours <= 24),
  quality int check (quality between 1 and 5),
  bed_time time,
  wake_time time,
  created_at timestamptz not null default now()
);

create index if not exists idx_sleep_logs_user_date
  on public.sleep_logs (user_id, sleep_date);
