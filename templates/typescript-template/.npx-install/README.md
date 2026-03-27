# Bootstrap Script

This directory contains the bootstrap script for setting up new projects from this template.

## Usage

### Quick Start

Bootstrap a new project in the current directory:

```bash
npx --yes --package=github:templ-project/typescript bootstrap
```

### Options

#### `--part-of-monorepo`

Use this flag when adding this template as part of a monorepo. This will:

- Remove `.husky` directory (git hooks)
- Remove `.github` directory (CI/CD workflows)
- Remove `husky` and `lint-staged` from dependencies
- Remove `prepare` script from package.json
- Remove `lint-staged` configuration

```bash
npx --yes --package=github:templ-project/typescript bootstrap --part-of-monorepo
```

#### `--target <targets>`

Specify which build targets to keep. By default, all build targets are kept.

Available targets:

- `all` - Keep all build targets (default)
- `esm` - ES Modules build
- `cjs` - CommonJS build
- `browser` - Browser-specific ESM build
- `iife` - Immediately Invoked Function Expression build for browsers

Multiple targets can be specified as comma-separated values:

```bash
# Keep only ESM and CJS builds
npx --yes --package=github:templ-project/typescript bootstrap --target esm,cjs

# Keep only browser builds
npx --yes --package=github:templ-project/typescript bootstrap --target browser,iife
```

#### Target Directory

Specify a target directory as the last argument:

```bash
npx --yes --package=github:templ-project/typescript bootstrap ./my-project
```

### Complete Examples

**Standard project in current directory:**

```bash
npx --yes --package=github:templ-project/typescript bootstrap
```

**Monorepo package with only ESM and CJS:**

```bash
npx --yes --package=github:templ-project/typescript bootstrap \
  --part-of-monorepo \
  --target esm,cjs \
  ./packages/my-lib
```

**Browser-only library:**

```bash
npx --yes --package=github:templ-project/typescript bootstrap \
  --target browser,iife \
  ./my-browser-lib
```

## What the Bootstrap Script Does

The bootstrap script performs the following actions:

1. **Clones the Template Repository**
   - Clones from `https://github.com/templ-project/typescript`
   - Uses `--depth 1` for faster cloning

2. **Removes Git History**
   - Deletes `.git` directory to start fresh

3. **Cleans Build Configuration** (if `--target` specified)
   - Removes unwanted build scripts from package.json
   - Keeps only the specified build targets

4. **Removes Bootstrap Artifacts**
   - Deletes `.npx-install` directory (this directory!)
   - Removes `bin` field from package.json

5. **Updates Package Metadata**
   - Resets package name to `my-typescript-project`
   - Resets version to `0.1.0`
   - Clears repository, bugs, and homepage URLs

6. **Monorepo Cleanup** (if `--part-of-monorepo` specified)
   - Removes `.husky` directory
   - Removes `.github` directory
   - Removes git hook dependencies
   - Removes related scripts

## After Bootstrap

After running the bootstrap script, follow these steps:

1. **Update package.json**

   ```bash
   # Edit package.json and update:
   # - name
   # - description
   # - author
   # - repository
   # - homepage
   # - bugs
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Initialize git** (if not part of monorepo)

   ```bash
   git init
   git add .
   git commit -m "Initial commit from template"
   ```

4. **Run tests**

   ```bash
   npm test
   ```

5. **Start developing!**
   ```bash
   npm run start
   ```

## Development

If you need to modify the bootstrap script:

1. Edit `.npx-install/bootstrap.js`
2. Test locally by running:
   ```bash
   node .npx-install/bootstrap.js [options]
   ```
3. Commit and push changes to the template repository

## Troubleshooting

### Script Not Found

If you get "script not found" errors, ensure:

1. You're using Node.js 20 or higher
2. The package was installed correctly
3. The `.npx-install/bootstrap.js` file has execute permissions

### Package.json Not Found

The bootstrap script clones the template repository first, then modifies it. If you see this error, there may be network issues preventing the clone.

### Permission Errors

On Unix-like systems, ensure the bootstrap script is executable:

```bash
chmod +x .npx-install/bootstrap.js
```
