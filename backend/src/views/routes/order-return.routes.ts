import { Router } from 'express';

// Tra hang routes
const router = Router();

// POST /api/v1/order-returns - tao yeu cau tra hang
router.post('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/order-returns - danh sach yeu cau cua toi
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PATCH /api/v1/order-returns/:id - admin duyet/tu choi
router.patch('/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
