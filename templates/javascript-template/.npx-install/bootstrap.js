#!/usr/bin/env node

/**
 * @fileoverview Bootstrap script for JavaScript template project.
 * Clones the template and prepares it for use as a new project.
 */

import { execSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

/**
 * Parses command line arguments.
 * @return {{
 *   targetPath: string,
 *   partOfMultiRepo: boolean,
 *   buildTargets: !Array<string>,
 *   help: boolean
 * }} Parsed arguments.
 */
function parseArgs() {
  const args = process.argv.slice(2);
  const config = {
    targetPath: process.cwd(),
    partOfMultiRepo: false,
    buildTargets: ['all'],
    help: false,
  };

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];

    if (arg === '--help' || arg === '-h') {
      config.help = true;
    } else if (arg === '--part-of-monorepo') {
      config.partOfMultiRepo = true;
    } else if (arg === '--target' && i + 1 < args.length) {
      config.buildTargets = args[++i].split(',');
    } else if (!arg.startsWith('--')) {
      config.targetPath = path.resolve(arg);
    }
  }

  return config;
}

/**
 * Displays help information.
 */
function showHelp() {
  console.log(`
JavaScript Template Bootstrap Tool

Usage:
  npx --yes --package=github:templ-project/javascript bootstrap [options] [path]

Options:
  --part-of-monorepo        Remove .husky, .github folders and related packages
  --target <targets>        Specify build targets (comma-separated)
                           Values: all|esm|cjs|browser
                           Default: all
  -h, --help               Show this help message

Arguments:
  path                     Target directory (default: current directory)

Examples:
  # Bootstrap in current directory with all build targets
  npx --yes --package=github:templ-project/javascript bootstrap

  # Bootstrap in specific directory
  npx --yes --package=github:templ-project/javascript bootstrap ./my-project

  # Bootstrap as part of monorepo (removes git hooks)
  npx --yes --package=github:templ-project/javascript bootstrap --part-of-monorepo

  # Bootstrap with only ESM and CJS builds
  npx --yes --package=github:templ-project/javascript bootstrap --target esm,cjs

  # Combine options
  npx --yes --package=github:templ-project/javascript bootstrap --part-of-monorepo --target esm ./my-lib
`);
}

/**
 * Removes a directory or file if it exists.
 * @param {string} targetPath Path to remove.
 */
function removeIfExists(targetPath) {
  if (fs.existsSync(targetPath)) {
    fs.rmSync(targetPath, { recursive: true, force: true });
    console.log(`  ✓ Removed: ${path.basename(targetPath)}`);
  }
}

/**
 * Reads and parses package.json.
 * @param {string} packagePath Path to package.json.
 * @return {!Object} Parsed package.json.
 */
function readPackageJson(packagePath) {
  const content = fs.readFileSync(packagePath, 'utf8');
  return JSON.parse(content);
}

/**
 * Writes package.json.
 * @param {string} packagePath Path to package.json.
 * @param {!Object} data Package data.
 */
function writePackageJson(packagePath, data) {
  fs.writeFileSync(packagePath, JSON.stringify(data, null, 2) + '\n');
}

/**
 * Cleans build scripts based on target configuration.
 * @param {!Object} pkg Package.json object.
 * @param {!Array<string>} buildTargets Target build types.
 * @return {!Object} Modified package.json object.
 */
function cleanBuildScripts(pkg, buildTargets) {
  if (buildTargets.includes('all')) {
    return pkg;
  }

  const buildScriptMap = {
    esm: 'build:esm',
    cjs: 'build:cjs',
    browser: 'build:browser',
    iife: 'build:iife',
  };

  const scriptsToKeep = buildTargets.map((target) => buildScriptMap[target]).filter(Boolean);

  // Remove unwanted build scripts
  for (const key of Object.keys(pkg.scripts)) {
    if (key.startsWith('build:') && !scriptsToKeep.includes(key)) {
      delete pkg.scripts[key];
      console.log(`  ✓ Removed script: ${key}`);
    }
  }

  return pkg;
}

/**
 * Removes monorepo-related dependencies.
 * @param {!Object} pkg Package.json object.
 * @return {!Object} Modified package.json object.
 */
function removeMonorepoDependencies(pkg) {
  const monorepoDeps = ['husky', 'lint-staged'];

  for (const dep of monorepoDeps) {
    if (pkg.devDependencies && pkg.devDependencies[dep]) {
      delete pkg.devDependencies[dep];
      console.log(`  ✓ Removed dependency: ${dep}`);
    }
  }

  // Remove lint-staged configuration
  if (pkg['lint-staged']) {
    delete pkg['lint-staged'];
    console.log(`  ✓ Removed lint-staged configuration`);
  }

  // Remove prepare script (used by husky)
  if (pkg.scripts && pkg.scripts.prepare) {
    delete pkg.scripts.prepare;
    console.log(`  ✓ Removed prepare script`);
  }

  return pkg;
}

/**
 * Removes bootstrap-related files and dependencies.
 * @param {!Object} pkg Package.json object.
 * @param {string} targetPath Target directory path.
 * @return {!Object} Modified package.json object.
 */
function removeBootstrapArtifacts(pkg, targetPath) {
  // Remove .npx-install directory
  const installDir = path.join(targetPath, '.npx-install');
  removeIfExists(installDir);

  // Remove bin field if it exists
  if (pkg.bin) {
    delete pkg.bin;
    console.log(`  ✓ Removed bin configuration`);
  }

  return pkg;
}

/**
 * Updates package.json metadata for new project.
 * @param {!Object} pkg Package.json object.
 * @return {!Object} Modified package.json object.
 */
function updatePackageMetadata(pkg) {
  // Reset name to a placeholder
  pkg.name = 'my-javascript-project';

  // Reset version
  pkg.version = '0.1.0';

  // Clear repository information
  if (pkg.repository) {
    pkg.repository = {
      type: 'git',
      url: '',
    };
  }

  // Clear bugs URL
  if (pkg.bugs) {
    pkg.bugs = {
      url: '',
    };
  }

  // Clear homepage
  if (pkg.homepage) {
    pkg.homepage = '';
  }

  console.log(`  ✓ Updated package metadata`);
  return pkg;
}

/**
 * Clones the template repository to target directory.
 * @param {string} targetPath Target directory.
 */
function cloneTemplate(targetPath) {
  console.log('📁 Cloning template repository...\n');

  // Ensure target directory exists
  if (!fs.existsSync(targetPath)) {
    fs.mkdirSync(targetPath, { recursive: true });
  }

  // Check if directory is empty
  const files = fs.readdirSync(targetPath);
  if (files.length > 0) {
    console.error('❌ Error: Target directory is not empty');
    console.error(`   Directory: ${targetPath}`);
    console.error('   Please use an empty directory or remove existing files.');
    process.exit(1);
  }

  try {
    // Clone the repository
    console.log('  Cloning from https://github.com/templ-project/javascript...');
    execSync(`git clone --depth 1 https://github.com/templ-project/javascript.git "${targetPath}"`, {
      stdio: 'pipe',
    });
    console.log(`  ✓ Template cloned to ${targetPath}`);
  } catch (error) {
    console.error('❌ Error: Failed to clone repository');
    console.error(`   ${error.message}`);
    console.error('\nPlease ensure:');
    console.error('  1. Git is installed and available in PATH');
    console.error('  2. You have internet connectivity');
    console.error('  3. You have access to https://github.com/templ-project/javascript');
    process.exit(1);
  }
}

/**
 * Main bootstrap function.
 * @param {{
 *   targetPath: string,
 *   partOfMultiRepo: boolean,
 *   buildTargets: !Array<string>,
 *   help: boolean
 * }} config Configuration object.
 */
function bootstrap(config) {
  if (config.help) {
    showHelp();
    return;
  }

  console.log('\n🚀 JavaScript Template Bootstrap\n');

  const targetPath = config.targetPath;

  // Clone template repository to target directory
  cloneTemplate(targetPath);

  const packagePath = path.join(targetPath, 'package.json');

  // Now verify package.json exists (it should after copying)
  if (!fs.existsSync(packagePath)) {
    console.error('❌ Error: Failed to copy template files');
    console.error(`   Expected package.json at: ${packagePath}`);
    process.exit(1);
  }

  console.log('📦 Cleaning up template artifacts...\n');

  // Remove .git directory
  const gitDir = path.join(targetPath, '.git');
  removeIfExists(gitDir);

  // Handle monorepo-specific cleanup
  if (config.partOfMultiRepo) {
    console.log('\n🏢 Monorepo mode: removing git hooks and CI...\n');
    const huskyDir = path.join(targetPath, '.husky');
    const githubDir = path.join(targetPath, '.github');
    removeIfExists(huskyDir);
    removeIfExists(githubDir);
  }

  // Update package.json
  console.log('\n📝 Updating package.json...\n');
  let pkg = readPackageJson(packagePath);

  pkg = cleanBuildScripts(pkg, config.buildTargets);
  pkg = removeBootstrapArtifacts(pkg, targetPath);
  pkg = updatePackageMetadata(pkg);

  if (config.partOfMultiRepo) {
    pkg = removeMonorepoDependencies(pkg);
  }

  writePackageJson(packagePath, pkg);

  console.log('\n✨ Bootstrap complete!\n');
  console.log('Next steps:');
  console.log('  1. Update package.json name, description, and repository');
  console.log('  2. Run: npm install');
  console.log('  3. Run: npm test');
  console.log('  4. Start coding!\n');
}

// Run the bootstrap
const config = parseArgs();
bootstrap(config);
