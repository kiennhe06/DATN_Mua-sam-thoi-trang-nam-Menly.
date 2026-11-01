import { z } from 'zod';

export const addToCartSchema = z
  .object({
    variantId: z.string().uuid('Mã biến thể sản phẩm không hợp lệ (cần định dạng UUID)').optional(),
    variant_id: z.string().uuid('Mã biến thể sản phẩm không hợp lệ (cần định dạng UUID)').optional(),
    quantity: z.coerce
      .number({ invalid_type_error: 'Số lượng phải là một số nguyên' })
      .int('Số lượng phải là số nguyên')
      .min(1, 'Số lượng tối thiểu là 1')
      .max(20, 'Số lượng tối đa mỗi lần thêm vào giỏ là 20')
      .default(1),
  })
  .refine((data) => Boolean(data.variantId || data.variant_id), {
    message: 'Vui lòng cung cấp mã biến thể sản phẩm (variantId hoặc variant_id)',
    path: ['variantId'],
  });

export const updateCartItemSchema = z.object({
  quantity: z.coerce
    .number({ required_error: 'Vui lòng nhập số lượng', invalid_type_error: 'Số lượng phải là một số nguyên' })
    .int('Số lượng phải là số nguyên')
    .min(1, 'Số lượng tối thiểu là 1')
    .max(20, 'Số lượng tối đa cho mỗi sản phẩm trong giỏ hàng là 20'),
});

export const putCartItemBodySchema = z
  .object({
    variantId: z.string().uuid('Mã biến thể sản phẩm không hợp lệ (cần định dạng UUID)').optional(),
    variant_id: z.string().uuid('Mã biến thể sản phẩm không hợp lệ (cần định dạng UUID)').optional(),
    quantity: z.coerce
      .number({ required_error: 'Vui lòng nhập số lượng', invalid_type_error: 'Số lượng phải là một số nguyên' })
      .int('Số lượng phải là số nguyên')
      .min(1, 'Số lượng tối thiểu là 1')
      .max(20, 'Số lượng tối đa cho mỗi sản phẩm trong giỏ hàng là 20'),
  })
  .refine((data) => Boolean(data.variantId || data.variant_id), {
    message: 'Vui lòng cung cấp mã biến thể sản phẩm (variantId hoặc variant_id)',
    path: ['variantId'],
  });

export const variantIdParamSchema = z.object({
  variantId: z.string().uuid('Mã biến thể không đúng định dạng UUID'),
});

export type AddToCartInput = z.infer<typeof addToCartSchema>;
export type UpdateCartItemInput = z.infer<typeof updateCartItemSchema>;
export type PutCartItemBodyInput = z.infer<typeof putCartItemBodySchema>;

