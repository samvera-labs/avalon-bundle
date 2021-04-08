const { environment } = require('@rails/webpacker');

/**
 * Loaders
 */
const eslintLoader = {
  enforce: 'pre',
  test: /\.(js|jsx)$/i,
  use: [
    {
      loader: 'eslint-loader',
      // Set eslint cli options here
      query: {
        fix: true
      }
    }
  ],
  exclude: /node_modules/
};
// Ensure linting happens on pre-transpiled code
environment.loaders.insert('eslint', eslintLoader, { before: 'babel' });

module.exports = environment;
