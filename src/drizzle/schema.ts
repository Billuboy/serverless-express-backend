import { pgTable, pgEnum, varchar, serial } from 'drizzle-orm/pg-core';

export const userRoleEnum = pgEnum('user_role_enum', ['user', 'admin']);

export const user = pgTable('users', {
  id: serial('id').primaryKey(),
  role: userRoleEnum('type').default('user'),
  email: varchar('email').unique().notNull(),
  firstName: varchar('first_name').notNull(),
  lastName: varchar('last_name'),
});
