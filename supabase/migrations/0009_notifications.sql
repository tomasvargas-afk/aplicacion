-- Per-feature reminder toggle/schedule (water, workout, sleep, meal, ...)
create table if not exists public.notification_settings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  feature text not null check (
    feature in ('water', 'workout', 'sleep', 'meal', 'weigh_in', 'supplement')
  ),
  enabled boolean not null default true,
  time time not null default '09:00',
  days_of_week jsonb not null default '[1,2,3,4,5,6,7]'::jsonb,
  created_at timestamptz not null default now(),
  unique (user_id, feature)
);

-- One-off / custom local reminders
create table if not exists public.reminders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  title text not null,
  body text,
  scheduled_time timestamptz not null,
  repeat_pattern text not null default 'none' check (
    repeat_pattern in ('none', 'daily', 'weekly')
  ),
  is_active boolean not null default true,
  related_feature text,
  created_at timestamptz not null default now()
);

create index if not exists idx_reminders_user_active
  on public.reminders (user_id, is_active);
