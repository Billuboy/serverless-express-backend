import type { Controller, CreateUserBody } from '@ts-types';

import { createUser, getAllUsers, getUserByEmail, getUserById } from '@services/users.service';
import { SuccessResponse, BadRequestException, NotFoundException } from '@utils/responses';
import validateParamId from '@validations/paramId.validations';

export const getUsersController: Controller = async (_req, res, next) => {
  try {
    const users = await getAllUsers();
    return SuccessResponse(res, users);
  } catch (err) {
    return next(err);
  }
};

export const getUserController: Controller<{}, 'userId'> = async (req, res, next) => {
  try {
    const userId = validateParamId(req.params.userId);
    const user = await getUserById(userId);
    if (!user) return NotFoundException(req, res, { error: 'User does not exist.' });
    return SuccessResponse(res, user);
  } catch (err) {
    return next(err);
  }
};

export const createUserController: Controller<CreateUserBody> = async (req, res, next) => {
  try {
    const user = await getUserByEmail(req.body.email);
    if (user) return BadRequestException(req, res, { error: 'User already exists.' });
    await createUser(req.body);
    return SuccessResponse(res, { message: 'User created' });
  } catch (err) {
    return next(err);
  }
};
