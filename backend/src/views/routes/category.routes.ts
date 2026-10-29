import { Router } from 'express';

// Danh muc routes
const router = Router();

// GET /api/v1/categories - danh sach danh muc
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
