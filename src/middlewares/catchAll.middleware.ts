/* eslint-disable no-console */
import { DrizzleError } from 'drizzle-orm';

import type { ErrorHandler, ErrorMiddleware, NextFunction, Request, Response } from '@ts-types';

import logger from '@lib/logger';
import { InternalServerException } from '@utils/responses';

const errorHandler = (err: ErrorHandler, req: Request, res: Response, _next: NextFunction) => {
  if (err instanceof DrizzleError) logger.error({ name: err.name, message: err.message });

  console.error(err);
  return InternalServerException(req, res, 'Internal Server Exception');
};

export default errorHandler as unknown as ErrorMiddleware;
