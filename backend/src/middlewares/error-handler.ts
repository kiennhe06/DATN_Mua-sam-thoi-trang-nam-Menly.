import type { Request, Response, NextFunction } from 'express';

// Bat loi tap trung, tra ve JSON thong nhat.
export function errorHandler(err: unknown, _req: Request, res: Response, _next: NextFunction) {
  const message = err instanceof Error ? err.message : 'Loi khong xac dinh';
  res.status(500).json({ error: message });
}
