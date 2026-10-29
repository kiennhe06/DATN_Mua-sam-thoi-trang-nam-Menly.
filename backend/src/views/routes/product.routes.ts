import { Router } from 'express';

// San pham routes
const router = Router();

// GET /api/v1/products - danh sach san pham (loc, tim, sap xep)
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/products/:id - chi tiet san pham
router.get('/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
