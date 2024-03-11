/* eslint-disable no-unused-vars */
import type {
  Request as ExpressRequest,
  Response as ExpressResponse,
  NextFunction as ExpressNextFunction,
  ErrorRequestHandler,
} from 'express';

export type Response = ExpressResponse;

export type NextFunction = ExpressNextFunction;

export type ErrorHandler = ErrorRequestHandler;

export type RequestUser = {
  id: number;
  email: string;
};

type Params<T extends string> = {
  [key in T]: string;
};

export type JSONData<K extends string = string, V = any> = {
  [key in K]: V;
};

export interface Request<
  RBody extends JSONData = {},
  RParams extends string = string,
  RUser extends RequestUser | undefined = RequestUser,
  RQueries extends JSONData = {},
> extends ExpressRequest<Params<RParams>, ExpressResponse, RBody, Partial<RQueries>> {
  user?: RUser;
}

export type ExpressController = (req: ExpressRequest, res: Response) => Promise<Response>;

export type Middleware = (
  req: ExpressRequest,
  res: Response,
  next: NextFunction,
) => Promise<Response>;

export type Controller<
  RBody extends JSONData = {},
  RParams extends string = string,
  RUser extends RequestUser | undefined = undefined,
  RQueries extends JSONData = {},
> = (
  req: Request<RBody, RParams, RUser, RQueries>,
  res: Response,
  next: NextFunction,
) => Promise<Response | void>;

export type ErrorMiddleware = (
  err: ErrorHandler,
  req: ExpressRequest,
  res: Response,
  next: NextFunction,
) => Promise<Response>;

export type ValidationErrors<T extends string> = {
  [key in T]?: string;
};

export type Keyof<T extends JSONData> = Extract<keyof T, string>;

export type ValidationBody<T extends JSONData> = JSONData<Keyof<T>, string>;
