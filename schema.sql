-- ============================================================
-- ConstructONS Homes — Supabase schema
-- Run this in: Supabase Dashboard > SQL Editor > New Query > Run
-- ============================================================

-- Projects: one row per client's home-build
create table if not exists projects (
  id uuid primary key default gen_random_uuid(),
  client_id uuid references auth.users(id) not null,
  client_name text not null,
  project_name text not null,
  site_ref text,
  package text,               -- Basic / Essential / Premium / Luxury
  built_up_area numeric,
  contract_value numeric,
  amount_paid numeric default 0,
  current_stage text,
  progress_pct integer default 0,
  created_at timestamp with time zone default now()
);

-- Milestones: the 10-stage lifecycle per project
create table if not exists milestones (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  stage_order integer not null,
  name text not null,          -- e.g. "Advisory™", "Design™"...
  status text not null default 'pending',  -- pending | active | done
  date text                    -- display text, e.g. "Completed 12 Jan 2026"
);

-- Documents: files shared with the client
create table if not exists documents (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  name text not null,
  url text,                    -- link to file (e.g. in Supabase Storage)
  uploaded_at timestamp with time zone default now()
);

-- Payments: milestone-based payment schedule
create table if not exists payments (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  name text not null,
  pct text,                    -- e.g. "15%"
  amount numeric,
  status text default 'pending',  -- pending | active | done
  due_date date
);

-- Leads: captured from the website contact form
create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  full_name text,
  phone text,
  city text,
  plot_area numeric,
  notes text,
  created_at timestamp with time zone default now()
);

-- ---------- Row Level Security ----------
-- Ensures each client can only see their OWN project data.
alter table projects enable row level security;
alter table milestones enable row level security;
alter table documents enable row level security;
alter table payments enable row level security;
alter table leads enable row level security;

create policy "Clients can view their own project"
  on projects for select using (auth.uid() = client_id);

create policy "Clients can view their own milestones"
  on milestones for select using (
    project_id in (select id from projects where client_id = auth.uid())
  );

create policy "Clients can view their own documents"
  on documents for select using (
    project_id in (select id from projects where client_id = auth.uid())
  );

create policy "Clients can view their own payments"
  on payments for select using (
    project_id in (select id from projects where client_id = auth.uid())
  );

-- Anyone (even logged-out visitors) can submit a lead from the contact form
create policy "Anyone can submit a lead"
  on leads for insert with check (true);

-- ============================================================
-- To add a project for a client after they sign up:
-- 1. Get their user id from Authentication > Users in Supabase
-- 2. Run:
--    insert into projects (client_id, client_name, project_name, site_ref,
--      package, built_up_area, contract_value, amount_paid, current_stage, progress_pct)
--    values ('paste-user-id-here', 'Rahul', 'Green Villa', 'Site A-12',
--      'Premium', 1500, 3297000, 1483650, 'Build — Stage 08', 68);
-- 3. Then insert matching rows into milestones, documents, and payments
--    with that project's id.
-- ============================================================
