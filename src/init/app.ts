import express from 'express';
import cors from 'cors';
import helmet from 'helmet';

import type { ErrorMiddleware } from '@ts-types';

import userRouter from '@routes/users.routes';
import loggerMiddleware from '@middlewares/logger.middleware';
import catchAllMiddleware from '@middlewares/catchAll.middleware';

const app = express();

app.use(cors({ methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'] }));
app.use(helmet());
app.disable('x-powered-by');

app.get(`/health`, loggerMiddleware, async (_req, res) => {
  console.log(`Server is running in ${process.env.API_ENV} environment`);
  return res
    .status(200)
    .json({ message: `Server is running in ${process.env.API_ENV} environment` });
});

app.use(`/users`, loggerMiddleware, userRouter);
app.use('*', loggerMiddleware, (_req, res) =>
  res.status(404).json({ message: 'Endpoint not found' }),
);
app.use(catchAllMiddleware as ErrorMiddleware);

export default app;
