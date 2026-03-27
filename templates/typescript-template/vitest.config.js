import { defineConfig } from 'vitest/config';

export default defineConfig({
  server: {
    fs: {
      deny: ['.install', '.jscpd'],
    },
  },
  test: {
    coverage: {
      all: true,
      exclude: [
        '**/*.config.*',
        '**/.install/**',
        '**/.jscpd/**',
        '**/coverage/**',
        '**/dist/**',
        '**/node_modules/**',
        '**/src/**/*.spec.{js,ts}',
        '**/src/**/*.test.{js,ts}',
        '**/src/cli.{js,ts}',
      ],
      include: ['src/**/*.ts'],
      provider: 'v8',
      reporter: ['html', 'json', 'lcov', 'text'],
      reportsDirectory: './coverage',
      skipFull: false,
    },
    environment: 'node',
    exclude: ['**/*.config.*', '**/.install/**', '**/.jscpd/**', '**/coverage/**', '**/dist/**', '**/node_modules/**'],
    globals: true,
  },
});
