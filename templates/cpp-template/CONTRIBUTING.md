# Contributing to C++ Bootstrap Template

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
5. Make sure your code follows the style guidelines.
6. Issue that pull request!

## Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/cpp.git
cd cpp

# Install dependencies
task deps:install
# OR manually
conan install . --build=missing

# Build and test
task build
task test
```

## Code Style

We follow the [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html).

### Formatting

- Use clang-format with Google style
- Run: `task format`
- Check: `task format:check`

### Linting

- Use clang-tidy for static analysis
- Run: `task lint`
- Configuration in `.clang-tidy`

### Naming Conventions

```cpp
// Namespaces: snake_case
namespace my_namespace {

// Classes: CamelCase
class MyClass {
 public:
  // Methods: CamelCase
  void MyMethod() const;

  // Public members: snake_case
  int public_member;

 private:
  // Private members: snake_case with trailing underscore
  int private_member_;
};

// Functions: CamelCase
void GlobalFunction();

// Variables: snake_case
int local_variable = 0;

// Constants: kCamelCase
const int kMaxSize = 100;

// Macros: UPPER_CASE
#define MY_MACRO(x) (x)

}  // namespace my_namespace
```

## Testing Guidelines

### Test Structure

```cpp
#include <gtest/gtest.h>
#include "my_module.hpp"

namespace my_namespace {
namespace {

class MyModuleTest : public ::testing::Test {
 protected:
  void SetUp() override {
    // Setup code
  }

  void TearDown() override {
    // Cleanup code
  }
};

TEST_F(MyModuleTest, ShouldHandleNormalCases) {
  // Test implementation
}

TEST_F(MyModuleTest, ShouldHandleEdgeCases) {
  // Test implementation
}

TEST_F(MyModuleTest, ShouldThrowForInvalidInput) {
  EXPECT_THROW(MyFunction(""), std::invalid_argument);
}

}  // namespace
}  // namespace my_namespace
```

### Test Categories

1. **Unit Tests**: Test individual functions and classes
2. **Integration Tests**: Test module interactions
3. **Exception Tests**: Test error handling
4. **Performance Tests**: Test performance characteristics

### Coverage Goals

- Aim for 90%+ test coverage
- All new functions should have tests
- Critical paths must be tested
- Error conditions should be tested

## Build Systems

### CMake

```bash
# Configure
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=clang++

# Build
cmake --build build --parallel

# Test
cd build && ctest --output-on-failure
```

### XMake

```bash
# Configure
xmake f -m release --toolchain=clang

# Build
xmake build

# Test
xmake run cpp-template-tests
```

### Taskfile (Recommended)

```bash
# See all available tasks
task --list

# Development workflow
task ci  # format + lint + build + test
```

## Quality Gates

Before submitting a PR, ensure:

```bash
# Run all quality checks
task ci

# This runs:
# - task format:check
# - task lint
# - task build
# - task test
```

## Cross-Platform Support

Ensure your changes work on all supported platforms:

- **Windows**: MSVC, Clang, MinGW
- **Linux**: GCC, Clang
- **macOS**: Clang, GCC (via Homebrew)

### Testing Cross-Platform

```bash
# Test different compilers locally
task build COMPILER=clang++
task build COMPILER=g++

# Multi-platform development
# Use GitHub Actions CI/CD for cross-platform testing
# Develop natively on target platforms when possible
```

## Documentation

### Code Documentation

Use Doxygen-style comments:

```cpp
/**
 * @brief Brief description of the function
 *
 * Detailed description of what the function does,
 * including any important notes or caveats.
 *
 * @param param1 Description of first parameter
 * @param param2 Description of second parameter
 * @return Description of return value
 * @throws ExceptionType When this exception is thrown
 *
 * @example
 * MyClass obj;
 * int result = obj.MyFunction("input", 42);
 * // result is now processed
 */
int MyFunction(const std::string& param1, int param2);
```

### Generate Documentation

```bash
task docs
# Opens docs/html/index.html
```

## Memory Safety

### AddressSanitizer

```bash
# Build with sanitizers
task build BUILD_TYPE=Debug
task test  # Will run with ASAN enabled
```

### Valgrind

```bash
# Run with Valgrind
task valgrind
```

### Static Analysis

```bash
# Run clang-tidy
task lint

# Run with all checks
clang-tidy src/*.cpp --config-file=.clang-tidy
```

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new feature
fix: fix bug description
docs: update documentation
style: formatting changes
refactor: code refactoring
test: add or update tests
chore: maintenance tasks
perf: performance improvements
```

Examples:

```
feat: add Goodbye function to greeter module
fix: handle empty string input in Hello function
docs: update API documentation for greeter
test: add edge case tests for Hello function
perf: optimize string trimming in greeter
```

## Issue Reporting

### Bug Reports

Include:

- Operating system and version
- Compiler and version
- CMake/XMake version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Error messages and stack traces

### Feature Requests

Include:

- Use case description
- Proposed API/interface
- Benefits to users
- Implementation considerations
- Breaking change implications

## Performance Considerations

- Profile before optimizing
- Prefer standard library algorithms
- Use move semantics appropriately
- Avoid unnecessary copies
- Consider cache-friendly data structures
- Benchmark critical paths

## Security Guidelines

- Validate all inputs
- Use RAII for resource management
- Avoid raw pointers when possible
- Use smart pointers appropriately
- Be careful with integer overflow
- Use secure random number generation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Feel free to open an issue or reach out to the maintainers!

---

Thank you for contributing! 🎉
