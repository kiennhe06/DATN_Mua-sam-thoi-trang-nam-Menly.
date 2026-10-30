import { Router } from 'express';
import { ProductViewModel } from '../../viewmodels/product.viewmodel.js';

// San pham routes
const router = Router();
const vm = new ProductViewModel();

// GET /api/v1/products - danh sach san pham (loc, tim, sap xep)
router.get('/', async (req, res) => {
  try {
    const { search, categoryId, limit } = req.query;
    const data = await vm.getProducts({
      search: search as string | undefined,
      categoryId: categoryId as string | undefined,
      limit: limit ? Number(limit) : undefined,
    });
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error: e instanceof Error ? e.message : 'Loi khong xac dinh' });
  }
});

// GET /api/v1/products/:id - chi tiet san pham
router.get('/:id', async (req, res) => {
  try {
    const data = await vm.getProductById(req.params.id);
    res.json({ data });
  } catch {
    res.status(404).json({ error: 'Khong tim thay san pham' });
  }
});

export default router;
