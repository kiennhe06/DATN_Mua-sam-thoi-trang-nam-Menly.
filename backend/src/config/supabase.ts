import { createClient } from '@supabase/supabase-js';
import { env } from './env.js';

// Ket noi toi Supabase (PostgreSQL + Auth + Storage).
export const supabase = createClient(env.supabaseUrl, env.supabaseServiceRoleKey);
