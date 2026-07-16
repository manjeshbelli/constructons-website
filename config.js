// ============================================================
// ConstructONS — Supabase configuration
// ------------------------------------------------------------
// 1. Create a free project at https://supabase.com
// 2. Go to Project Settings > API
// 3. Copy your "Project URL" and "anon public" key below
// 4. Run schema.sql in the Supabase SQL Editor to create tables
// ============================================================
const SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL"; // e.g. https://xxxxx.supabase.co
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";

const SUPABASE_CONFIGURED = SUPABASE_URL.startsWith("https://") && SUPABASE_ANON_KEY.length > 20;

let supabaseClient = null;
if (SUPABASE_CONFIGURED && window.supabase) {
  supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
}
