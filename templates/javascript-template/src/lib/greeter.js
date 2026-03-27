/**
 * @fileoverview Greeter module - demonstrates class design and JSDoc
 * documentation following Google JavaScript Style Guide conventions.
 */

/**
 * A Greeter class that provides greeting and farewell functionality.
 * Demonstrates proper class structure following Google JavaScript Style Guide.
 */
export class Greeter {
  /**
   * Creates a greeting message for the specified name.
   * @param {string} name The name to greet.
   * @return {string} A formatted greeting message.
   * @throws {Error} When name is not provided or is not a string.
   * @example
   * const greeter = new Greeter();
   * const message = greeter.hello('World');
   * console.log(message); // "Hello, World!"
   */
  hello(name) {
    if (!name || typeof name !== 'string') {
      throw new Error('Name must be a non-empty string');
    }

    return `Hello, ${name.trim()}!`;
  }

  /**
   * Creates a farewell message for the specified name.
   * @param {string} name The name to bid farewell.
   * @return {string} A formatted farewell message.
   * @throws {Error} When name is not provided or is not a string.
   * @example
   * const greeter = new Greeter();
   * const message = greeter.goodbye('World');
   * console.log(message); // "Goodbye, World!"
   */
  goodbye(name) {
    if (!name || typeof name !== 'string') {
      throw new Error('Name must be a non-empty string');
    }

    return `Goodbye, ${name.trim()}!`;
  }
}

/**
 * Default Greeter instance for convenience.
 * @const {!Greeter}
 */
const defaultGreeter = new Greeter();

/**
 * Convenience function that creates a greeting message.
 * Uses the default Greeter instance.
 * @param {string} name The name to greet.
 * @return {string} A formatted greeting message.
 * @throws {Error} When name is not provided or is not a string.
 * @example
 * const message = hello('World');
 * console.log(message); // "Hello, World!"
 */
export function hello(name) {
  return defaultGreeter.hello(name);
}

/**
 * Convenience function that creates a farewell message.
 * Uses the default Greeter instance.
 * @param {string} name The name to bid farewell.
 * @return {string} A formatted farewell message.
 * @throws {Error} When name is not provided or is not a string.
 * @example
 * const message = goodbye('World');
 * console.log(message); // "Goodbye, World!"
 */
export function goodbye(name) {
  return defaultGreeter.goodbye(name);
}
