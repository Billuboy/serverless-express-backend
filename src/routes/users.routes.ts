import { Router } from 'express';

import {
  getUserController,
  getUsersController,
  createUserController,
} from '@controllers/users.controller';

import loggerMiddleware from '@middlewares/logger.middleware';

const userRouter = Router();

// @route   GET /users
// @desc    Route for getting all users.
// @access  Public
userRouter.get('/', loggerMiddleware, getUsersController);

// @route   GET /users/:userId
// @desc    Route for getting a particular user.
// @access  Public
userRouter.get('/:userId', loggerMiddleware, getUserController);

// @route   POST /users
// @desc    Route for registring a user.
// @access  Public
userRouter.post('/', loggerMiddleware, createUserController);

export default userRouter;
