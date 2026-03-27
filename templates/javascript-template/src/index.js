#!/usr/bin/env node

/**
 * @fileoverview Main entry point for the JavaScript Template project.
 * Demonstrates ESM module usage and clean code practices following
 * Google JavaScript Style Guide.
 */

import { Greeter, hello } from './lib/greeter.js';

/**
 * Main function that demonstrates the template functionality.
 * Logs a greeting message to the console.
 * @returns {void}
 */
function main() {
  const message = hello('World');
  console.log(message);
}

export { Greeter, hello, main };
