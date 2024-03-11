const { zip } = require('zip-a-folder');

class Zip {
  static async main() {
    await zip('out', 'artifacts/lambda.zip');
  }
}

Zip.main();
