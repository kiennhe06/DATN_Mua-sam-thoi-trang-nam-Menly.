import { supabase } from '../config/supabase.js';
import type {
  AdminProductInput,
  AdminProductListOptions,
  AdminProductUpdate,
} from '../validators/admin-product.validator.js';

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

  async findAdminAll(opts: AdminProductListOptions) {
    let query = this.db.from('products').select('*');
    if (opts.categoryId) query = query.eq('category_id', opts.categoryId);
    if (opts.search) query = query.ilike('name', `%${opts.search}%`);
    if (opts.approvalStatus) query = query.eq('approval_status', opts.approvalStatus);
    if (opts.isActive !== undefined) query = query.eq('is_active', opts.isActive);

    const { data, error } = await query
      .order('created_at', { ascending: false })
      .limit(opts.limit);
    if (error) throw new Error(error.message);
    return data;
  }

  async createAdminProduct(input: AdminProductInput) {
    const { data, error } = await this.db
      .from('products')
      .insert({
        category_id: input.categoryId,
        name: input.name,
        slug: input.slug,
        description: input.description || null,
        price: input.price,
        thumbnail_url: input.thumbnailUrl || null,
        search_text: [input.name, input.description].filter(Boolean).join(' '),
        approval_status: 'pending',
      })
      .select('*')
      .single();

    if (error) throw new Error(error.message);
    return data;
  }

  async updateAdminProduct(id: string, input: AdminProductUpdate) {
    const updates: Record<string, string | number | null> = {};
    if (input.categoryId !== undefined) updates.category_id = input.categoryId;
    if (input.name !== undefined) updates.name = input.name;
    if (input.slug !== undefined) updates.slug = input.slug;
    if (input.description !== undefined) updates.description = input.description || null;
    if (input.price !== undefined) updates.price = input.price;
    if (input.thumbnailUrl !== undefined) updates.thumbnail_url = input.thumbnailUrl || null;
    const { data, error } = await this.db
      .from('products')
      .update(updates)
      .eq('id', id)
      .select('*')
      .maybeSingle();

    if (error) throw new Error(error.message);
    return data;
  }

  async deactivateAdminProduct(id: string) {
    const { data, error } = await this.db
      .from('products')
      .update({ is_active: false })
      .eq('id', id)
      .select('*')
      .maybeSingle();

    if (error) throw new Error(error.message);
    return data;
  }

  async approveAdminProduct(id: string) {
    const { data, error } = await this.db
      .from('products')
      .update({ approval_status: 'approved' })
      .eq('id', id)
      .select('*')
      .maybeSingle();

    if (error) throw new Error(error.message);
    return data;
  }
}
