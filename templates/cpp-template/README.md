# C++ Bootstrap Template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![C++20](https://img.shields.io/badge/C%2B%2B-20-blue.svg)](https://en.cppreference.com/w/cpp/20)
[![CI](https://github.com/templ-project/cpp/actions/workflows/ci.yml/badge.svg)](https://github.com/templ-project/cpp/actions/workflows/ci.yml)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/templ-project/cpp/issues)

> A modern C++ project template with three build systems (Bazel, CMake, XMake), mise tooling, Jinja2 templates, and comprehensive quality automation.

- [C++ Bootstrap Template](#c-bootstrap-template)
  - [Quick Start](#quick-start)
  - [What's Included](#whats-included)
  - [Common Commands](#common-commands)
    - [Using Mise Tasks (Recommended)](#using-mise-tasks-recommended)
    - [Using Taskfile](#using-taskfile)
  - [Requirements](#requirements)
  - [Setup Development Environment](#setup-development-environment)
  - [Project Structure](#project-structure)
  - [Building](#building)
    - [Build System Selection](#build-system-selection)
    - [Cross-Architecture Builds](#cross-architecture-builds)
  - [Testing](#testing)
  - [Code Quality](#code-quality)
    - [Pre-commit Hooks](#pre-commit-hooks)
  - [Configuration](#configuration)
  - [Using as a Library](#using-as-a-library)
  - [CI/CD Pipeline](#cicd-pipeline)
  - [Known Issues and Limitations](#known-issues-and-limitations)
  - [License](#license)
  - [Support](#support)

## Quick Start

**Bootstrap a new project:**

Using uvx (recommended):

```bash
uvx --from git+https://github.com/templ-project/cpp.git bootstrap ./my-project
cd my-project
mise trust
mise run build
mise run test
```

Or clone manually:

```bash
git clone https://github.com/templ-project/cpp.git my-project
cd my-project
rm -rf .git _uvx_install
mise trust
mise run build
```

That's it! You now have a fully configured C++ project.

## What's Included

| Feature                 | Tool                                                                                              | Description                       |
| ----------------------- | ------------------------------------------------------------------------------------------------- | --------------------------------- |
| **Language**            | C++20                                                                                             | Modern C++ standard               |
| **Compilers**           | [Clang/LLVM 20](https://clang.llvm.org/)                                                          | Also supports g++, MSVC           |
| **Build Systems**       | [CMake](https://cmake.org/), [Bazel 8](https://bazel.build/), [XMake](https://xmake.io/)          | Three options with feature parity |
| **Task Runner**         | [Taskfile](https://taskfile.dev/)                                                                 | Modern build automation           |
| **Tool Management**     | [mise](https://mise.jdx.dev/)                                                                     | Isolated development environment  |
| **Code Formatting**     | [clang-format](https://clang.llvm.org/docs/ClangFormat.html)                                      | Google style, 80-column           |
| **Linting**             | [clang-tidy](https://clang.llvm.org/extra/clang-tidy/)                                            | bugprone, modernize, performance  |
| **Testing**             | [Google Test](https://github.com/google/googletest)                                               | Unit and integration tests        |
| **Coverage**            | [gcovr](https://gcovr.com/) / [lcov](https://github.com/linux-test-project/lcov)                  | HTML coverage reports             |
| **Pre-commit Hooks**    | [Husky](https://typicode.github.io/husky/) + [lint-staged](https://github.com/okonet/lint-staged) | Automatic validation              |
| **Duplicate Detection** | [jscpd](https://github.com/kucherenko/jscpd)                                                      | Copy-paste detector               |
| **Documentation**       | [MkDocs](https://www.mkdocs.org/)                                                                 | Material theme docs               |
| **CI/CD**               | GitHub Actions                                                                                    | Multi-platform, all build systems |

## Common Commands

### Using Mise Tasks (Recommended)

```bash
# === Development ===
mise run build                       # Build with CMake (default)
mise run build --build-system bazel  # Build with Bazel
mise run build --build-system xmake  # Build with XMake
mise run clean                       # Remove all build artifacts

# === Code Formatting ===
mise run format                      # Format all code (clang-format, Prettier)
mise run format --staged             # Format staged files only

# === Linting ===
mise run lint                        # Lint all code (clang-tidy)
mise run lint --fix                  # Lint with auto-fix

# === Testing ===
mise run test                        # Run tests with coverage
mise run test --build-system bazel   # Run tests with Bazel
mise run test --cov-tool gcovr       # Use gcovr for coverage (default)
mise run test --cov-tool lcov        # Use lcov for coverage

# === Code Quality ===
mise run duplicate-check             # Check for duplicate code

# === Full Validation ===
mise run validate                    # Format + lint + test + build (all systems)
```

### Using Taskfile

```bash
# Run via mise for isolated execution
mise exec -- task build                         # Build with CMake
mise exec -- task build CPP_BUILD_SYSTEM=bazel  # Build with Bazel
mise exec -- task test CPP_BUILD_SYSTEM=xmake   # Test with XMake
mise exec -- task lint                          # Lint code
mise exec -- task validate                      # Full CI pipeline
```

## Requirements

- [mise](https://mise.jdx.dev/) - Tool version management (installs everything else)
- [Task](https://taskfile.dev/) - Task runner (optional, can use mise tasks instead)

**Automatically installed via mise:**

- Clang/LLVM 20.1.8 (compiler and tools)
- CMake (latest)
- Bazel 8
- XMake 3.0.3
- Python 3.11+ (for scripts and docs)
- Node.js 22 (for ESLint, Prettier, jscpd)
- UV (Python package manager)

## Setup Development Environment

```bash
# Install mise (if not already installed)
# Linux/macOS:
curl https://mise.run | sh

# Windows (PowerShell):
winget install jdx.mise
# or: choco install mise

# Clone and setup
git clone https://github.com/templ-project/cpp.git my-project
cd my-project

# Trust and install all tools (auto-installs on first run)
mise trust
mise install

# Verify setup
mise run validate
```

## Project Structure

```text
├── .github/
│   ├── actions/
│   │   └── setup-tools/      # Composite action (Task + mise + caching)
│   └── workflows/            # CI/CD pipelines
├── .husky/                   # Git hooks
├── .scripts/                 # Build/lint helper scripts
├── .taskfiles/               # Shared Taskfile modules
├── templates/                # Jinja2 templates for build configs
│   ├── CMakeLists.txt.j2     # CMake configuration
│   ├── BUILD.bazel.j2        # Bazel configuration
│   └── xmake.lua.j2          # XMake configuration
├── src/
│   ├── main.cpp              # Entry point
│   └── greeter.cpp           # Example module
├── include/
│   └── greeter.hpp           # Example header (string_view optimized)
├── tests/
│   ├── unit/
│   │   └── test_greeter.cpp  # Google Test unit tests
│   └── integration/
│       └── test_simple.cpp   # Integration tests
├── build/                    # Build output (gitignored)
├── .mise.toml                # Tool versions and task definitions
├── Taskfile.yml              # Task definitions
├── .clang-format             # Code formatting rules
├── .clang-tidy               # Linting configuration
├── package.json              # Node.js dev dependencies
└── .jscpd.json               # Duplicate detection settings
```

## Building

### Build System Selection

The template supports three build systems with full feature parity:

| Build System | Command                               | Config File      |
| ------------ | ------------------------------------- | ---------------- |
| **CMake**    | `mise run build`                      | `CMakeLists.txt` |
| **Bazel**    | `mise run build --build-system bazel` | `BUILD.bazel`    |
| **XMake**    | `mise run build --build-system xmake` | `xmake.lua`      |

Set default in `.mise.toml`:

```toml
[env]
CPP_BUILD_SYSTEM = "cmake" # or "bazel" or "xmake"
CPP_BUILD_TYPE = "Release" # or "Debug"
CPP_COMPILER = "clang++"
```

### Cross-Architecture Builds

CMake supports cross-compilation on macOS:

```bash
# Build for specific architecture
task build:target TARGET_OS=darwin TARGET_ARCH=x86_64

# Build all targets defined in .build-targets.yml
task build:all
```

| Build System | Native | Cross-Architecture |
| ------------ | ------ | ------------------ |
| **CMake**    | Yes    | Yes (macOS)        |
| **XMake**    | Yes    | Skipped            |
| **Bazel**    | Yes    | Skipped            |

## Testing

Tests use Google Test framework:

```cpp
// tests/unit/test_greeter.cpp
#include <gtest/gtest.h>
#include "greeter.hpp"

TEST(GreeterTest, HelloReturnsGreeting) {
    auto result = cpp_template::Hello("World");
    EXPECT_EQ(result, "Hello, World!");
}

TEST(GreeterTest, HelloThrowsOnEmptyName) {
    EXPECT_THROW(cpp_template::Hello(""), cpp_template::InvalidNameError);
}
```

Run tests:

```bash
mise run test                        # Run with coverage
mise run test --build-system bazel   # Run with Bazel
mise run test --cov-tool lcov        # Use lcov for coverage
```

## Code Quality

### Pre-commit Hooks

Automatic validation via Husky + lint-staged:

| File Type                 | Tools Run                |
| ------------------------- | ------------------------ |
| `*.cpp`, `*.hpp`, `*.h`   | clang-format, clang-tidy |
| `*.json`, `*.yml`, `*.md` | Prettier, ESLint         |
| `*.py`                    | Ruff, Pylint             |
| `*.sh`                    | ShellCheck               |

Run all quality checks:

```bash
mise run validate
```

Configure hooks in:

- `.husky/pre-commit` - Hook script
- `.lintstagedrc.yml` - File patterns and commands

## Configuration

| File             | Purpose                                          |
| ---------------- | ------------------------------------------------ |
| `.mise.toml`     | Tool versions, environment variables, tasks      |
| `Taskfile.yml`   | Task definitions                                 |
| `.clang-format`  | Code formatting (Google style, 80 columns)       |
| `.clang-tidy`    | Linting rules (bugprone, modernize, performance) |
| `templates/*.j2` | Jinja2 templates for build configs               |
| `.jscpd.json`    | Duplicate detection settings                     |

## Using as a Library

```cpp
#include "greeter.hpp"
#include <iostream>

int main() {
    // Use the convenience function
    std::string msg = cpp_template::Hello("World");
    std::cout << msg << '\n';  // "Hello, World!"

    // Or use the Greeter class (static methods)
    std::string msg2 = cpp_template::Greeter::Hello("C++");
    std::cout << msg2 << '\n';  // "Hello, C++!"

    // String trimming with zero-copy string_view
    std::string_view trimmed = cpp_template::Trim("  spaces  ");
    std::cout << trimmed << '\n';  // "spaces"

    return 0;
}
```

## CI/CD Pipeline

The GitHub Actions pipeline runs on **Linux, macOS, and Windows**:

| Workflow         | Trigger                 | Jobs                                |
| ---------------- | ----------------------- | ----------------------------------- |
| `ci.yml`         | Push/PR to main/develop | Matrix orchestrator                 |
| `ci.build.yml`   | Called by ci.yml        | Build with all three build systems  |
| `ci.quality.yml` | Called by ci.yml        | lint, test, duplicate-check         |
| `ci.version.yml` | Push to main            | Semantic version bump               |
| `ci.release.yml` | After version bump      | Create GitHub release with binaries |

## Known Issues and Limitations

| Issue                       | Description                                        | Workaround                                 |
| --------------------------- | -------------------------------------------------- | ------------------------------------------ |
| **macOS Cross-Compilation** | XMake and Bazel can't cross-compile with mise LLVM | Use CMake for cross-compilation            |
| **Bazel Hedron on macOS**   | `refresh_all` fails due to header incompatibility  | Use CMake/XMake for clang-tidy on macOS    |
| **Mise-Only Toolchain**     | No system compilers used                           | Modify `.mise.toml` if system tools needed |

## License

MIT © [Templ Project](https://github.com/templ-project)

## Support

- [Report Issues](https://github.com/templ-project/cpp/issues)
- [Read the Docs](https://github.com/templ-project/cpp#readme)
- [Star on GitHub](https://github.com/templ-project/cpp)
