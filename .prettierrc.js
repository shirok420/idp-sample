module.exports = {
  // 行の長さ
  printWidth: 100,
  
  // インデントのスペース数
  tabWidth: 2,
  
  // タブの代わりにスペースを使用
  useTabs: false,
  
  // 文末のセミコロン
  semi: true,
  
  // シングルクォートを使用
  singleQuote: true,
  
  // オブジェクトのプロパティ名のクォート
  quoteProps: 'as-needed',
  
  // JSX内のクォート
  jsxSingleQuote: false,
  
  // 末尾のカンマ
  trailingComma: 'es5',
  
  // オブジェクトの括弧内のスペース
  bracketSpacing: true,
  
  // JSXの閉じタグの位置
  jsxBracketSameLine: false,
  
  // アロー関数の括弧
  arrowParens: 'always',
  
  // ファイル全体をフォーマット
  rangeStart: 0,
  rangeEnd: Infinity,
  
  // Markdownのテキストの折り返し
  proseWrap: 'preserve',
  
  // HTMLの空白の扱い
  htmlWhitespaceSensitivity: 'css',
  
  // VueファイルのスクリプトとスタイルのインデントVueファイルのスクリプトとスタイルのインデント
  vueIndentScriptAndStyle: false,
  
  // 改行コード
  endOfLine: 'lf',
  
  // 埋め込みコードをフォーマット
  embeddedLanguageFormatting: 'auto',
  
  // Markdownの表をきれいに整形
  overrides: [
    {
      files: '*.md',
      options: {
        tabWidth: 2,
      },
    },
    {
      files: '*.json',
      options: {
        tabWidth: 2,
      },
    },
    {
      files: '*.yml',
      options: {
        tabWidth: 2,
      },
    },
  ],
};