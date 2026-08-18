alter table public.workout_logs
  add column if not exists calories_burned numeric;
