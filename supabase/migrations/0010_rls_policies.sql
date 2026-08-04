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
