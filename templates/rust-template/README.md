# Rust Bootstrap Template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Rust CI](https://github.com/templ-project/rust/actions/workflows/ci.yml/badge.svg)](https://github.com/templ-project/rust/actions)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/templ-project/rust/issues)

> A modern Rust project template with testing, linting, formatting, and quality tools built-in.

- [Rust Bootstrap Template](#rust-bootstrap-template)
  - [Quick Start](#quick-start)
  - [What's Included](#whats-included)
  - [Common Commands](#common-commands)
    - [Using Taskfile (Recommended)](#using-taskfile-recommended)
    - [Using Cargo Directly](#using-cargo-directly)
  - [Requirements](#requirements)
    - [System Dependencies (for coverage tools)](#system-dependencies-for-coverage-tools)
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

Using uvx (recommended):

```bash
uvx --from git+https://github.com/templ-project/rust.git bootstrap my-project
cd my-project
task deps:sync
task test
```

Or clone manually:

```bash
git clone https://github.com/templ-project/rust.git my-project
cd my-project
rm -rf .git _uvx_install
task deps:sync
task build
```

That's it! You now have a fully configured Rust project.

## What's Included

| Feature                 | Tool                                                                                                          | Description                         |
| ----------------------- | ------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| **Language**            | [Rust](https://www.rust-lang.org/) (latest stable)                                                            | Systems programming language        |
| **Build System**        | [Cargo](https://doc.rust-lang.org/cargo/)                                                                     | Rust package manager and builder    |
| **Task Runner**         | [Taskfile](https://taskfile.dev/)                                                                             | Modern build automation             |
| **Tool Management**     | [mise](https://mise.jdx.dev/)                                                                                 | Isolated development environment    |
| **Code Formatting**     | [rustfmt](https://github.com/rust-lang/rustfmt)                                                               | Official Rust formatter             |
| **Linting**             | [Clippy](https://github.com/rust-lang/rust-clippy)                                                            | Advanced linting for idiomatic Rust |
| **Testing**             | `cargo test`                                                                                                  | Built-in test framework             |
| **Coverage**            | [cargo-tarpaulin](https://github.com/xd009642/tarpaulin)                                                      | Code coverage reports               |
| **Security**            | [cargo-audit](https://github.com/RustSec/rustsec) + [cargo-deny](https://github.com/EmbarkStudios/cargo-deny) | Vulnerability scanning              |
| **Pre-commit Hooks**    | [Husky](https://typicode.github.io/husky/) + [lint-staged](https://github.com/okonet/lint-staged)             | Automatic validation                |
| **Duplicate Detection** | [jscpd](https://github.com/kucherenko/jscpd)                                                                  | Copy-paste detector                 |
| **Documentation**       | `cargo doc`                                                                                                   | API documentation generation        |
| **CI/CD**               | GitHub Actions                                                                                                | Multi-platform testing & releases   |

## Common Commands

### Using Taskfile (Recommended)

```bash
# === Development ===
task run                 # Run the application
task build               # Build in release mode
task build:debug         # Build in debug mode
task clean               # Clean build artifacts

# === Code Formatting ===
task format              # Format all code (rustfmt, Prettier)
task format:check        # Check formatting without fixing

# === Linting ===
task lint                # Run clippy and auto-fix
task lint:check          # Check all without fixing

# === Testing ===
task test                # Run all tests
task test:unit           # Run unit tests only
task test:integration    # Run integration tests only
task test:coverage       # Run tests with coverage report

# === Code Quality ===
task duplicate-check     # Check for duplicate code

# === Documentation ===
task docs                # Generate and open documentation

# === Full Validation ===
task validate            # Run complete CI pipeline locally

# === Dependencies ===
task deps:sync           # Install all dependencies (mise, npm, cargo)
task deps:refresh        # Update all dependencies
task deps:clean          # Remove all dependencies
```

### Using Cargo Directly

```bash
cargo build              # Build in debug mode
cargo build --release    # Build in release mode
cargo test               # Run tests
cargo clippy             # Lint code
cargo fmt                # Format code
cargo doc --open         # Generate and open docs
cargo run                # Run the application
```

## Requirements

- [mise](https://mise.jdx.dev/) - Tool version management (installs everything else)
- [Task](https://taskfile.dev/) - Task runner (can be installed via mise or standalone)

**Automatically installed via mise:**

- Rust (latest stable)
- Node.js 22 (for ESLint, Prettier, jscpd)
- Python 3.11+ (for helper scripts)
- cargo-tarpaulin (code coverage)
- cargo-audit (security scanning)
- cargo-deny (license and vulnerability checking)

### System Dependencies (for coverage tools)

**Ubuntu/Debian:**

```bash
sudo apt install pkg-config libssl-dev
```

**Fedora/RHEL:**

```bash
sudo dnf install pkg-config openssl-devel
```

**macOS:**

```bash
brew install pkg-config openssl
```

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
git clone https://github.com/templ-project/rust.git my-project
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
│   ├── main.rs           # Binary entry point
│   ├── lib.rs            # Library entry point
│   └── greeter.rs        # Example module with documentation
├── tests/
│   └── greeter_tests.rs  # Integration tests
├── target/               # Build output (gitignored)
├── Taskfile.yml          # Task definitions
├── .mise.toml            # Tool versions & hooks
├── Cargo.toml            # Package metadata and dependencies
├── Cargo.lock            # Dependency lock file
├── rustfmt.toml          # Code formatting rules
├── clippy.toml           # Linting configuration
├── package.json          # Node.js dev dependencies
└── .jscpd.json           # Duplicate detection settings
```

## Building

Build the project in different modes:

```bash
# Debug build (faster compilation, slower runtime)
task build:debug
# or: cargo build

# Release build (optimized)
task build
# or: cargo build --release
```

Outputs:

- `target/debug/` - Debug builds with symbols
- `target/release/` - Optimized release builds

## Testing

The template includes both unit tests and integration tests:

```rust
// src/greeter.rs - Unit test example
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hello() {
        let result = hello("World").unwrap();
        assert_eq!(result, "Hello, World!");
    }
}
```

```rust
// tests/greeter_tests.rs - Integration test example
use rust_template::greeter::hello;

#[test]
fn test_hello_integration() {
    let result = hello("Rust").unwrap();
    assert_eq!(result, "Hello, Rust!");
}
```

Run tests:

```bash
task test                # Run all tests
task test:unit           # Run unit tests only
task test:integration    # Run integration tests only
task test:coverage       # Run with coverage report
```

## Code Quality

### Pre-commit Hooks

Automatic validation via Husky + lint-staged:

| File Type                 | Tools Run        |
| ------------------------- | ---------------- |
| `*.rs`                    | rustfmt, clippy  |
| `*.toml`                  | Prettier         |
| `*.json`, `*.yml`, `*.md` | Prettier, ESLint |
| `*.sh`                    | ShellCheck       |
| `*.ps1`                   | PSScriptAnalyzer |

Run all quality checks:

```bash
task validate
```

This runs:

- Code formatting check (`cargo fmt --check`)
- Linting with clippy (`cargo clippy -- -D warnings`)
- Code duplication detection (`jscpd`)
- All tests (`cargo test`)

Configure hooks in:

- `.husky/pre-commit` - Hook script
- `.lintstagedrc.yml` - File patterns and commands

## Configuration

| File           | Purpose                                         |
| -------------- | ----------------------------------------------- |
| `.mise.toml`   | Tool versions (Rust, Node, Python)              |
| `Taskfile.yml` | Task definitions                                |
| `Cargo.toml`   | Package metadata, dependencies, build profiles  |
| `rustfmt.toml` | Code formatting rules (Edition 2021, 100 chars) |
| `clippy.toml`  | Linting configuration (cognitive complexity 15) |
| `.jscpd.json`  | Duplicate detection settings                    |
| `deny.toml`    | License and vulnerability policy (cargo-deny)   |

## Using as a Library

Add to your `Cargo.toml`:

```toml
[dependencies]
rust-template = { git = "https://github.com/templ-project/rust.git" }
```

Then use in your code:

```rust
use rust_template::greeter::{hello, Greeter};

fn main() {
    // Use the convenience function
    let message = hello("World").unwrap();
    println!("{}", message); // "Hello, World!"

    // Or use the Greeter struct
    let greeter = Greeter::new();
    let message = greeter.hello("Rust").unwrap();
    println!("{}", message); // "Hello, Rust!"
}
```

## CI/CD Pipeline

The GitHub Actions pipeline runs on **Linux, macOS, and Windows**:

| Workflow         | Trigger                 | Jobs                                |
| ---------------- | ----------------------- | ----------------------------------- |
| `ci.yml`         | Push/PR to main/develop | Matrix orchestrator                 |
| `ci.quality.yml` | Called by ci.yml        | lint, test, build, duplicate-check  |
| `ci.version.yml` | Push to main            | Semantic version bump               |
| `ci.release.yml` | After version bump      | Create GitHub release with binaries |

**Release artifacts:**

- Linux binaries (x86_64, aarch64)
- macOS binaries (x86_64, aarch64)
- Windows binaries (x86_64)

## License

MIT © [Templ Project](https://github.com/templ-project)

## Support

- [Report Issues](https://github.com/templ-project/rust/issues)
- [Discussions](https://github.com/templ-project/rust/discussions)
- [Star on GitHub](https://github.com/templ-project/rust)
