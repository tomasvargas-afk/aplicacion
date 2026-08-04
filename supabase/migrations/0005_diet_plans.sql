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
