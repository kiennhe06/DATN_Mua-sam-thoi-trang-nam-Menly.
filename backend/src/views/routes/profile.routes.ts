import { Router } from 'express';
import { requireAuth } from '../../middlewares/auth.js';
import { validateBody } from '../../middlewares/validate.js';
import { uploadAvatarMiddleware } from '../../middlewares/upload.js';
import { ProfileViewModel } from '../../viewmodels/profile.viewmodel.js';
import { updateProfileSchema } from '../../validators/profile.validator.js';
import { ProfileError } from '../../models/profile.model.js';

// Ho so ca nhan routes (can dang nhap)
const router = Router();
const vm = new ProfileViewModel();

function handleProfileError(
  error: unknown,
  res: import('express').Response,
  next: import('express').NextFunction
) {
  if (error instanceof ProfileError) {
    return res.status(error.statusCode).json({ error: error.message });
  }
  return next(error);
}

// Tat ca cac route lien quan den profile ca nhan deu bat buoc dang nhap
router.use(requireAuth);

// GET /api/v1/profile - Xem ho so ca nhan
router.get('/', async (req, res, next) => {
  try {
    const data = await vm.getProfile(req.user!.id);
    return res.json({ data });
  } catch (error) {
    return handleProfileError(error, res, next);
  }
});

// PUT /api/v1/profile - Sua ho so ca nhan
router.put('/', validateBody(updateProfileSchema), async (req, res, next) => {
  try {
    const data = await vm.updateProfile(req.user!.id, req.body);
    return res.json({
      message: 'Cập nhật thông tin hồ sơ thành công',
      data,
    });
  } catch (error) {
    return handleProfileError(error, res, next);
  }
});

// POST /api/v1/profile/upload-avatar - Tải ảnh đại diện lên Supabase Storage qua Multer hoac cap nhat qua URL
router.post('/upload-avatar', uploadAvatarMiddleware('avatar'), async (req, res, next) => {
  try {
    if (req.file) {
      const result = await vm.uploadAvatar(req.user!.id, req.file);
      return res.json({
        message: 'Cập nhật ảnh đại diện thành công',
        data: result,
      });
    }

    const { avatarUrl } = (req.body as { avatarUrl?: string }) ?? {};
    if (avatarUrl) {
      const data = await vm.updateAvatar(req.user!.id, avatarUrl);
      return res.json({
        message: 'Cập nhật ảnh đại diện thành công',
        data,
      });
    }

    return res.status(400).json({ error: 'Vui lòng chọn file ảnh hoặc cung cấp avatarUrl' });
  } catch (error) {
    return handleProfileError(error, res, next);
  }
});

export default router;
