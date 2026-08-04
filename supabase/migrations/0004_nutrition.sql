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
