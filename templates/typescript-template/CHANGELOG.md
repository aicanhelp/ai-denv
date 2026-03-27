# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.3.1 (2026-01-03)

### Bug Fixes

* updated readme ([d13978f](https://github.com/templ-project/typescript/commit/d13978f4bdba9cdd1b375f2b99ba8c3cf05d1154))

## 1.3.0 (2025-12-30)

### Features

* **typescript:** refactor Taskfile into modular includes structure ([2da4d66](https://github.com/templ-project/typescript/commit/2da4d66197ad2bff732194dce2c2044b305f2510))

## 1.2.0 (2025-12-21)

### Features

* sync Python/PowerShell/Shell tooling from generic template ([baa8e07](https://github.com/templ-project/typescript/commit/baa8e07ad20e61eafcdc11340cd71fd263bfe459))

## 1.1.1 (2025-12-20)

### Bug Fixes

* sort all config files alphabetically for consistency and maintainability ([a473251](https://github.com/templ-project/typescript/commit/a473251a8b7cd96e1fc31554eca88f8ecbd2d624))

## 1.1.0 (2025-12-19)

### Features

- align workflows with generic template, fix npx bootstrap installer ([8e2c30e](https://github.com/templ-project/typescript/commit/8e2c30ee78cf5b24864ef59f86f4cea6e37dd88c))

## 1.0.1 (2025-11-23)

### Bug Fixes

- sync from javascript template ([73ee0fb](https://github.com/templ-project/typescript/commit/73ee0fb4396d0f7c8061ee830b0fd0e4e1d2e6d8))

## [1.0.0] - 2025-09-08

### Added

- Initial JavaScript Bootstrap Template project
- ESM module support with Node.js 18+
- Comprehensive testing setup with Vitest
- Code quality tools (ESLint, Prettier)
- Copy/paste detection with JSCPD
- License compliance checking
- Git hooks with Husky and lint-staged
- Multi-target build system (ESM, CommonJS, IIFE, Browser) with esbuild
- Import maps example for native browser ESM support
- TDD examples with `hello('World')` function
- Complete documentation and API reference
- GitHub Actions CI/CD workflow
- JSDoc documentation standards

### Features

- `@templ-project/eslint` integration
- `@templ-project/prettier` integration
- `@templ-project/vitest` integration
- Modern JavaScript (ES2022) support
- Comprehensive test coverage
- Pre-commit validation hooks
- Build automation
- Clean code practices demonstration

### Configuration

- ESLint configuration following Google JavaScript Style Guide
- Prettier formatting with consistent style
- Vitest testing with coverage reporting
- JSCPD duplicate code detection
- esbuild bundling for multiple distribution formats
- Package.json with comprehensive scripts

### Documentation

- Complete README with quick start guide
- API documentation with JSDoc
- Contributing guidelines
- Troubleshooting section
- License information (MIT)

[1.0.0]: https://github.com/templ-project/javascript/releases/tag/v1.0.0
