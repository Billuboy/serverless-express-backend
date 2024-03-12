import { getClientIp } from '@supercharge/request-ip';

import type { Request, Response, NextFunction, Middleware } from '@ts-types';

import logger from '@lib/logger';

const loggerMiddleware = async (
  req: Request<{ password?: string }>,
  _res: Response,
  next: NextFunction,
) => {
  const meta: Record<string, unknown> = {
    request: {
      baseUrl: req.baseUrl,
      originalUrl: req.originalUrl,
      url: req.url,
      method: req.method,
      origin: req.headers.origin,
      ip: getClientIp(req),
    },
  };

  if (req.body) {
    const body = { ...req.body };
    delete (body as { password?: string }).password;
    meta.body = body;
  }

  logger.info({ context: 'HTTPCall', ...meta });
  return next();
};

// eslint-disable-next-line no-unused-vars
export default loggerMiddleware as unknown as Middleware;
