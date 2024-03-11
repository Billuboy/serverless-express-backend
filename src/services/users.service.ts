import type { CreateUserBody } from '@ts-types';

import { db, eq, sql } from '@init/db';
import { user } from '@drizzle-schema';

export const getUserById = async (id: number) =>
  (
    await db
      .select({
        id: user.id,
        email: user.email,
        fullName: sql`CONCAT(${user.firstName},' ', ${user.lastName})`,
      })
      .from(user)
      .where(eq(user.id, id))
  )[0];

export const getUserByEmail = async (email: string) =>
  (
    await db
      .select({
        id: user.id,
        email: user.email,
        fullName: sql`CONCAT(${user.firstName},' ', ${user.lastName})`,
      })
      .from(user)
      .where(eq(user.email, email))
  )[0];

export const getAllUsers = () =>
  db
    .select({
      id: user.id,
      email: user.email,
      fullName: sql`CONCAT(${user.firstName},' ', ${user.lastName})`,
    })
    .from(user);

export const createUser = (body: CreateUserBody) => db.insert(user).values(body);
