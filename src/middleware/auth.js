import { env } from '../config/env.js';

/**
 * Middleware protecting admin routes.
 * Checks header 'x-admin-token' against ADMIN_TOKEN.
 */
export function requireAdmin(req, res, next) {
  const token = req.headers['x-admin-token'];

  if (!env.ADMIN_TOKEN) {
    return res.status(503).json({
      error: 'ADMIN_TOKEN is not configured on the server.'
    });
  }

  if (!token || token !== env.ADMIN_TOKEN) {
    return res.status(403).json({
      error: 'Forbidden: Invalid or missing x-admin-token header.'
    });
  }

  next();
}
