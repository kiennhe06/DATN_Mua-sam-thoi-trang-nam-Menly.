import { Router } from 'express';
import { requireAuth } from '../../middlewares/auth.js';
import { ReviewViewModel } from '../../viewmodels/review.viewmodel.js';

// Danh gia routes
const router = Router();
const vm = new ReviewViewModel();

// GET /api/v1/reviews/product/:productId - danh sach danh gia cua san pham (cong khai)
router.get('/product/:productId', async (req, res) => {
  try {
    const data = await vm.listByProduct(req.params.productId);
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

// POST /api/v1/reviews/:productId - viet danh gia { orderItemId, rating, comment }
router.post('/:productId', requireAuth, async (req, res) => {
  try {
    const { orderItemId, rating, comment } = req.body ?? {};
    const data = await vm.create({
      userId: req.user!.id,
      productId: req.params.productId,
      orderItemId,
      rating: Number(rating),
      comment,
    });
    res.status(201).json({ data });
  } catch (e) {
    res.status(400).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

// DELETE /api/v1/reviews/:reviewId - xoa danh gia cua minh
router.delete('/:reviewId', requireAuth, async (req, res) => {
  try {
    const removed = await vm.remove(req.params.reviewId, req.user!.id);
    if (!removed) return res.status(404).json({ error: 'Khong tim thay danh gia cua ban' });
    res.json({ message: 'Da xoa danh gia' });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

export default router;
