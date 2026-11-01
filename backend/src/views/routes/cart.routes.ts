import { Router } from 'express';
import { requireAuth } from '../../middlewares/auth.js';
import { CartViewModel } from '../../viewmodels/cart.viewmodel.js';

// Gio hang routes (can dang nhap)
const router = Router();
const vm = new CartViewModel();

// GET /api/v1/cart - xem gio hang
router.get('/', requireAuth, async (req, res) => {
  try {
    const data = await vm.list(req.user!.id);
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

// PUT /api/v1/cart/items - them / cap nhat 1 mon { variantId, quantity }
router.put('/items', requireAuth, async (req, res) => {
  try {
    const { variantId, quantity } = req.body ?? {};
    await vm.setItem(req.user!.id, variantId, Number(quantity));
    res.json({ message: 'Da cap nhat gio hang' });
  } catch (e) {
    res.status(400).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

// DELETE /api/v1/cart/items/:variantId - xoa 1 mon
router.delete('/items/:variantId', requireAuth, async (req, res) => {
  try {
    await vm.removeItem(req.user!.id, req.params.variantId);
    res.json({ message: 'Da xoa khoi gio hang' });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

// DELETE /api/v1/cart - xoa ca gio
router.delete('/', requireAuth, async (req, res) => {
  try {
    await vm.clear(req.user!.id);
    res.json({ message: 'Da xoa gio hang' });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

export default router;
