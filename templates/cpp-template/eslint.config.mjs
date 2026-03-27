import templEslintConfig from '@templ-project/eslint';

export default [
  {
    ignores: [
      // Build artifacts and dependencies
      '.venv/**',
      'build/**',
      'bazel-*/**',
      'coverage/**',
      'dist/**',
      'docs-html/**',
      'external/**',
      'node_modules/**',
      // Generated build system files (from templates/)
      '.bazelrc',
      '.jscpd/**',
      'BUILD.bazel',
      'CMakeLists.txt',
      'MODULE.bazel',
      'src/CMakeLists.txt',
      'tests/BUILD.bazel',
      'WORKSPACE',
      'xmake.lua',
      // Config files
      '**/*.config.cjs',
      '**/*.config.js',
      '**/*.config.mjs',
      // Other ignores
      '.eslintignore',
      '.gitignore',
      '.prettierignore',
      'jsconfig.json',
      'LICENSE',
      'package-lock.json',
      'package.json',
      'tsconfig.json',
    ],
  },
  ...templEslintConfig,
];
