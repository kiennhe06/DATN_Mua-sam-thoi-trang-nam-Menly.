import { Router } from 'express';

// Dat hang routes
const router = Router();

// POST /api/v1/orders - tao don (tru kho)
router.post('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/orders - don cua toi
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/orders/track - tra cuu don cho khach vang lai
router.get('/track', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/orders/:id - chi tiet don
router.get('/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PUT /api/v1/orders/:id/cancel - huy don
router.put('/:id/cancel', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
