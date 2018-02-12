module.exports = {
  env: {
    browser: true,
    commonjs: true,
    es6: true,
    jasmine: true,
    jquery: true
  },
  extends: ['eslint:recommended', 'prettier', 'plugin:jasmine/recommended'],
  plugins: ['prettier', 'jasmine'],
  parserOptions: {
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
    eqeqeq: ['error', 'always'] // adding some custom ESLint rules
  }
};
