import { Router } from 'express';

// Thanh toan VNPay routes
const router = Router();

// POST /api/v1/payments/vnpay/create - tao giao dich
router.post('/vnpay/create', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/payments/vnpay/ipn - nhan ket qua tu VNPay
router.get('/vnpay/ipn', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

// GET /api/v1/payments/vnpay/return - trang tra ve
router.get('/vnpay/return', (_req, res) => {
  // TODO: implement
  res.status(501).json({ message: 'Chua duoc cai dat' });
});

export default router;
