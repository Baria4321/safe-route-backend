import rateLimit from 'express-rate-limit';

// Global API rate limiter: 60 requests per minute per IP
export const globalLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 60,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    error: 'Too many requests from this IP, please try again after a minute.'
  }
});

// Tighter rate limiter for community reports submission: 10 per hour per IP
export const reportsLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 10,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    error: 'Report submission rate limit reached. Please wait before submitting more reports.'
  }
});
