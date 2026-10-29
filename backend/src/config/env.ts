import 'dotenv/config';

// Doc cau hinh tu bien moi truong (.env). Khong hardcode secret trong code.
export const env = {
  port: Number(process.env.PORT ?? 5000),
  supabaseUrl: process.env.SUPABASE_URL ?? '',
  supabaseServiceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY ?? '',
};
