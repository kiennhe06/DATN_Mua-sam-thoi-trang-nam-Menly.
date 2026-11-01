import { supabase } from '../config/supabase.js';

// Lop truy cap du lieu cho: Gio hang
export class CartModel {
  protected db = supabase;

  // Lay gio hang cua nguoi dung (kem bien the + san pham)
  async findByUser(userId: string) {
    const { data, error } = await this.db
      .from('cart_items')
      .select('variant_id, quantity, updated_at, product_variants(*, products(*))')
      .eq('user_id', userId);
    if (error) throw new Error(error.message);
    return data;
  }

  // Them hoac cap nhat so luong 1 mon
  async upsertItem(userId: string, variantId: string, quantity: number) {
    const { error } = await this.db
      .from('cart_items')
      .upsert(
        { user_id: userId, variant_id: variantId, quantity, updated_at: new Date().toISOString() },
        { onConflict: 'user_id,variant_id' },
      );
    if (error) throw new Error(error.message);
    return true;
  }

  async removeItem(userId: string, variantId: string) {
    const { error } = await this.db
      .from('cart_items')
      .delete()
      .eq('user_id', userId)
      .eq('variant_id', variantId);
    if (error) throw new Error(error.message);
    return true;
  }

  async clear(userId: string) {
    const { error } = await this.db.from('cart_items').delete().eq('user_id', userId);
    if (error) throw new Error(error.message);
    return true;
  }
}
