import { Router } from 'express';
import { requireAdmin } from '../../middlewares/auth.js';

// Quan tri routes
const router = Router();
router.use(requireAdmin);

// GET /api/v1/admin/products - DS san pham
router.get('/products', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/admin/products - them SP
router.post('/products', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PUT /api/v1/admin/products/:id - sua SP
router.put('/products/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// DELETE /api/v1/admin/products/:id - xoa SP
router.delete('/products/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PATCH /api/v1/admin/products/:id/approve - duyet SP
router.patch('/products/:id/approve', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/admin/orders - DS don
router.get('/orders', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PUT /api/v1/admin/orders/:id/status - doi trang thai don
router.put('/orders/:id/status', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/admin/inventory/adjust - dieu chinh kho
router.post('/inventory/adjust', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/admin/inventory/movements - lich su kho
router.get('/inventory/movements', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/admin/users - DS nguoi dung
router.get('/users', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/admin/users - them
router.post('/users', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PUT /api/v1/admin/users/:id - sua
router.put('/users/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// DELETE /api/v1/admin/users/:id - xoa
router.delete('/users/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PATCH /api/v1/admin/users/:id/lock - khoa/mo
router.patch('/users/:id/lock', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/admin/stats - thong ke tong quan
router.get('/stats', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/admin/audit-log - nhat ky
router.get('/audit-log', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/admin/notifications - gui thong bao
router.post('/notifications', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/admin/banners - them banner
router.post('/banners', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PUT /api/v1/admin/banners/:id - sua banner
router.put('/banners/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// DELETE /api/v1/admin/banners/:id - xoa banner
router.delete('/banners/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/admin/returns - DS tra hang
router.get('/returns', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// PATCH /api/v1/admin/returns/:id - duyet tra hang
router.patch('/returns/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/admin/reviews - DS danh gia
router.get('/reviews', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// DELETE /api/v1/admin/reviews/:id - xoa danh gia
router.delete('/reviews/:id', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// POST /api/v1/admin/reviews/:id/reply - tra loi danh gia
router.post('/reviews/:id/reply', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
