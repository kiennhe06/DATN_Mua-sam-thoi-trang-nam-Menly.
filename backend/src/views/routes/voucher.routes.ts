import { Router } from 'express';

// Ma giam gia routes
const router = Router();

// GET /api/v1/vouchers - danh sach ma
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/vouchers/apply - ap ma
router.post('/apply', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
