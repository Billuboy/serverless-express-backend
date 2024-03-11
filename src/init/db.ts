import * as pg from 'postgres';
import { drizzle } from 'drizzle-orm/postgres-js';
import { eq, sql, and, not, isNotNull, isNull, desc } from 'drizzle-orm';

import * as schema from '@drizzle-schema';

const queryClient = pg.default(process.env.DB_CONN_STRING!, { ssl: 'require' });

function dbClient() {
  return drizzle(queryClient, {
    schema,
    logger: process.env.NODE_ENV !== 'production',
  });
}

const db = dbClient();

export { db, eq, sql, and, not, isNotNull, isNull, desc };
