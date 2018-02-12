// config/webpack/test.js
const environment = require('./environment')
environment.plugins.get('Manifest').opts.writeToFileEmit = process.env.NODE_ENV !== 'test'
environment.loaders.set('istanbul-instrumenter', {
  test: /\.ts$/,
  enforce: "post",
  loader: "istanbul-instrumenter-loader",
  query: {
    esModules: true
  },
  exclude: ["node_modules", /\.test\.ts$/]
}) /* optional */
module.exports = environment.toWebpackConfig()
