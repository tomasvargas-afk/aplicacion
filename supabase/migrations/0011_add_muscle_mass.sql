alter table public.body_measurements
  add column if not exists muscle_mass_percent numeric;
