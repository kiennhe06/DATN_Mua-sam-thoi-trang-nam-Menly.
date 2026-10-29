import { Router } from 'express';

// Thong bao routes
const router = Router();

// GET /api/v1/notifications - danh sach
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PATCH /api/v1/notifications/:id/read - danh dau da doc
router.patch('/:id/read', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PATCH /api/v1/notifications/read-all - doc tat ca
router.patch('/read-all', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// DELETE /api/v1/notifications/:id - xoa
router.delete('/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
