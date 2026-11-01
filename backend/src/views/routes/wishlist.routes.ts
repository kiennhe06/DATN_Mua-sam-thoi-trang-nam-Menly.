import { Router } from 'express';
import { requireAuth } from '../../middlewares/auth.js';
import { WishlistViewModel } from '../../viewmodels/wishlist.viewmodel.js';

// Yeu thich routes (can dang nhap)
const router = Router();
const vm = new WishlistViewModel();

// GET /api/v1/wishlist - danh sach yeu thich cua toi
router.get('/', requireAuth, async (req, res) => {
  try {
    const data = await vm.list(req.user!.id);
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

// POST /api/v1/wishlist/:productId - them vao yeu thich
router.post('/:productId', requireAuth, async (req, res) => {
  try {
    await vm.add(req.user!.id, req.params.productId);
    res.json({ message: 'Da them vao yeu thich' });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

// DELETE /api/v1/wishlist/:productId - bo yeu thich
router.delete('/:productId', requireAuth, async (req, res) => {
  try {
    await vm.remove(req.user!.id, req.params.productId);
    res.json({ message: 'Da bo yeu thich' });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

// GET /api/v1/wishlist/check/:productId - kiem tra da yeu thich chua
router.get('/check/:productId', requireAuth, async (req, res) => {
  try {
    const liked = await vm.check(req.user!.id, req.params.productId);
    res.json({ data: { liked } });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

export default router;
