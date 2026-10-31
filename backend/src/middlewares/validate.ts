import type { Request, Response, NextFunction } from 'express';
import type { ZodSchema } from 'zod';

export function validateBody<T>(schema: ZodSchema<T>) {
  return (req: Request, res: Response, next: NextFunction) => {
    const parsed = schema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({
        error: 'Dữ liệu gửi lên không hợp lệ',
        details: parsed.error.flatten().fieldErrors,
      });
    }
    req.body = parsed.data;
    return next();
  };
}

export function validateQuery<T>(schema: ZodSchema<T>) {
  return (req: Request, res: Response, next: NextFunction) => {
    const parsed = schema.safeParse(req.query);
    if (!parsed.success) {
      return res.status(400).json({
        error: 'Tham số truy vấn không hợp lệ',
        details: parsed.error.flatten().fieldErrors,
      });
    }
    req.query = parsed.data as unknown as Request['query'];
    return next();
  };
}

export function validateParams<T>(schema: ZodSchema<T>) {
  return (req: Request, res: Response, next: NextFunction) => {
    const parsed = schema.safeParse(req.params);
    if (!parsed.success) {
      return res.status(400).json({
        error: 'Tham số đường dẫn không hợp lệ',
        details: parsed.error.flatten().fieldErrors,
      });
    }
    req.params = parsed.data as unknown as Request['params'];
    return next();
  };
}
