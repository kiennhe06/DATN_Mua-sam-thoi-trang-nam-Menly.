import { supabase } from '../config/supabase.js';

// Lop truy cap du lieu cho: Yeu thich
export class WishlistModel {
  protected db = supabase;

  // Danh sach yeu thich cua 1 nguoi (kem thong tin san pham)
  async findByUser(userId: string) {
    const { data, error } = await this.db
      .from('wishlists')
      .select('product_id, created_at, products(*)')
      .eq('user_id', userId)
      .order('created_at', { ascending: false });
    if (error) throw new Error(error.message);
    return data;
  }

  async add(userId: string, productId: string) {
    const { error } = await this.db
      .from('wishlists')
      .upsert({ user_id: userId, product_id: productId }, { onConflict: 'user_id,product_id' });
    if (error) throw new Error(error.message);
    return true;
  }

  async remove(userId: string, productId: string) {
    const { error } = await this.db
      .from('wishlists')
      .delete()
      .eq('user_id', userId)
      .eq('product_id', productId);
    if (error) throw new Error(error.message);
    return true;
  }

  async exists(userId: string, productId: string) {
    const { count, error } = await this.db
      .from('wishlists')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId)
      .eq('product_id', productId);
    if (error) throw new Error(error.message);
    return (count ?? 0) > 0;
  }
}
