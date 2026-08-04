alter table public.workout_exercises
  add column if not exists target_weight_kg numeric;
