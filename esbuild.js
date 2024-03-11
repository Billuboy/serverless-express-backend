/* eslint-disable import/no-self-import */
require('esbuild').build({
  entryPoints: ['src/lambda.ts'],
  bundle: true,
  minify: true,
  target: 'node18',
  platform: 'node',
  external: ['aws-sdk'],
  outdir: 'out',
});
