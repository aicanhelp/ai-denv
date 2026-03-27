#!/usr/bin/env node

/**
 * Main entry point for the TypeScript Template project.
 * Demonstrates ESM module usage and clean code practices following
 * TypeScript best practices.
 *
 * @module
 */

import { Greeter, hello } from './lib/greeter.js';

/**
 * Main function that demonstrates the template functionality.
 * Logs a greeting message to the console.
 * @returns {void}
 */
function main(): void {
  const message = hello('World');
  console.log(message);
}

export { Greeter, hello, main };
