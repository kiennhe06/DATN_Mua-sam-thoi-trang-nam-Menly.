import { supabase } from '../config/supabase.js';

// Lop truy cap du lieu cho: Danh gia
export class ReviewModel {
  protected db = supabase;

  // Danh sach danh gia cua 1 san pham
  async findByProduct(productId: string) {
    const { data, error } = await this.db
      .from('product_reviews')
      .select('id, user_id, rating, comment, images, reply_comment, reply_at, created_at')
      .eq('product_id', productId)
      .order('created_at', { ascending: false });
    if (error) throw new Error(error.message);
    return data;
  }

  // Tao danh gia (gan voi 1 order_item da mua)
  async create(input: {
    userId: string;
    productId: string;
    orderItemId: string;
    rating: number;
    comment?: string;
  }) {
    const { data, error } = await this.db
      .from('product_reviews')
      .insert({
        user_id: input.userId,
        product_id: input.productId,
        order_item_id: input.orderItemId,
        rating: input.rating,
        comment: input.comment ?? null,
      })
      .select('*')
      .single();
    if (error) throw new Error(error.message);
    return data;
  }

  // Xoa danh gia cua chinh minh
  async removeOwn(reviewId: string, userId: string) {
    const { data, error } = await this.db
      .from('product_reviews')
      .delete()
      .eq('id', reviewId)
      .eq('user_id', userId)
      .select('id')
      .maybeSingle();
    if (error) throw new Error(error.message);
    return data;
  }
}
