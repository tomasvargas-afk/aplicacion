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
