module.exports = {
  env: {
    browser: true,
    commonjs: true,
    es6: true,
    jquery: true
  },
  extends: ["eslint:recommended", "prettier"], // extending recommended config and config derived from eslint-config-prettier
  plugins: ["prettier"], // activating eslint-plugin-prettier
  parserOptions: {
    ecmaFeatures: {
      experimentalObjectRestSpread: true,
      jsx: true
    },
    sourceType: "module"
  },
  rules: {
    'prettier/prettier': [ // customizing prettier rules (unfortunately not many of them are customizable)
      'error',
      {
        singleQuote: true
      },
    ],
    eqeqeq: ['error', 'always'], // adding some custom ESLint rules
  }
};
