-- Tracks calls to the analyze-food AI function per user, so the edge
-- function can rate-limit and prevent runaway Anthropic API-cost abuse.
create table if not exists public.ai_usage_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

create index if not exists idx_ai_usage_log_user_created
  on public.ai_usage_log (user_id, created_at);

alter table public.ai_usage_log enable row level security;

-- Only the service role (used by the edge function) writes rows; users can
-- read their own usage history but never insert/update/delete directly.
create policy "ai_usage_log_select_own" on public.ai_usage_log
  for select using (auth.uid() = user_id);
