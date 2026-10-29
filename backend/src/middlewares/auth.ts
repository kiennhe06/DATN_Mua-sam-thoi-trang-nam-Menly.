import type { Request, Response, NextFunction } from 'express';

// Xac thuc nguoi dung tu Bearer token (Supabase Auth).
// TODO: verify token that voi Supabase, gan req.user.
export function requireAuth(_req: Request, res: Response, _next: NextFunction) {
  // TODO: kiem tra token va cho di tiep neu hop le
  return res.status(501).json({ message: 'Auth chua duoc cai dat' });
}

// Chi cho nhan vien hoac admin.
export function requireStaffOrAdmin(_req: Request, res: Response, _next: NextFunction) {
  // TODO: kiem tra role staff/admin
  return res.status(501).json({ message: 'Phan quyen chua duoc cai dat' });
}

// Chi cho admin.
export function requireAdmin(_req: Request, res: Response, _next: NextFunction) {
  // TODO: kiem tra role admin
  return res.status(501).json({ message: 'Phan quyen chua duoc cai dat' });
}
