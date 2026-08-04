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
