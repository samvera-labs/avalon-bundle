module.exports = {
  env: {
    browser: true,
    commonjs: true,
    es6: true,
    jasmine: true,
    jquery: true
  },
  extends: [
    'eslint:recommended',
    'prettier',
    'plugin:jasmine/recommended',
    'plugin:react/recommended'
  ],
  plugins: ['prettier', 'jasmine'],
  parserOptions: {
    ecmaVersion: 2017,
    ecmaFeatures: {
      experimentalObjectRestSpread: true,
      jsx: true
    },
    sourceType: 'module'
  },
  rules: {
    'prettier/prettier': [
      // customizing prettier rules (unfortunately not many of them are customizable)
      'error',
      {
        singleQuote: true
      }
    ],
    eqeqeq: ['error', 'always'], // adding some custom ESLint rules
    'no-console': 0
  }
};
