-- workout_exercises.exercise_id had no ON DELETE behavior, which blocked
-- deleting a custom exercise (or the user that owns it, via the
-- exercises_library.created_by cascade) whenever it was still used in a
-- routine. Cascading here means: if the exercise is gone, the routine's
-- reference to it is removed too (rather than blocking the delete).
alter table public.workout_exercises
  drop constraint workout_exercises_exercise_id_fkey;

alter table public.workout_exercises
  add constraint workout_exercises_exercise_id_fkey
  foreign key (exercise_id) references public.exercises_library (id) on delete cascade;
