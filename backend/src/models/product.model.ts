import { supabase } from '../config/supabase.js';

// Lop truy cap du lieu cho: San pham
export class ProductModel {
  protected db = supabase;

  // Lay danh sach san pham (loc theo danh muc, tim theo ten)
  async findAll(opts: { search?: string; categoryId?: string; limit?: number } = {}) {
    let query = this.db.from('products').select('*').eq('is_active', true);
    if (opts.categoryId) query = query.eq('category_id', opts.categoryId);
    if (opts.search) query = query.ilike('name', `%${opts.search}%`);
    query = query.order('created_at', { ascending: false }).limit(opts.limit ?? 50);

    const { data, error } = await query;
    if (error) throw new Error(error.message);
    return data;
  }

  // Lay chi tiet 1 san pham kem bien the + anh
  async findById(id: string) {
    const { data, error } = await this.db
      .from('products')
      .select('*, product_variants(*), product_images(*)')
      .eq('id', id)
      .single();
    if (error) throw new Error(error.message);
    return data;
  }
}
