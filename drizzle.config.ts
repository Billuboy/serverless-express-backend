import dotenv from 'dotenv';

import type { Config } from 'drizzle-kit';

dotenv.config({
  path: '.env.development',
});

export default {
  schema: './drizzle/schema.ts',
  out: './drizzle/migrations',
  driver: 'pg',
  dbCredentials: { connectionString: process.env.DB_CONN_STRING! },
} satisfies Config;
