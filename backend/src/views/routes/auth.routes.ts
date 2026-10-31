import { Router } from 'express';
import { requireAuth, optionalAuth } from '../../middlewares/auth.js';
import { validateBody } from '../../middlewares/validate.js';
import {
  AuthError,
  AuthModel,
  LoginCredentialsError,
} from '../../models/auth.model.js';
import {
  registerSchema,
  loginSchema,
  changePasswordSchema,
  forgotPasswordSchema,
  resetPasswordSchema,
  refreshTokenSchema,
} from '../../validators/auth.validator.js';

const router = Router();
const authModel = new AuthModel();

function handleAuthError(error: unknown, res: import('express').Response, next: import('express').NextFunction) {
  if (error instanceof AuthError) {
    return res.status(error.statusCode).json({ error: error.message });
  }
  return next(error);
}

// POST /api/v1/auth/register - Đăng ký tài khoản mới
router.post('/register', validateBody(registerSchema), async (req, res, next) => {
  try {
    const data = await authModel.register(req.body);
    return res.status(201).json({ data });
  } catch (error) {
    return handleAuthError(error, res, next);
  }
});

// POST /api/v1/auth/login - Đăng nhập (trả về JWT access_token & refresh_token)
router.post('/login', validateBody(loginSchema), async (req, res, next) => {
  try {
    const data = await authModel.login(req.body.email, req.body.password);
    return res.json({ data });
  } catch (error) {
    return handleAuthError(error, res, next);
  }
});

// POST /api/v1/auth/change-password - Đổi mật khẩu (yêu cầu đăng nhập)
router.post(
  '/change-password',
  requireAuth,
  validateBody(changePasswordSchema),
  async (req, res, next) => {
    try {
      const user = req.user!;
      if (!user.email) {
        return res.status(400).json({ error: 'Không tìm thấy email của tài khoản' });
      }
      const result = await authModel.changePassword(
        user.id,
        user.email,
        req.body.currentPassword,
        req.body.newPassword
      );
      return res.json(result);
    } catch (error) {
      return handleAuthError(error, res, next);
    }
  }
);

// POST /api/v1/auth/forgot-password - Yêu cầu gửi email đặt lại mật khẩu
router.post(
  '/forgot-password',
  validateBody(forgotPasswordSchema),
  async (req, res, next) => {
    try {
      const result = await authModel.forgotPassword(req.body.email, req.body.redirectTo);
      return res.json(result);
    } catch (error) {
      return handleAuthError(error, res, next);
    }
  }
);

// POST /api/v1/auth/reset-password - Đặt lại mật khẩu bằng OTP hoặc Token
router.post(
  '/reset-password',
  validateBody(resetPasswordSchema),
  async (req, res, next) => {
    try {
      const result = await authModel.resetPassword(req.body);
      return res.json(result);
    } catch (error) {
      return handleAuthError(error, res, next);
    }
  }
);

// POST /api/v1/auth/refresh-token - Cấp lại JWT access token mới
router.post(
  '/refresh-token',
  validateBody(refreshTokenSchema),
  async (req, res, next) => {
    try {
      const data = await authModel.refreshToken(req.body.refreshToken);
      return res.json({ data });
    } catch (error) {
      return handleAuthError(error, res, next);
    }
  }
);

// GET /api/v1/auth/me - Lấy thông tin tài khoản hiện tại
router.get('/me', requireAuth, async (req, res, next) => {
  try {
    const profile = await authModel.getProfile(req.user!.id);
    return res.json({ data: profile });
  } catch (error) {
    return handleAuthError(error, res, next);
  }
});

// GET /api/v1/auth/status - Kiểm tra trạng thái tài khoản
router.get('/status', optionalAuth, async (req, res, next) => {
  try {
    const emailQuery = typeof req.query.email === 'string' ? req.query.email : null;
    const targetIdOrEmail = req.user?.id || emailQuery;

    if (!targetIdOrEmail) {
      return res.status(400).json({ error: 'Vui lòng cung cấp email hoặc đăng nhập để kiểm tra trạng thái' });
    }

    const status = await authModel.checkAccountStatus(targetIdOrEmail);
    return res.json({ data: status });
  } catch (error) {
    return handleAuthError(error, res, next);
  }
});

export default router;
