-- Follow-up to 0017: that migration was already recorded as applied by
-- the time this second fix was written, so it needs its own file to
-- actually run. Same gap: workout_log_sets.exercise_id blocked deleting
-- a custom exercise (or its owning user) if any set referenced it.
alter table public.workout_log_sets
  drop constraint workout_log_sets_exercise_id_fkey;

alter table public.workout_log_sets
  add constraint workout_log_sets_exercise_id_fkey
  foreign key (exercise_id) references public.exercises_library (id) on delete cascade;
