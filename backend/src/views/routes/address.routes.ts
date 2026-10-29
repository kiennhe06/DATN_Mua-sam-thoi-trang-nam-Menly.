import { Router } from 'express';

// So dia chi routes
const router = Router();

// GET /api/v1/addresses - danh sach
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/addresses - them
router.post('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PUT /api/v1/addresses/:id - sua
router.put('/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// DELETE /api/v1/addresses/:id - xoa
router.delete('/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PATCH /api/v1/addresses/:id/default - dat mac dinh
router.patch('/:id/default', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
