import { Router } from 'express';

// Gio hang routes
const router = Router();

// GET /api/v1/cart - xem gio
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PUT /api/v1/cart/items - them/sua mon
router.put('/items', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// DELETE /api/v1/cart/items/:variantId - xoa 1 mon
router.delete('/items/:variantId', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// DELETE /api/v1/cart - xoa ca gio
router.delete('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
