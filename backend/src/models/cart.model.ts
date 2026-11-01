import { supabase } from '../config/supabase.js';

export class CartError extends Error {
  statusCode: number;
  constructor(message: string, statusCode = 400) {
    super(message);
    this.name = 'CartError';
    this.statusCode = statusCode;
  }
}

export interface CartItemProductInfo {
  id: string;
  name: string;
  slug: string;
  price: number;
  thumbnailUrl: string | null;
  thumbnail_url?: string | null;
  isActive: boolean;
  is_active?: boolean;
}

export interface CartItemVariantInfo {
  id: string;
  size: string;
  color: string;
  sku: string;
  stock: number;
  products?: {
    id: string;
    name: string;
    slug: string;
    price: number;
    thumbnail_url: string | null;
    is_active: boolean;
  };
}

export interface CartItemDetail {
  variant_id: string;
  variantId: string;
  quantity: number;
  price: number;
  itemTotal: number;
  stock: number;
  isOutOfStock: boolean;
  updatedAt: string;
  updated_at: string;
  product_variants: {
    id: string;
    size: string;
    color: string;
    sku: string;
    stock: number;
    products: {
      id: string;
      name: string;
      slug: string;
      price: number;
      thumbnail_url: string | null;
      is_active: boolean;
    };
  };
  variant: CartItemVariantInfo;
  product: CartItemProductInfo;
}

export interface CartSummary {
  items: CartItemDetail[];
  totalItems: number;
  subtotal: number;
}

interface RawProductData {
  id: string;
  name: string;
  slug: string;
  price: number;
  thumbnail_url: string | null;
  is_active: boolean;
  approval_status?: string;
}

interface RawVariantData {
  id: string;
  product_id: string;
  size: string;
  color: string;
  sku: string;
  stock: number;
  products: RawProductData | RawProductData[] | null;
}

interface RawCartItemRow {
  variant_id: string;
  quantity: number;
  updated_at: string;
  product_variants: RawVariantData | RawVariantData[] | null;
}

function extractProduct(variantData: RawVariantData | RawVariantData[] | null): RawProductData | null {
  if (!variantData) return null;
  const singleVariant = Array.isArray(variantData) ? variantData[0] : variantData;
  if (!singleVariant?.products) return null;
  return Array.isArray(singleVariant.products) ? singleVariant.products[0] : singleVariant.products;
}

function extractVariant(variantData: RawVariantData | RawVariantData[] | null): RawVariantData | null {
  if (!variantData) return null;
  return Array.isArray(variantData) ? variantData[0] : variantData;
}

export class CartModel {
  protected db = supabase;

  /**
   * Lấy chi tiết toàn bộ giỏ hàng của người dùng (tương thích cả frontend mobile và web)
   */
  async getCart(userId: string): Promise<CartSummary> {
    const { data, error } = await this.db
      .from('cart_items')
      .select(`
        variant_id,
        quantity,
        updated_at,
        product_variants (
          id,
          product_id,
          size,
          color,
          sku,
          stock,
          products (
            id,
            name,
            slug,
            price,
            thumbnail_url,
            is_active,
            approval_status
          )
        )
      `)
      .eq('user_id', userId)
      .order('updated_at', { ascending: false });

    if (error) {
      throw new Error(`Lỗi truy vấn giỏ hàng: ${error.message}`);
    }

    const rows = (data || []) as unknown as RawCartItemRow[];
    let subtotal = 0;
    let totalItems = 0;

    const items: CartItemDetail[] = rows.map((row) => {
      const variant = extractVariant(row.product_variants);
      const product = extractProduct(row.product_variants);

      const price = product?.price ?? 0;
      const stock = variant?.stock ?? 0;
      const quantity = row.quantity;
      const itemTotal = price * quantity;

      subtotal += itemTotal;
      totalItems += quantity;

      const productPayload = {
        id: product?.id ?? '',
        name: product?.name ?? 'Sản phẩm không khả dụng',
        slug: product?.slug ?? '',
        price,
        thumbnailUrl: product?.thumbnail_url ?? null,
        thumbnail_url: product?.thumbnail_url ?? null,
        isActive: Boolean(product?.is_active),
        is_active: Boolean(product?.is_active),
      };

      const variantPayload = {
        id: variant?.id ?? row.variant_id,
        size: variant?.size ?? '',
        color: variant?.color ?? '',
        sku: variant?.sku ?? '',
        stock,
        products: productPayload,
      };

      return {
        variant_id: row.variant_id,
        variantId: row.variant_id,
        quantity,
        price,
        itemTotal,
        stock,
        isOutOfStock: stock < quantity,
        updatedAt: row.updated_at,
        updated_at: row.updated_at,
        product_variants: variantPayload,
        variant: variantPayload,
        product: productPayload,
      };
    });

    return {
      items,
      totalItems,
      subtotal,
    };
  }

  /**
   * Alias tương thích findByUser
   */
  async findByUser(userId: string) {
    const summary = await this.getCart(userId);
    return summary.items;
  }

  /**
   * Thêm sản phẩm (biến thể) vào giỏ hàng và kiểm tra tồn kho
   */
  async addItem(userId: string, variantId: string, quantity = 1): Promise<CartSummary> {
    // 1. Kiểm tra biến thể tồn tại và lấy số lượng tồn kho
    const { data: variantRaw, error: variantError } = await this.db
      .from('product_variants')
      .select(`
        id,
        product_id,
        size,
        color,
        sku,
        stock,
        products (
          id,
          name,
          price,
          is_active,
          approval_status
        )
      `)
      .eq('id', variantId)
      .maybeSingle();

    if (variantError) {
      throw new Error(`Lỗi kiểm tra biến thể: ${variantError.message}`);
    }

    if (!variantRaw) {
      throw new CartError('Biến thể sản phẩm không tồn tại', 404);
    }

    const variant = variantRaw as unknown as RawVariantData;
    const product = extractProduct(variant);

    // 2. Kiểm tra trạng thái hoạt động của sản phẩm
    if (!product || !product.is_active || (product.approval_status && product.approval_status !== 'approved')) {
      throw new CartError('Sản phẩm hiện không còn kinh doanh hoặc đang tạm ngừng', 400);
    }

    if (variant.stock <= 0) {
      throw new CartError('Sản phẩm này hiện đã hết hàng trong kho', 400);
    }

    // 3. Kiểm tra số lượng đã có trong giỏ hàng của user
    const { data: existingItem, error: existingError } = await this.db
      .from('cart_items')
      .select('quantity')
      .eq('user_id', userId)
      .eq('variant_id', variantId)
      .maybeSingle();

    if (existingError) {
      throw new Error(`Lỗi kiểm tra giỏ hàng: ${existingError.message}`);
    }

    const currentQty = existingItem?.quantity ?? 0;
    const newQty = currentQty + quantity;

    // 4. Kiểm tra điều kiện tồn kho và giới hạn giỏ hàng
    if (newQty > variant.stock) {
      throw new CartError(
        `Số lượng trong kho không đủ. Kho chỉ còn ${variant.stock} sản phẩm (bạn đã có ${currentQty} trong giỏ)`,
        400
      );
    }

    if (newQty > 20) {
      throw new CartError('Số lượng tối đa cho mỗi sản phẩm trong giỏ hàng là 20', 400);
    }

    // 5. Thêm hoặc cập nhật vào database
    const { error: upsertError } = await this.db
      .from('cart_items')
      .upsert(
        {
          user_id: userId,
          variant_id: variantId,
          quantity: newQty,
          updated_at: new Date().toISOString(),
        },
        { onConflict: 'user_id,variant_id' }
      );

    if (upsertError) {
      throw new Error(`Không thể thêm vào giỏ hàng: ${upsertError.message}`);
    }

    return this.getCart(userId);
  }

  /**
   * Cập nhật số lượng của một sản phẩm trong giỏ hàng
   */
  async updateQuantity(userId: string, variantId: string, quantity: number): Promise<CartSummary> {
    if (quantity < 1) {
      throw new CartError('Số lượng phải từ 1 trở lên. Để bỏ sản phẩm vui lòng chọn chức năng xóa', 400);
    }

    if (quantity > 20) {
      throw new CartError('Số lượng tối đa cho mỗi sản phẩm trong giỏ hàng là 20', 400);
    }

    // 1. Kiểm tra xem item có trong giỏ hàng không
    const { data: existingItem, error: findError } = await this.db
      .from('cart_items')
      .select('quantity')
      .eq('user_id', userId)
      .eq('variant_id', variantId)
      .maybeSingle();

    if (findError) {
      throw new Error(`Lỗi kiểm tra giỏ hàng: ${findError.message}`);
    }

    if (!existingItem) {
      throw new CartError('Sản phẩm không có trong giỏ hàng của bạn', 404);
    }

    // 2. Kiểm tra tồn kho của biến thể
    const { data: variant, error: varError } = await this.db
      .from('product_variants')
      .select('id, stock')
      .eq('id', variantId)
      .maybeSingle();

    if (varError) {
      throw new Error(`Lỗi kiểm tra biến thể: ${varError.message}`);
    }

    if (!variant) {
      throw new CartError('Biến thể sản phẩm không tồn tại', 404);
    }

    if (quantity > variant.stock) {
      throw new CartError(
        `Số lượng yêu cầu (${quantity}) vượt quá tồn kho hiện tại (còn lại ${variant.stock} sản phẩm)`,
        400
      );
    }

    // 3. Cập nhật số lượng mới
    const { error: updateError } = await this.db
      .from('cart_items')
      .update({
        quantity,
        updated_at: new Date().toISOString(),
      })
      .eq('user_id', userId)
      .eq('variant_id', variantId);

    if (updateError) {
      throw new Error(`Không thể cập nhật số lượng: ${updateError.message}`);
    }

    return this.getCart(userId);
  }

  /**
   * Tương thích upsertItem
   */
  async upsertItem(userId: string, variantId: string, quantity: number) {
    return this.updateQuantity(userId, variantId, quantity).catch(async (err) => {
      if (err instanceof CartError && err.statusCode === 404) {
        return this.addItem(userId, variantId, quantity);
      }
      throw err;
    });
  }

  /**
   * Xóa một sản phẩm khỏi giỏ hàng
   */
  async removeItem(userId: string, variantId: string): Promise<CartSummary> {
    const { data: existingItem, error: findError } = await this.db
      .from('cart_items')
      .select('quantity')
      .eq('user_id', userId)
      .eq('variant_id', variantId)
      .maybeSingle();

    if (findError) {
      throw new Error(`Lỗi kiểm tra giỏ hàng: ${findError.message}`);
    }

    if (!existingItem) {
      throw new CartError('Sản phẩm không tồn tại trong giỏ hàng của bạn', 404);
    }

    const { error: deleteError } = await this.db
      .from('cart_items')
      .delete()
      .eq('user_id', userId)
      .eq('variant_id', variantId);

    if (deleteError) {
      throw new Error(`Không thể xóa sản phẩm khỏi giỏ hàng: ${deleteError.message}`);
    }

    return this.getCart(userId);
  }

  /**
   * Xóa toàn bộ giỏ hàng (Clear Cart)
   */
  async clearCart(userId: string): Promise<{ success: boolean; message: string }> {
    const { error } = await this.db
      .from('cart_items')
      .delete()
      .eq('user_id', userId);

    if (error) {
      throw new Error(`Không thể làm trống giỏ hàng: ${error.message}`);
    }

    return {
      success: true,
      message: 'Đã xóa toàn bộ sản phẩm khỏi giỏ hàng thành công',
    };
  }

  async clear(userId: string) {
    return this.clearCart(userId);
  }
}
