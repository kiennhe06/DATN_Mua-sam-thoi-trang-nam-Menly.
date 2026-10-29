import { Router } from 'express';

// Ho so ca nhan routes
const router = Router();

// GET /api/v1/profile - xem ho so
router.get('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PUT /api/v1/profile - sua ho so
router.put('/', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/profile/upload-avatar - doi anh dai dien
router.post('/upload-avatar', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
