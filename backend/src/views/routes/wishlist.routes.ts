import { Router } from 'express';

// Yeu thich routes
const router = Router();

// GET /api/v1/wishlist - danh sach yeu thich
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/wishlist/:productId - them
router.post('/:productId', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// DELETE /api/v1/wishlist/:productId - xoa
router.delete('/:productId', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/wishlist/check/:productId - kiem tra
router.get('/check/:productId', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
