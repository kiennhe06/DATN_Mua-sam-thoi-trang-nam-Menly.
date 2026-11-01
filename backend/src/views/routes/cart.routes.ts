import { Router } from 'express';
import { requireAuth } from '../../middlewares/auth.js';
import { validateBody, validateParams } from '../../middlewares/validate.js';
import { CartViewModel } from '../../viewmodels/cart.viewmodel.js';
import { CartError } from '../../models/cart.model.js';
import {
  addToCartSchema,
  updateCartItemSchema,
  putCartItemBodySchema,
  variantIdParamSchema,
} from '../../validators/cart.validator.js';

// Gio hang routes
const router = Router();
const vm = new CartViewModel();

function handleCartError(
  error: unknown,
  res: import('express').Response,
  next: import('express').NextFunction
) {
  if (error instanceof CartError) {
    return res.status(error.statusCode).json({ error: error.message });
  }
  return next(error);
}

// Tat ca cac thao tac voi gio hang deu yeu cau dang nhap
router.use(requireAuth);

// GET /api/v1/cart - Xem chi tiet gio hang
router.get('/', async (req, res, next) => {
  try {
    const data = await vm.getCart(req.user!.id);
    return res.json({ data });
  } catch (error) {
    return handleCartError(error, res, next);
  }
});

// POST /api/v1/cart/items - Them san pham vao gio hang (co kiem tra ton kho)
router.post('/items', validateBody(addToCartSchema), async (req, res, next) => {
  try {
    const variantId = (req.body.variantId ?? req.body.variant_id) as string;
    const quantity = Number(req.body.quantity ?? 1);
    const data = await vm.addItem(req.user!.id, variantId, quantity);
    return res.status(201).json({
      message: 'Thêm sản phẩm vào giỏ hàng thành công',
      data,
    });
  } catch (error) {
    return handleCartError(error, res, next);
  }
});

// POST /api/v1/cart - Alias them san pham vao gio hang
router.post('/', validateBody(addToCartSchema), async (req, res, next) => {
  try {
    const variantId = (req.body.variantId ?? req.body.variant_id) as string;
    const quantity = Number(req.body.quantity ?? 1);
    const data = await vm.addItem(req.user!.id, variantId, quantity);
    return res.status(201).json({
      message: 'Thêm sản phẩm vào giỏ hàng thành công',
      data,
    });
  } catch (error) {
    return handleCartError(error, res, next);
  }
});

// PUT /api/v1/cart/items - Cap nhat so luong qua request body { variantId, quantity }
router.put('/items', validateBody(putCartItemBodySchema), async (req, res, next) => {
  try {
    const variantId = (req.body.variantId ?? req.body.variant_id) as string;
    const quantity = Number(req.body.quantity);
    const data = await vm.updateQuantity(req.user!.id, variantId, quantity);
    return res.json({
      message: 'Cập nhật số lượng sản phẩm trong giỏ hàng thành công',
      data,
    });
  } catch (error) {
    return handleCartError(error, res, next);
  }
});

// PUT /api/v1/cart/items/:variantId - Cap nhat so luong qua URL parameter
router.put(
  '/items/:variantId',
  validateParams(variantIdParamSchema),
  validateBody(updateCartItemSchema),
  async (req, res, next) => {
    try {
      const { variantId } = req.params;
      const { quantity } = req.body;
      const data = await vm.updateQuantity(req.user!.id, variantId, quantity);
      return res.json({
        message: 'Cập nhật số lượng sản phẩm trong giỏ hàng thành công',
        data,
      });
    } catch (error) {
      return handleCartError(error, res, next);
    }
  }
);

// PATCH /api/v1/cart/items/:variantId - Alias cap nhat so luong
router.patch(
  '/items/:variantId',
  validateParams(variantIdParamSchema),
  validateBody(updateCartItemSchema),
  async (req, res, next) => {
    try {
      const { variantId } = req.params;
      const { quantity } = req.body;
      const data = await vm.updateQuantity(req.user!.id, variantId, quantity);
      return res.json({
        message: 'Cập nhật số lượng sản phẩm trong giỏ hàng thành công',
        data,
      });
    } catch (error) {
      return handleCartError(error, res, next);
    }
  }
);

// DELETE /api/v1/cart/items/:variantId - Xoa 1 san pham khoi gio hang
router.delete('/items/:variantId', validateParams(variantIdParamSchema), async (req, res, next) => {
  try {
    const { variantId } = req.params;
    const data = await vm.removeItem(req.user!.id, variantId);
    return res.json({
      message: 'Đã xóa sản phẩm khỏi giỏ hàng',
      data,
    });
  } catch (error) {
    return handleCartError(error, res, next);
  }
});

// DELETE /api/v1/cart - Xoa toan bo gio hang (Clear Cart)
router.delete('/', async (req, res, next) => {
  try {
    const result = await vm.clearCart(req.user!.id);
    return res.json(result);
  } catch (error) {
    return handleCartError(error, res, next);
  }
});

export default router;
