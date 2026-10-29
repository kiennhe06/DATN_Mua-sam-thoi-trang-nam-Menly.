import { Router } from 'express';

// Tai khoan routes
const router = Router();

// POST /api/v1/auth/register - dang ky
router.post('/register', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/auth/login - dang nhap
router.post('/login', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/auth/forgot-password - quen mat khau
router.post('/forgot-password', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/auth/change-password - doi mat khau
router.post('/change-password', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/auth/status - trang thai khoa tai khoan
router.get('/status', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
