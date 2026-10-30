import { supabase } from '../config/supabase.js';

// Lop truy cap du lieu cho: Danh muc
export class CategoryModel {
  protected db = supabase;

  async findAll() {
    const { data, error } = await this.db
      .from('categories')
      .select('*')
      .order('sort_order', { ascending: true });
    if (error) throw new Error(error.message);
    return data;
  }
}
