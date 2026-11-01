import { Router } from 'express';
import { requireAuth } from '../../middlewares/auth.js';
import { ProfileViewModel } from '../../viewmodels/profile.viewmodel.js';

// Ho so ca nhan routes (can dang nhap)
const router = Router();
const vm = new ProfileViewModel();

// GET /api/v1/profile - xem ho so cua minh
router.get('/', requireAuth, async (req, res) => {
  try {
    const data = await vm.get(req.user!.id);
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

// PUT /api/v1/profile - sua ho so { fullName, phone }
router.put('/', requireAuth, async (req, res) => {
  try {
    const { fullName, phone } = req.body ?? {};
    const data = await vm.update(req.user!.id, { fullName, phone });
    res.json({ data });
  } catch (e) {
    res.status(400).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

// POST /api/v1/profile/upload-avatar - cap nhat anh dai dien { avatarUrl }
router.post('/upload-avatar', requireAuth, async (req, res) => {
  try {
    const { avatarUrl } = req.body ?? {};
    const data = await vm.updateAvatar(req.user!.id, avatarUrl);
    res.json({ data });
  } catch (e) {
    res.status(400).json({ error: e instanceof Error ? e.message : 'Loi' });
  }
});

export default router;
