import { Router } from 'express';

// Danh gia routes
const router = Router();

// GET /api/v1/reviews/product/:productId - danh gia cua san pham
router.get('/product/:productId', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/reviews/:productId - viet danh gia
router.post('/:productId', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// DELETE /api/v1/reviews/:reviewId - xoa danh gia cua minh
router.delete('/:reviewId', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
