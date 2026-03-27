/**
 * Greeter module - demonstrates class design and TypeDoc
 * documentation following TypeScript best practices.
 *
 * @module
 */

/**
 * A Greeter class that provides greeting and farewell functionality.
 * Demonstrates proper class structure following TypeScript best practices.
 */
export class Greeter {
  /**
   * Creates a greeting message for the specified name.
   * @param name - The name to greet.
   * @returns A formatted greeting message.
   * @throws {Error} When name is not provided or is not a string.
   * @example
   * ```typescript
   * const greeter = new Greeter();
   * const message = greeter.hello('World');
   * console.log(message); // "Hello, World!"
   * ```
   */
  hello(name: string): string {
    if (!name || typeof name !== 'string') {
      throw new Error('Name must be a non-empty string');
    }

    return `Hello, ${name.trim()}!`;
  }

  /**
   * Creates a farewell message for the specified name.
   * @param name - The name to bid farewell.
   * @returns A formatted farewell message.
   * @throws {Error} When name is not provided or is not a string.
   * @example
   * ```typescript
   * const greeter = new Greeter();
   * const message = greeter.goodbye('World');
   * console.log(message); // "Goodbye, World!"
   * ```
   */
  goodbye(name: string): string {
    if (!name || typeof name !== 'string') {
      throw new Error('Name must be a non-empty string');
    }

    return `Goodbye, ${name.trim()}!`;
  }
}

/**
 * Default Greeter instance for convenience.
 */
const defaultGreeter = new Greeter();

/**
 * Convenience function that creates a greeting message.
 * Uses the default Greeter instance.
 * @param name - The name to greet.
 * @returns A formatted greeting message.
 * @throws {Error} When name is not provided or is not a string.
 * @example
 * ```typescript
 * const message = hello('World');
 * console.log(message); // "Hello, World!"
 * ```
 */
export function hello(name: string): string {
  return defaultGreeter.hello(name);
}

/**
 * Convenience function that creates a farewell message.
 * Uses the default Greeter instance.
 * @param name - The name to bid farewell.
 * @returns A formatted farewell message.
 * @throws {Error} When name is not provided or is not a string.
 * @example
 * ```typescript
 * const message = goodbye('World');
 * console.log(message); // "Goodbye, World!"
 * ```
 */
export function goodbye(name: string): string {
  return defaultGreeter.goodbye(name);
}
