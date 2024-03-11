const { resolve } = require('path');

const dotenv = require('dotenv');
const { drizzle } = require('drizzle-orm/postgres-js');
const { migrate } = require('drizzle-orm/postgres-js/migrator');
const postgres = require('postgres');

dotenv.config({ path: resolve('../../', '.env.development') });

const migrationClient = postgres(process.env.DB_CONN_STRING, { max: 1 });

migrate(drizzle(migrationClient), {
  migrationsFolder: './',
  migrationsTable: 'db_migrations',
})
  .then(() => console.log('Migrations applied'))
  .catch((err) => console.error('Migrations failed', err));
