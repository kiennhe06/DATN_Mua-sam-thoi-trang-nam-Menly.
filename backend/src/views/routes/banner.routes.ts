import { Router } from 'express';
import { BannerViewModel } from '../../viewmodels/banner.viewmodel.js';

// Banner routes
const router = Router();
const vm = new BannerViewModel();

// GET /api/v1/banners - danh sach banner dang bat
router.get('/', async (_req, res) => {
  try {
    const data = await vm.getActiveBanners();
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi khong xac dinh' });
  }
});

export default router;
