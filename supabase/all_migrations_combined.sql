-- Combined migration script: run once in Supabase SQL Editor
-- Generated from supabase/migrations/*.sql

-- ============================================================
-- 0001_profiles.sql
-- ============================================================
-- Profiles: extends auth.users with app-specific data
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text,
  avatar_url text,
  birth_date date,
  sex text check (sex in ('male', 'female', 'other')),
  height_cm numeric,
  activity_level text check (
    activity_level in ('sedentary', 'light', 'moderate', 'active', 'very_active')
  ),
  goal text check (
    goal in ('lose_fat', 'maintain', 'gain_muscle', 'recomposition')
  ),
  weight_unit text not null default 'kg' check (weight_unit in ('kg', 'lb')),
  theme_preference text not null default 'system' check (
    theme_preference in ('system', 'light', 'dark')
  ),
  locale text not null default 'es',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Auto-create a profile row whenever a new auth user signs up.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, new.raw_user_meta_data ->> 'full_name');
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_profiles_updated_at on public.profiles;
create trigger set_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- ============================================================
-- 0002_exercises_and_workouts.sql
-- ============================================================
-- Exercise library (shared/public + user-custom exercises)
create table if not exists public.exercises_library (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  muscle_group text,
  equipment text,
  description text,
  video_url text,
  is_custom boolean not null default false,
  created_by uuid references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

-- Workout templates (routines): PPL, Upper/Lower, Full Body, Arnold Split, custom
create table if not exists public.workouts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  type text not null default 'custom' check (
    type in ('ppl', 'upper_lower', 'full_body', 'arnold_split', 'custom')
  ),
  description text,
  created_at timestamptz not null default now()
);

-- Exercises that belong to a workout template
create table if not exists public.workout_exercises (
  id uuid primary key default gen_random_uuid(),
  workout_id uuid not null references public.workouts (id) on delete cascade,
  exercise_id uuid not null references public.exercises_library (id),
  sets int not null default 3,
  reps text not null default '8-12',
  rest_seconds int not null default 60,
  order_index int not null default 0,
  notes text
);

-- Calendar: which workout is scheduled on which day
create table if not exists public.workout_schedule (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  workout_id uuid not null references public.workouts (id) on delete cascade,
  scheduled_date date not null,
  status text not null default 'planned' check (
    status in ('planned', 'completed', 'skipped')
  ),
  created_at timestamptz not null default now()
);

create index if not exists idx_workout_schedule_user_date
  on public.workout_schedule (user_id, scheduled_date);

-- ============================================================
-- 0003_workout_logs.sql
-- ============================================================
-- Actual workout execution logs (drives attendance stats)
create table if not exists public.workout_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  workout_id uuid not null references public.workouts (id) on delete cascade,
  schedule_id uuid references public.workout_schedule (id) on delete set null,
  completed_at timestamptz not null default now(),
  duration_minutes int,
  notes text
);

create index if not exists idx_workout_logs_user_completed
  on public.workout_logs (user_id, completed_at);

-- Set-by-set detail for a workout log (optional, used for progress charts)
create table if not exists public.workout_log_sets (
  id uuid primary key default gen_random_uuid(),
  workout_log_id uuid not null references public.workout_logs (id) on delete cascade,
  exercise_id uuid not null references public.exercises_library (id),
  set_number int not null,
  reps_done int,
  weight_kg numeric
);

-- ============================================================
-- 0004_nutrition.sql
-- ============================================================
-- User recipes (reserved `barcode` column for a future phase-2 barcode-scan feature)
create table if not exists public.recipes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  ingredients jsonb not null default '[]'::jsonb,
  instructions text,
  calories numeric,
  protein_g numeric,
  carbs_g numeric,
  fat_g numeric,
  image_url text,
  is_favorite boolean not null default false,
  barcode text,
  created_at timestamptz not null default now()
);

-- Saved meals / templates (can be favorited, optionally linked to a recipe)
create table if not exists public.meals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  meal_type text not null check (
    meal_type in ('breakfast', 'lunch', 'dinner', 'snack')
  ),
  calories numeric not null default 0,
  protein_g numeric not null default 0,
  carbs_g numeric not null default 0,
  fat_g numeric not null default 0,
  is_favorite boolean not null default false,
  recipe_id uuid references public.recipes (id) on delete set null,
  created_at timestamptz not null default now()
);

-- Daily log of what was actually eaten
create table if not exists public.meal_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  meal_id uuid references public.meals (id) on delete set null,
  custom_name text,
  meal_type text not null check (
    meal_type in ('breakfast', 'lunch', 'dinner', 'snack')
  ),
  calories numeric not null default 0,
  protein_g numeric not null default 0,
  carbs_g numeric not null default 0,
  fat_g numeric not null default 0,
  logged_at timestamptz not null default now()
);

create index if not exists idx_meal_logs_user_logged
  on public.meal_logs (user_id, logged_at);

-- ============================================================
-- 0005_diet_plans.sql
-- ============================================================
-- Result of the diet generator (BMR/TDEE/macro calculation)
create table if not exists public.diet_plans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text,
  formula_used text not null default 'mifflin_st_jeor' check (
    formula_used in ('mifflin_st_jeor', 'harris_benedict')
  ),
  bmr numeric not null,
  tdee numeric not null,
  daily_calories numeric not null,
  protein_g numeric not null,
  carbs_g numeric not null,
  fat_g numeric not null,
  activity_level text not null,
  goal text not null,
  generated_at timestamptz not null default now()
);

-- Suggested sample menu attached to a generated diet plan
create table if not exists public.diet_plan_meals (
  id uuid primary key default gen_random_uuid(),
  diet_plan_id uuid not null references public.diet_plans (id) on delete cascade,
  meal_type text not null check (
    meal_type in ('breakfast', 'lunch', 'dinner', 'snack')
  ),
  suggested_food text not null,
  calories numeric not null default 0,
  protein_g numeric not null default 0,
  carbs_g numeric not null default 0,
  fat_g numeric not null default 0
);

-- ============================================================
-- 0006_body_measurements.sql
-- ============================================================
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

-- ============================================================
-- 0007_water_sleep_logs.sql
-- ============================================================
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

-- ============================================================
-- 0008_goals.sql
-- ============================================================
create table if not exists public.goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  type text not null check (
    type in ('weight', 'water', 'workout_frequency', 'sleep', 'custom')
  ),
  title text not null,
  target_value numeric not null,
  current_value numeric not null default 0,
  unit text,
  deadline date,
  status text not null default 'active' check (
    status in ('active', 'completed', 'abandoned')
  ),
  created_at timestamptz not null default now()
);

create index if not exists idx_goals_user_status
  on public.goals (user_id, status);

-- ============================================================
-- 0009_notifications.sql
-- ============================================================
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

-- ============================================================
-- 0010_rls_policies.sql
-- ============================================================
-- Row Level Security: every user can only see/modify their own data.
-- exercises_library is the one exception (public read of non-custom rows).

alter table public.profiles enable row level security;
alter table public.exercises_library enable row level security;
alter table public.workouts enable row level security;
alter table public.workout_exercises enable row level security;
alter table public.workout_schedule enable row level security;
alter table public.workout_logs enable row level security;
alter table public.workout_log_sets enable row level security;
alter table public.recipes enable row level security;
alter table public.meals enable row level security;
alter table public.meal_logs enable row level security;
alter table public.diet_plans enable row level security;
alter table public.diet_plan_meals enable row level security;
alter table public.body_measurements enable row level security;
alter table public.water_logs enable row level security;
alter table public.sleep_logs enable row level security;
alter table public.goals enable row level security;
alter table public.notification_settings enable row level security;
alter table public.reminders enable row level security;

-- profiles: PK is the user id itself
create policy "profiles_select_own" on public.profiles for select using (auth.uid() = id);
create policy "profiles_insert_own" on public.profiles for insert with check (auth.uid() = id);
create policy "profiles_update_own" on public.profiles for update using (auth.uid() = id);

-- exercises_library: public exercises readable by everyone; custom ones owner-only
create policy "exercises_select_public_or_own" on public.exercises_library
  for select using (is_custom = false or created_by = auth.uid());
create policy "exercises_insert_own" on public.exercises_library
  for insert with check (created_by = auth.uid());
create policy "exercises_update_own" on public.exercises_library
  for update using (created_by = auth.uid());
create policy "exercises_delete_own" on public.exercises_library
  for delete using (created_by = auth.uid());

-- Generic owner-only tables (have a direct user_id column)
do $$
declare
  t text;
  owner_tables text[] := array[
    'workouts', 'workout_schedule', 'workout_logs', 'recipes', 'meals',
    'meal_logs', 'diet_plans', 'body_measurements', 'water_logs',
    'sleep_logs', 'goals', 'notification_settings', 'reminders'
  ];
begin
  foreach t in array owner_tables loop
    execute format(
      'create policy "%1$s_select_own" on public.%1$s for select using (auth.uid() = user_id);',
      t
    );
    execute format(
      'create policy "%1$s_insert_own" on public.%1$s for insert with check (auth.uid() = user_id);',
      t
    );
    execute format(
      'create policy "%1$s_update_own" on public.%1$s for update using (auth.uid() = user_id);',
      t
    );
    execute format(
      'create policy "%1$s_delete_own" on public.%1$s for delete using (auth.uid() = user_id);',
      t
    );
  end loop;
end $$;

-- Child tables without their own user_id: gate access via the parent row.
create policy "workout_exercises_all_via_workout" on public.workout_exercises
  for all using (
    exists (
      select 1 from public.workouts w
      where w.id = workout_exercises.workout_id and w.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.workouts w
      where w.id = workout_exercises.workout_id and w.user_id = auth.uid()
    )
  );

create policy "workout_log_sets_all_via_log" on public.workout_log_sets
  for all using (
    exists (
      select 1 from public.workout_logs l
      where l.id = workout_log_sets.workout_log_id and l.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.workout_logs l
      where l.id = workout_log_sets.workout_log_id and l.user_id = auth.uid()
    )
  );

create policy "diet_plan_meals_all_via_plan" on public.diet_plan_meals
  for all using (
    exists (
      select 1 from public.diet_plans p
      where p.id = diet_plan_meals.diet_plan_id and p.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.diet_plans p
      where p.id = diet_plan_meals.diet_plan_id and p.user_id = auth.uid()
    )
  );

-- Storage buckets: avatars (public read) and recipe images (public read).
-- Writes are restricted to the owner via the first path segment being their user id,
-- e.g. avatars/<user_id>/photo.jpg
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public)
values ('recipe-images', 'recipe-images', true)
on conflict (id) do nothing;

create policy "avatars_public_read" on storage.objects
  for select using (bucket_id = 'avatars');
create policy "avatars_owner_write" on storage.objects
  for insert with check (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "avatars_owner_update" on storage.objects
  for update using (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "avatars_owner_delete" on storage.objects
  for delete using (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "recipe_images_public_read" on storage.objects
  for select using (bucket_id = 'recipe-images');
create policy "recipe_images_owner_write" on storage.objects
  for insert with check (
    bucket_id = 'recipe-images' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "recipe_images_owner_update" on storage.objects
  for update using (
    bucket_id = 'recipe-images' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "recipe_images_owner_delete" on storage.objects
  for delete using (
    bucket_id = 'recipe-images' and (storage.foldername(name))[1] = auth.uid()::text
  );

