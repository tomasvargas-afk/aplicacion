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
