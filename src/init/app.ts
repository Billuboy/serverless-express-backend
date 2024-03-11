import express from 'express';
import cors from 'cors';
import helmet from 'helmet';

import type { ErrorMiddleware } from '@ts-types';

import userRouter from '@routes/users.routes';
import catchAllMiddleware from '@middlewares/catchAll.middleware';

const app = express();

app.use(cors({ methods: ['GET', 'HEAD', 'POST'] }));
app.use(helmet());
app.disable('x-powered-by');

app.get('/', async (_req, res) => {
  console.log(`Server is running in ${process.env.API_ENV} environment`);
  return res
    .status(200)
    .json({ message: `Server is running in ${process.env.API_ENV} environment` });
});

app.use('/users', userRouter);
app.use('*', (_req, res) => res.status(404).json({ message: 'Endpoint not found' }));
app.use(catchAllMiddleware as ErrorMiddleware);

export default app;
