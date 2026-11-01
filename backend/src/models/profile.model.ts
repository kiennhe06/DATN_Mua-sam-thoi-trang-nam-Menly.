import { supabase } from '../config/supabase.js';

// Lop truy cap du lieu cho: Ho so ca nhan
export class ProfileModel {
  protected db = supabase;

  async getById(userId: string) {
    const { data, error } = await this.db
      .from('profiles')
      .select('id, email, full_name, phone, avatar_url, role, created_at')
      .eq('id', userId)
      .maybeSingle();
    if (error) throw new Error(error.message);
    return data;
  }

  async update(userId: string, fields: { full_name?: string; phone?: string; avatar_url?: string }) {
    const updates: Record<string, string> = {};
    if (fields.full_name !== undefined) updates.full_name = fields.full_name;
    if (fields.phone !== undefined) updates.phone = fields.phone;
    if (fields.avatar_url !== undefined) updates.avatar_url = fields.avatar_url;

    const { data, error } = await this.db
      .from('profiles')
      .update(updates)
      .eq('id', userId)
      .select('id, email, full_name, phone, avatar_url, role')
      .maybeSingle();
    if (error) throw new Error(error.message);
    return data;
  }
}
