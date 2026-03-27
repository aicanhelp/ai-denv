# TypeScript Bootstrap Template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js CI](https://github.com/templ-project/typescript/actions/workflows/ci.yml/badge.svg)](https://github.com/templ-project/typescript/actions/workflows/ci.yml)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/templ-project/typescript/issues)

> A modern TypeScript project template with ESM, testing, linting, and quality tools built-in.

- [TypeScript Bootstrap Template](#typescript-bootstrap-template)
  - [Quick Start](#quick-start)
    - [Bootstrap Options](#bootstrap-options)
  - [What's Included](#whats-included)
  - [Common Commands](#common-commands)
    - [Using npm](#using-npm)
    - [Using Taskfile (Recommended)](#using-taskfile-recommended)
  - [Requirements](#requirements)
  - [Setup Development Environment](#setup-development-environment)
  - [Project Structure](#project-structure)
  - [Building](#building)
  - [Testing](#testing)
  - [Code Quality](#code-quality)
    - [Pre-commit Hooks](#pre-commit-hooks)
  - [Configuration](#configuration)
  - [Using as a Library](#using-as-a-library)
  - [CI/CD Pipeline](#cicd-pipeline)
  - [License](#license)
  - [Support](#support)

## Quick Start

**Bootstrap a new project:**

```bash
npx --yes --package=github:templ-project/typescript bootstrap ./my-project
cd my-project
npm install
npm test
```

That's it! You now have a fully configured TypeScript project.

### Bootstrap Options

```bash
# Bootstrap with only ESM and CJS builds (no browser builds)
npx --yes --package=github:templ-project/typescript bootstrap --target esm,cjs ./my-project

# Bootstrap as part of a monorepo (removes .husky, .github)
npx --yes --package=github:templ-project/typescript bootstrap --part-of-monorepo ./packages/my-lib

# Show all available options
npx --yes --package=github:templ-project/typescript bootstrap --help
```

See [.npx-install/README.md](.npx-install/README.md) for detailed bootstrap documentation.

## What's Included

| Feature                 | Tool                                                                                              | Description                        |
| ----------------------- | ------------------------------------------------------------------------------------------------- | ---------------------------------- |
| **Language**            | [TypeScript 5.9](https://www.typescriptlang.org/)                                                 | Type-safe JavaScript               |
| **Runtime**             | [Node.js 22+](https://nodejs.org/)                                                                | Modern JavaScript runtime          |
| **Execution**           | [tsx](https://github.com/privatenumber/tsx)                                                       | TypeScript execution without build |
| **Module System**       | ESM                                                                                               | Native ES Modules                  |
| **Build System**        | [tsc](https://www.typescriptlang.org/) + [esbuild](https://esbuild.github.io/)                    | Type-check + fast bundling         |
| **Test Framework**      | [Vitest](https://vitest.dev/)                                                                     | Fast unit testing with V8 coverage |
| **Linting**             | [ESLint](https://eslint.org/)                                                                     | Code quality with TypeScript rules |
| **Formatting**          | [Prettier](https://prettier.io/)                                                                  | Consistent code formatting         |
| **Documentation**       | [TypeDoc](https://typedoc.org/)                                                                   | API docs from TypeScript           |
| **Task Runner**         | [Taskfile](https://taskfile.dev/)                                                                 | Modern build automation            |
| **Tool Management**     | [mise](https://mise.jdx.dev/)                                                                     | Isolated development environment   |
| **Pre-commit Hooks**    | [Husky](https://typicode.github.io/husky/) + [lint-staged](https://github.com/okonet/lint-staged) | Automatic validation               |
| **Duplicate Detection** | [jscpd](https://github.com/kucherenko/jscpd)                                                      | Copy-paste detector                |
| **CI/CD**               | GitHub Actions                                                                                    | Multi-platform testing & releases  |

## Common Commands

### Using npm

```bash
npm start              # Run the app (via tsx)
npm test               # Run tests
npm run test:coverage  # Run tests with coverage
npm run lint           # Lint and auto-fix
npm run format         # Format code with Prettier
npm run build          # Build for production
npm run docs           # Generate TypeDoc documentation
npm run validate       # Run all quality checks
```

### Using Taskfile (Recommended)

```bash
# === Development ===
task run                 # Run the application (via tsx)
task build               # Build for production
task build:all           # Build all formats (ESM, CJS, IIFE, Browser)

# === Code Formatting ===
task format              # Format all code (Prettier)
task format:check        # Check formatting without fixing

# === Linting ===
task lint                # Lint all code (ESLint + TypeScript)
task lint:check          # Check all without fixing

# === Testing ===
task test                # Run all tests
task test:coverage       # Run tests with coverage report

# === Code Quality ===
task duplicate-check     # Check for duplicate code

# === Documentation ===
task docs                # Build TypeDoc documentation
task docs:serve          # Serve documentation locally

# === Full Validation ===
task validate            # Run complete CI pipeline locally

# === Dependencies ===
task deps:sync           # Install all dependencies (mise, npm)
task deps:refresh        # Update all dependencies
task deps:clean          # Remove all dependencies
```

## Requirements

- [mise](https://mise.jdx.dev/) - Tool version management (installs everything else)
- [Task](https://taskfile.dev/) - Task runner (can be installed via mise or standalone)

**Automatically installed via mise:**

- Node.js 22+
- Python 3.11+ (for helper scripts)
- ShellCheck (shell script linting)
- PowerShell Core (cross-platform PowerShell)

## Setup Development Environment

```bash
# Install mise (if not already installed)
# Linux/macOS:
curl https://mise.run | sh

# Windows (PowerShell):
winget install jdx.mise
# or: choco install mise

# Install Task runner
# https://taskfile.dev/installation/

# Clone and setup
git clone https://github.com/templ-project/typescript.git my-project
cd my-project

# Install all dependencies
task deps:sync

# Verify setup
task validate
```

## Project Structure

```text
├── .github/
│   └── workflows/        # CI/CD pipelines
├── .husky/               # Git hooks
├── .scripts/             # Build/lint helper scripts
├── .taskfiles/           # Shared Taskfile modules
├── src/
│   ├── index.ts          # Main entry point
│   └── lib/
│       ├── greeter.ts    # Example module with TypeScript types
│       └── greeter.spec.ts # Unit tests (co-located)
├── dist/                 # Build output (gitignored)
├── docs/                 # Generated documentation
├── Taskfile.yml          # Task definitions
├── .mise.toml            # Tool versions & hooks
├── package.json          # Node.js dependencies
├── tsconfig.json         # TypeScript configuration
├── vitest.config.ts      # Test configuration
├── eslint.config.mjs     # ESLint configuration
├── prettier.config.mjs   # Prettier configuration
└── typedoc.json          # TypeDoc configuration
```

## Building

The template uses a two-step build process:

1. **tsc** - Type-checks and emits declaration files (`.d.ts`)
2. **esbuild** - Bundles for multiple targets

```bash
task build
# or: npm run build
```

Outputs:

- `dist/esm/` - ES Modules (for Node.js and modern bundlers)
- `dist/cjs/` - CommonJS (for older Node.js)
- `dist/iife/` - Browser bundle (for direct `<script>` usage)
- `dist/browser/` - Optimized browser ESM
- `dist/types/` - TypeScript declaration files

## Testing

Tests are co-located with source files using the `.spec.ts` suffix:

```typescript
// src/lib/greeter.spec.ts
import { describe, it, expect } from "vitest";
import { hello } from "./greeter";

describe("hello", () => {
  it("returns greeting", () => {
    expect(hello("World")).toBe("Hello, World!");
  });
});
```

Run tests:

```bash
task test                # Run all tests
task test:coverage       # Run with coverage report
```

## Code Quality

### Pre-commit Hooks

Every commit is validated with:

- Code formatting (Prettier)
- Linting (ESLint)
- Type checking (TypeScript)
- Unit tests (Vitest)

CI runs additional checks:

- Test coverage
- Duplicate code detection
- License compliance

Configure hooks in:

- `.husky/pre-commit` - Hook script
- `.lintstagedrc.yml` - File patterns and commands

## Configuration

All configuration uses shared packages for consistency:

| File                  | Purpose                                               |
| --------------------- | ----------------------------------------------------- |
| `.mise.toml`          | Tool versions (Node, Python, ShellCheck)              |
| `Taskfile.yml`        | Task definitions                                      |
| `tsconfig.json`       | TypeScript config (extends `@templ-project/tsconfig`) |
| `eslint.config.mjs`   | ESLint config (uses `@templ-project/eslint`)          |
| `prettier.config.mjs` | Prettier config (uses `@templ-project/prettier`)      |
| `vitest.config.ts`    | Vitest test configuration                             |
| `typedoc.json`        | TypeDoc documentation settings                        |
| `.jscpd.json`         | Duplicate detection settings                          |
| `.licensee.json`      | License compliance settings                           |

## Using as a Library

```typescript
// ES Modules (recommended)
import { hello, Greeter } from "@templ-project/typescript-template";

const greeting = hello("World");
console.log(greeting); // "Hello, World!"
```

```javascript
// CommonJS
const { hello } = require("@templ-project/typescript-template");
```

```html
<!-- Browser (after npm run build) -->
<script src="./dist/iife/your-lib.min.js"></script>
<script>
  console.log(YourLib.hello("World"));
</script>
```

## CI/CD Pipeline

The GitHub Actions pipeline runs on **Linux, macOS, and Windows**:

| Workflow         | Trigger                 | Jobs                               |
| ---------------- | ----------------------- | ---------------------------------- |
| `ci.yml`         | Push/PR to main/develop | Matrix orchestrator                |
| `ci.quality.yml` | Called by ci.yml        | lint, test, build, duplicate-check |
| `ci.version.yml` | Push to main            | Semantic version bump              |
| `ci.release.yml` | After version bump      | Create GitHub release              |

## License

MIT © [Templ Project](https://github.com/templ-project)

## Support

- [Report Issues](https://github.com/templ-project/typescript/issues)
- [Read the Docs](https://github.com/templ-project/typescript#readme)
- [Star on GitHub](https://github.com/templ-project/typescript)
