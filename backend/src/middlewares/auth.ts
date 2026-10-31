import type { Request, Response, NextFunction } from 'express';
import { supabase } from '../config/supabase.js';

declare global {
  namespace Express {
    interface Request {
      user?: { id: string; role: string };
    }
  }
}

async function authenticate(req: Request, res: Response, next: NextFunction, roles?: string[]) {
  const authorization = req.header('authorization');
  const token = authorization?.match(/^Bearer\s+(.+)$/i)?.[1];
  if (!token) return res.status(401).json({ error: 'Vui lòng đăng nhập' });

  try {
    const { data: authData, error: authError } = await supabase.auth.getUser(token);
    if (authError || !authData.user) {
      return res.status(401).json({ error: 'Phiên đăng nhập không hợp lệ hoặc đã hết hạn' });
    }

    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('role, is_active, is_locked')
      .eq('id', authData.user.id)
      .maybeSingle();

    if (profileError) return next(profileError);
    if (!profile || !profile.is_active || profile.is_locked) {
      return res.status(403).json({ error: 'Tài khoản không được phép truy cập' });
    }
    if (roles && !roles.includes(profile.role)) {
      return res.status(403).json({ error: 'Bạn không có quyền thực hiện thao tác này' });
    }

    req.user = { id: authData.user.id, role: profile.role };
    return next();
  } catch (error) {
    return next(error);
  }
}

export function requireAuth(req: Request, res: Response, next: NextFunction) {
  return authenticate(req, res, next);
}

export function requireStaffOrAdmin(req: Request, res: Response, next: NextFunction) {
  return authenticate(req, res, next, ['staff', 'admin']);
}

export function requireAdmin(req: Request, res: Response, next: NextFunction) {
  return authenticate(req, res, next, ['admin']);
}
