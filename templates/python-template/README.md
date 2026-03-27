# Generic Shell Script Template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CI](https://github.com/templ-project/generic/actions/workflows/ci.yml/badge.svg)](https://github.com/templ-project/generic/actions/workflows/ci.yml)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/templ-project/generic/issues)

> A modern, cross-platform template for Bash and PowerShell script projects with comprehensive tooling, testing, linting, and CI/CD built-in.

- [Generic Shell Script Template](#generic-shell-script-template)
  - [Quick Start](#quick-start)
  - [What's Included](#whats-included)
  - [Common Commands](#common-commands)
  - [Requirements](#requirements)
  - [Setup Development Environment](#setup-development-environment)
  - [Project Structure](#project-structure)
  - [Testing](#testing)
    - [Bash Tests (Bats)](#bash-tests-bats)
    - [PowerShell Tests (Pester)](#powershell-tests-pester)
  - [Code Quality](#code-quality)
    - [Pre-commit Hooks](#pre-commit-hooks)
  - [Configuration](#configuration)
  - [Using as a Library](#using-as-a-library)
    - [Bash](#bash)
    - [PowerShell](#powershell)
  - [CI/CD Pipeline](#cicd-pipeline)
  - [License](#license)
  - [Support](#support)

## Quick Start

**Bootstrap a new project:**

```bash
# Bootstrap in current directory
uvx --from git+https://github.com/templ-project/generic.git bootstrap .

# Bootstrap in specific directory
uvx --from git+https://github.com/templ-project/generic.git bootstrap ./my-project

# Bootstrap with custom project name
uvx --from git+https://github.com/templ-project/generic.git bootstrap --project-name my-awesome-project ./target-dir
```

**After bootstrapping:**

```bash
cd my-project
git init
task deps:sync        # Install all dependencies (mise, npm, uv)
git add .
git commit -m "Initial commit"
```

That's it! You now have a fully configured shell script project.

## What's Included

| Feature                 | Tool                                                                                              | Description                           |
| ----------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------- |
| **Languages**           | Bash + PowerShell                                                                                 | Cross-platform shell scripting        |
| **Task Runner**         | [Taskfile](https://taskfile.dev/)                                                                 | Modern build automation               |
| **Tool Management**     | [mise](https://mise.jdx.dev/)                                                                     | Isolated development environment      |
| **Shell Linting**       | [ShellCheck](https://www.shellcheck.net/)                                                         | Bash/sh static analysis with auto-fix |
| **PowerShell Linting**  | [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)                                | PowerShell best practices             |
| **Python Linting**      | [Pylint](https://pylint.org/) + [Ruff](https://docs.astral.sh/ruff/)                              | For helper scripts                    |
| **Code Formatting**     | [Prettier](https://prettier.io/)                                                                  | JSON, YAML, Markdown formatting       |
| **Bash Testing**        | [Bats-core](https://github.com/bats-core/bats-core)                                               | Bash Automated Testing System         |
| **PowerShell Testing**  | [Pester](https://pester.dev/)                                                                     | PowerShell testing framework          |
| **Pre-commit Hooks**    | [Husky](https://typicode.github.io/husky/) + [lint-staged](https://github.com/okonet/lint-staged) | Automatic validation                  |
| **Duplicate Detection** | [jscpd](https://github.com/kucherenko/jscpd)                                                      | Copy-paste detector                   |
| **Documentation**       | [MkDocs](https://www.mkdocs.org/)                                                                 | Material theme docs                   |
| **CI/CD**               | GitHub Actions                                                                                    | Multi-platform testing & releases     |

## Common Commands

```bash
# === Development ===
task run                 # Run the CLI script
task build               # Build/validate project

# === Code Formatting ===
task format              # Format all code (Prettier, Ruff)
task format:check        # Check formatting without fixing

# === Linting ===
task lint                # Lint all code (ESLint, Pylint, ShellCheck, PSScriptAnalyzer)
task lint:check          # Check all without fixing
task lint:shlint         # Lint bash scripts only
task lint:pwshlint       # Lint PowerShell scripts only

# === Testing ===
task test                # Run all tests (Bats + Pester)
task test:bats           # Run Bash tests only
task test:pester         # Run PowerShell tests only

# === Code Quality ===
task duplicate-check     # Check for duplicate code

# === Documentation ===
task docs                # Build documentation
task docs:serve          # Serve documentation locally

# === Full Validation ===
task validate            # Run complete CI pipeline locally

# === Dependencies ===
task deps:sync           # Install all dependencies
task deps:refresh        # Update all dependencies
task deps:clean          # Remove all dependencies
```

## Requirements

- [mise](https://mise.jdx.dev/) - Tool version management (installs everything else)
- [Task](https://taskfile.dev/) - Task runner (can be installed via mise or standalone)

**Automatically installed via mise:**

- Node.js 22 (for ESLint, Prettier, jscpd)
- Python 3.11+ (for linting scripts, docs)
- ShellCheck (bash linting)
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
git clone https://github.com/templ-project/generic.git my-project
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
│       ├── ci.yml        # Main CI orchestrator
│       ├── ci.quality.yml# Lint, test, build jobs
│       ├── ci.release.yml# GitHub release publishing
│       └── ci.version.yml# Semantic versioning (Bumpalicious)
├── .scripts/             # Build/lint helper scripts
│   ├── shlint.py         # ShellCheck wrapper with auto-fix
│   ├── pwshlint.py       # PSScriptAnalyzer wrapper
│   ├── run-pester.ps1    # Pester test runner
│   └── fix-mise-pwsh.*   # mise PowerShell installation fix
├── .taskfiles/           # Shared Taskfile modules
├── src/                  # Source scripts
│   ├── cli.sh            # Bash CLI entrypoint
│   ├── cli.ps1           # PowerShell CLI entrypoint
│   ├── greeter.sh        # Bash library module
│   └── greeter.ps1       # PowerShell library module
├── test/                 # Test files
│   ├── greeter.test.bats # Bash tests (Bats)
│   └── greeter.Tests.ps1 # PowerShell tests (Pester)
├── docs/                 # Documentation source
├── _uvx_install/         # Bootstrap script (for uvx)
├── Taskfile.yml          # Task definitions
├── .mise.toml            # Tool versions & hooks
├── package.json          # Node.js dev dependencies
├── pyproject.toml        # Python config & dependencies
└── VERSION               # Project version (semver)
```

## Testing

### Bash Tests (Bats)

Tests are in `test/*.bats`:

```bash
# test/greeter.test.bats
@test "hello returns greeting" {
  source src/greeter.sh
  result="$(hello "World")"
  [ "$result" = "Hello, World!" ]
}
```

Run with: `task test:bats`

### PowerShell Tests (Pester)

Tests are in `test/*.Tests.ps1`:

```powershell
# test/greeter.Tests.ps1
Describe "Hello function" {
    It "Returns greeting" {
        . src/greeter.ps1
        Hello -Name "World" | Should -Be "Hello, World!"
    }
}
```

Run with: `task test:pester`

## Code Quality

### Pre-commit Hooks

Automatic validation via Husky + lint-staged:

| File Type                 | Tools Run           |
| ------------------------- | ------------------- |
| `*.sh`, `*.bats`          | ShellCheck          |
| `*.ps1`                   | PSScriptAnalyzer    |
| `*.py`                    | Ruff format, Pylint |
| `*.json`, `*.yml`, `*.md` | Prettier, ESLint    |

Configure in:

- `.husky/pre-commit` - Hook script
- `.lintstagedrc.yml` - File patterns and commands

## Configuration

| File                             | Purpose                                              |
| -------------------------------- | ---------------------------------------------------- |
| `.mise.toml`                     | Tool versions (Node, Python, ShellCheck, PowerShell) |
| `Taskfile.yml`                   | Task definitions                                     |
| `.shellcheckrc`                  | ShellCheck rules                                     |
| `.PSScriptAnalyzerSettings.psd1` | PSScriptAnalyzer rules                               |
| `pyproject.toml`                 | Python tools (Pylint, Ruff, Black)                   |
| `eslint.config.mjs`              | ESLint config (uses `@templ-project/eslint`)         |
| `prettier.config.mjs`            | Prettier config (uses `@templ-project/prettier`)     |
| `.jscpd.json`                    | Duplicate detection settings                         |

## Using as a Library

### Bash

Source the library modules in your scripts:

```bash
#!/usr/bin/env bash

# Source the greeter module
source /path/to/src/greeter.sh

# Use the functions
message=$(hello "World")
echo "$message"  # "Hello, World!"
```

### PowerShell

Dot-source the library modules in your scripts:

```powershell
#!/usr/bin/env pwsh

# Dot-source the greeter module
. /path/to/src/greeter.ps1

# Use the functions
$message = Hello -Name "World"
Write-Output $message  # "Hello, World!"
```

## CI/CD Pipeline

The GitHub Actions pipeline runs on **Linux, macOS, and Windows**:

| Workflow         | Trigger                 | Jobs                                                                               |
| ---------------- | ----------------------- | ---------------------------------------------------------------------------------- |
| `ci.yml`         | Push/PR to main/develop | Matrix orchestrator                                                                |
| `ci.quality.yml` | Called by ci.yml        | lint, test, build, duplicate-check                                                 |
| `ci.version.yml` | Push to main            | Semantic version bump ([Bumpalicious](https://github.com/dragoscops/bumpalicious)) |
| `ci.release.yml` | After version bump      | Create GitHub release with archives                                                |

**Release artifacts:**

- `{project}-{version}.tar.gz` - Unix archive
- `{project}-{version}.zip` - Windows archive

Both contain the `src/` scripts, `README.md`, and `LICENSE`.

## License

MIT © [Templ Project](https://github.com/templ-project)

## Support

- [Report Issues](https://github.com/templ-project/generic/issues)
- [Documentation](https://templ-project.github.io/generic/)
- [Star on GitHub](https://github.com/templ-project/generic)
