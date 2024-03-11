import dotenv from 'dotenv';

import app from '@init/app';
import logger from '@lib/logger';

dotenv.config({ path: './.env.development' });

const port = process.env.PORT || 8080;
app.listen(port, () => {
  logger.info(`Listening on: http://localhost:${port}`);
});
