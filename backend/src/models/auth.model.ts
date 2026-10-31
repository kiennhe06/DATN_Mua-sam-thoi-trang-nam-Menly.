import { createClient } from '@supabase/supabase-js';
import { env } from '../config/env.js';
import { supabase } from '../config/supabase.js';

export class AuthModel {
  async login(email: string, password: string) {
    if (!env.supabaseUrl || !env.supabaseAnonKey) {
      throw new Error('Thiếu cấu hình SUPABASE_URL hoặc SUPABASE_ANON_KEY');
    }

    const authClient = createClient(env.supabaseUrl, env.supabaseAnonKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    const { data: authData, error: authError } = await authClient.auth.signInWithPassword({
      email,
      password,
    });

    if (authError || !authData.user || !authData.session) {
      throw new LoginCredentialsError();
    }

    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('id, email, full_name, role, is_active, is_locked')
      .eq('id', authData.user.id)
      .maybeSingle();

    if (profileError) throw new Error(profileError.message);
    if (!profile || profile.role !== 'admin' || !profile.is_active || profile.is_locked) {
      throw new LoginCredentialsError();
    }

    return {
      accessToken: authData.session.access_token,
      expiresAt: authData.session.expires_at,
      user: {
        id: profile.id,
        email: profile.email,
        fullName: profile.full_name,
        role: profile.role,
      },
    };
  }
}

export class LoginCredentialsError extends Error {
  constructor() {
    super('Thông tin đăng nhập hoặc quyền quản trị không hợp lệ');
    this.name = 'LoginCredentialsError';
  }
}
