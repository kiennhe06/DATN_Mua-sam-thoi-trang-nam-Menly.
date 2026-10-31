import { Router } from 'express';
import { z } from 'zod';
import { AuthModel, LoginCredentialsError } from '../../models/auth.model.js';

// Tai khoan routes
const router = Router();
const authModel = new AuthModel();
const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

// POST /api/v1/auth/register - dang ky
router.post('/register', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/auth/login - dang nhap quan tri
router.post('/login', async (req, res, next) => {
  const parsed = loginSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({
      error: 'Email hoặc mật khẩu không hợp lệ',
      details: parsed.error.flatten().fieldErrors,
    });
  }

  try {
    const data = await authModel.login(parsed.data.email, parsed.data.password);
    return res.json({ data });
  } catch (error) {
    if (error instanceof LoginCredentialsError) {
      return res.status(401).json({ error: error.message });
    }
    return next(error);
  }
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
