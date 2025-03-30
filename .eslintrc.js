module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
  env: {
    browser: true,
    node: true,
    es6: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended',
  ],
  rules: {
    // 一般的なルール
    'no-console': ['warn', { allow: ['warn', 'error'] }],
    'no-debugger': 'warn',
    'no-duplicate-imports': 'error',
    'no-unused-vars': 'off', // @typescript-eslint/no-unused-varsを使用
    'prefer-const': 'error',
    'spaced-comment': ['error', 'always', { markers: ['/'] }],

    // TypeScriptルール
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'warn',
    '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    '@typescript-eslint/no-non-null-assertion': 'warn',
    '@typescript-eslint/no-empty-function': 'warn',

    // Prettierとの連携
    'prettier/prettier': ['error', {}, { usePrettierrc: true }],
  },
  overrides: [
    // JSONファイル用の設定
    {
      files: ['*.json'],
      rules: {
        'prettier/prettier': ['error', { parser: 'json' }],
      },
    },
    // Terraformファイル用の設定
    {
      files: ['*.tf'],
      rules: {
        'prettier/prettier': 'off', // Terraformファイルはterraform fmtで整形
      },
    },
  ],
};