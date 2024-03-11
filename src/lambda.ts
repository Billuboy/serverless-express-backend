import serverlessExpress from '@codegenie/serverless-express';

import type { APIGatewayEvent, Callback, Context } from 'aws-lambda';

import app from '@init/app';

const binaryMimeTypes: string[] = [
  'application/json',
  'application/octet-stream',
  'multipart/form-data',
  'image/jpeg',
  'image/png',
  'image/svg+xml',
];

// Declaring server instance out of lambda handler to cache it after cold start.
const cachedServerInstance = serverlessExpress({
  app,
  binarySettings: { contentTypes: binaryMimeTypes },
});

// eslint-disable-next-line import/prefer-default-export
export const handler = async (event: APIGatewayEvent, context: Context, callback: Callback) => {
  console.log(event);
  return cachedServerInstance(event, context, callback);
};
