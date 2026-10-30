import { Router } from 'express';
import { CategoryViewModel } from '../../viewmodels/category.viewmodel.js';

// Danh muc routes
const router = Router();
const vm = new CategoryViewModel();

// GET /api/v1/categories - danh sach danh muc
router.get('/', async (_req, res) => {
  try {
    const data = await vm.getCategories();
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi khong xac dinh' });
  }
});

export default router;
