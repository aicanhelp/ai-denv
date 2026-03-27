# Contributing to JavaScript Bootstrap Template

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
5. Make sure your code lints.
6. Issue that pull request!

## Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/javascript.git
cd javascript

# Install dependencies
npm install

# Set up git hooks
npm run prepare

# Run tests to ensure everything works
npm test

# Build the project
npm run build

# Try the browser example (optional)
npm run serve
# Then open http://localhost:3000/example.html
```

## Code Style

We use several tools to maintain code quality:

### ESLint

- Follows Google JavaScript Style Guide
- Run: `npm run lint`
- Auto-fix: `npm run lint -- --fix`

### Prettier

- Consistent code formatting
- Run: `npm run format`
- Check: `npm run format:check`

### Testing

- Write tests for all new features
- Follow TDD (Test-Driven Development) practices
- Run: `npm test`
- Watch mode: `npm run test:watch`
- Coverage: `npm run test:coverage`

## Quality Gates

Before submitting a PR, ensure:

```bash
# Run all quality checks
npm run validate

# This runs:
# - npm run lint:check
# - npm run format:check
# - npm run test
```

## Git Hooks

We use Husky and lint-staged for pre-commit validation:

- **Pre-commit**: Automatically formats and lints staged files
- **Pre-push**: Runs full test suite

## File Structure

```
src/
├── index.js                 # Main entry point
├── index.test.js            # Integration tests
└── lib/
    ├── greeter.js           # Example module
    └── greeter.test.js      # Unit tests
```

## Naming Conventions

### Files

- Use kebab-case for file names: `my-module.js`
- Test files: `my-module.test.js`
- Config files: `my-config.config.js`

### Functions

- Use camelCase: `myFunction()`
- Be descriptive: `calculateTotalPrice()` vs `calc()`

### Variables

- Use camelCase: `myVariable`
- Constants: `UPPER_SNAKE_CASE` or `camelCase` for module-scoped

### Classes (if used)

- Use PascalCase: `MyClass`

## Documentation

### JSDoc Comments

All functions should have JSDoc comments:

```javascript
/**
 * Brief description of the function
 *
 * @param {string} name - Description of parameter
 * @returns {string} Description of return value
 * @throws {Error} When error conditions occur
 *
 * @example
 * const result = myFunction('example');
 * console.log(result); // Expected output
 */
function myFunction(name) {
  // Implementation
}
```

### README Updates

- Update README.md if you change functionality
- Include examples for new features
- Update API documentation section

## Testing Guidelines

### Test Structure

```javascript
import { describe, it, expect } from "vitest";
import { myFunction } from "../lib/my-module.js";

describe("my-module", () => {
  describe("myFunction", () => {
    it("should handle normal cases", () => {
      // Test implementation
    });

    it("should handle edge cases", () => {
      // Test implementation
    });

    it("should throw errors for invalid input", () => {
      // Test implementation
    });
  });
});
```

### Test Categories

1. **Unit Tests**: Test individual functions
2. **Integration Tests**: Test module interactions
3. **Edge Cases**: Test boundary conditions
4. **Error Cases**: Test error handling

### Coverage Goals

- Aim for 90%+ test coverage
- All new functions should have tests
- Critical paths must be tested

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
```

Examples:

```
feat: add goodbye function to greeter module
fix: handle empty string input in hello function
docs: update API documentation for greeter
test: add edge case tests for hello function
```

## Issue Reporting

### Bug Reports

Include:

- Node.js version
- npm version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Error messages

### Feature Requests

Include:

- Use case description
- Proposed API/interface
- Benefits to users
- Implementation considerations

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Feel free to open an issue or reach out to the maintainers!

---

Thank you for contributing! 🎉
