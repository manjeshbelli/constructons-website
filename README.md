# ConstructONS Homes — Website

A 3-page site: marketing homepage, client login, and client dashboard.
Built with plain HTML/CSS/JS — no build tools, no command line required.

## Files
- `index.html` — marketing homepage (hero, lifecycle, packages, contact form)
- `login.html` — client login / sign-up
- `dashboard.html` — client project dashboard (progress, milestones, documents, payments)
- `style.css` — shared design system
- `config.js` — where you paste your Supabase credentials
- `schema.sql` — database setup script

## Part 1 — See it working right now (no setup)
Just open `index.html` in your browser, or drag the whole folder onto
https://app.netlify.com/drop — the site works immediately, and the client
dashboard runs in **demo mode** with sample data so you can see exactly
how it will look and feel.

## Part 2 — Connect a real backend (free, ~15 minutes)

### Step 1: Create a Supabase project
1. Go to https://supabase.com → Sign up (free) → "New Project"
2. Wait ~2 minutes for it to provision

### Step 2: Set up the database
1. In your Supabase project, open **SQL Editor** (left sidebar)
2. Click **New Query**, paste the entire contents of `schema.sql`, click **Run**
3. This creates your tables (projects, milestones, documents, payments, leads)
   and locks them down so each client can only see their own data

### Step 3: Connect the website to Supabase
1. In Supabase: **Project Settings → API**
2. Copy the **Project URL** and the **anon public** key
3. Open `config.js` and paste them in:
   ```js
   const SUPABASE_URL = "https://xxxxx.supabase.co";
   const SUPABASE_ANON_KEY = "eyJhbGcouand-so-on...";
   ```
4. Save the file

### Step 4: Add your first client
1. Have the client sign up on `login.html` (or create them manually in
   Supabase: **Authentication → Users → Add User**)
2. Copy their **User UID** from the Authentication tab
3. In SQL Editor, run (edit the values first):
   ```sql
   insert into projects (client_id, client_name, project_name, site_ref,
     package, built_up_area, contract_value, amount_paid, current_stage, progress_pct)
   values ('paste-user-id-here', 'Rahul', 'Green Villa', 'Site A-12',
     'Premium', 1500, 3297000, 1483650, 'Build — Stage 08', 68);
   ```
4. Then add matching rows to `milestones`, `documents`, and `payments`
   using that project's `id` (see comments at the bottom of `schema.sql`)

That client can now log in and see their real project data.

## Part 3 — Host it for real (free)

**Easiest: Netlify Drop**
1. Go to https://app.netlify.com/drop
2. Drag this whole folder onto the page
3. You get a live URL in ~10 seconds (e.g. `constructons-homes.netlify.app`)
4. To use your own domain (e.g. constructonshomes.com): Netlify → Domain
   settings → Add custom domain, then update your domain's DNS as instructed

**Alternative: Vercel, GitHub Pages, or Cloudflare Pages** — all free,
all work the same way for a plain HTML/CSS/JS site like this one.

## Updating content later
- **Packages/pricing**: edit the `#packages` section in `index.html`
- **Colors/fonts**: edit the `:root` variables at the top of `style.css`
- **Lifecycle stages**: edit the `.pipeline` section in `index.html`

## What this does NOT include yet (recommended next additions)
- File upload for documents (use Supabase Storage — a few lines of code)
- Admin panel for your team to update project progress (currently done via
  SQL Editor or you can ask a developer to build a simple admin page using
  the same Supabase tables)
- Email/SMS notifications on milestone completion
- Payment gateway integration (Razorpay/Stripe) for online payments

For any of these, come back and ask — they build on the same foundation.
