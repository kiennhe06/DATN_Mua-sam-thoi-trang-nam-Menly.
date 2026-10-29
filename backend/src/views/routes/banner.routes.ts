import { Router } from 'express';

// Banner routes
const router = Router();

// GET /api/v1/banners - danh sach banner dang bat
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
