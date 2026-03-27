# Contributing to Rust Bootstrap Template

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Development Process

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## Pull Requests

Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code passes formatting and linting checks.
6. Issue that pull request!

## Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/rust.git
cd rust

# Ensure Rust is installed (or use mise)
rustc --version
cargo --version

# Run tests to ensure everything works
cargo test

# Or use Taskfile
task test

# Build the project
cargo build --release
# Or: task build
```

## Code Style

We use several tools to maintain code quality:

### rustfmt

- Automatic code formatting following Rust API Guidelines
- Configuration: `rustfmt.toml`
- Run: `cargo fmt` or `task format`
- Check: `cargo fmt --check` or `task format:check`

### Clippy

- Advanced linting for idiomatic Rust
- Configuration: `clippy.toml`
- Run: `cargo clippy` or `task lint:check`
- Auto-fix (when possible): `cargo clippy --fix` or `task lint`

### Testing

- Write tests for all new features
- Include both unit tests (in module files) and integration tests (`tests/` directory)
- Follow TDD (Test-Driven Development) practices
- Run: `cargo test` or `task test`
- Coverage: `task test:coverage` (requires cargo-tarpaulin)

## Quality Gates

Before submitting a PR, ensure:

```bash
# Run all quality checks
task validate

# This runs:
# - cargo fmt --check     (formatting check)
# - cargo clippy          (linting)
# - jscpd src/            (duplicate detection)
# - cargo test            (all tests)
```

## Testing Guidelines

### Unit Tests

Place unit tests in the same file as the code they test, in a `tests` module:

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_something() {
        assert_eq!(result, expected);
    }
}
```

### Integration Tests

Place integration tests in the `tests/` directory:

```rust
// tests/my_feature_tests.rs
use rust_template::MyFeature;

#[test]
fn test_my_feature() {
    // Test public API
}
```

### Documentation Tests

Include examples in doc comments that also serve as tests:

````rust
/// Returns a greeting message.
///
/// # Examples
///
/// ```
/// use rust_template::hello;
///
/// let msg = hello("World").unwrap();
/// assert_eq!(msg, "Hello, World!");
/// ```
pub fn hello(name: &str) -> Result<String, Error> {
    // Implementation
}
````

## File Structure

```
src/
├── main.rs              # Binary entry point
├── lib.rs               # Library entry point
└── greeter.rs           # Example module
tests/
└── greeter_tests.rs     # Integration tests
```

## Documentation

- Use Rust doc comments (`///` for items, `//!` for modules)
- Include examples in doc comments
- Run `cargo doc --open` or `task docs` to view generated documentation
- Document all public APIs
- Add `# Errors` section for functions that return `Result`
- Add `# Panics` section if function can panic
- Add `# Safety` section for `unsafe` functions

## Error Handling

- Use `Result<T, E>` for recoverable errors
- Create custom error types with `thiserror` or implement `std::error::Error`
- Avoid panics in library code
- Document error conditions

Example:

```rust
use std::fmt;

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum MyError {
    InvalidInput(String),
    NotFound,
}

impl fmt::Display for MyError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            MyError::InvalidInput(msg) => write!(f, "Invalid input: {}", msg),
            MyError::NotFound => write!(f, "Resource not found"),
        }
    }
}

impl std::error::Error for MyError {}
```

## Performance

- Use `#[must_use]` for functions whose return value shouldn't be ignored
- Avoid unnecessary clones and allocations
- Use `&str` instead of `String` in function parameters when possible
- Use `impl Trait` or generics for flexibility
- Profile code with `cargo bench` for performance-critical sections

## Security

- Never commit secrets or credentials
- Validate all inputs
- Use `cargo audit` to check for vulnerable dependencies
- Follow the [Rust Security Guidelines](https://anssi-fr.github.io/rust-guide/)

## Versioning

We use [SemVer](http://semver.org/) for versioning. For versions available, see the [tags on this repository](https://github.com/templ-project/rust/tags).

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Community

- Be respectful and constructive
- Follow the [Rust Code of Conduct](https://www.rust-lang.org/policies/code-of-conduct)
- Ask questions in GitHub Discussions
- Report bugs via GitHub Issues

## Any Questions?

Don't hesitate to create an issue or discussion if you have questions about contributing!

## Additional Tools Setup

### Using mise (recommended)

```bash
# Install mise: https://mise.jdx.dev/

# Install Rust via mise
mise use rust@1.75.0

# Install cargo tools via mise
mise use cargo:cargo-watch@latest
mise use cargo:cargo-tarpaulin@latest
mise use cargo:cargo-audit@latest
```

### Manual Installation

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install additional tools
cargo install cargo-watch      # Watch for file changes
cargo install cargo-tarpaulin  # Code coverage
cargo install cargo-audit      # Security auditing
cargo install cargo-outdated   # Check outdated dependencies
cargo install cargo-bloat      # Analyze binary size
```

## Thank You!

Your contributions make this project better for everyone. Thank you for taking the time to contribute! 🦀
