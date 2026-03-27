/**
 * @fileoverview Test suite for the greeter module.
 * Demonstrates TDD practices using Vitest testing framework.
 */

import { beforeEach, describe, expect, it } from 'vitest';
import { Greeter, goodbye, hello } from './greeter.js';

describe('greeter module', () => {
  describe('Greeter class', () => {
    let greeter;

    beforeEach(() => {
      greeter = new Greeter();
    });

    describe('hello method', () => {
      it('should return a greeting message for a valid name', () => {
        const result = greeter.hello('World');
        expect(result).toBe('Hello, World!');
      });

      it('should handle names with extra whitespace', () => {
        const result = greeter.hello('  JavaScript  ');
        expect(result).toBe('Hello, JavaScript!');
      });

      it('should throw an error for empty string', () => {
        expect(() => greeter.hello('')).toThrow('Name must be a non-empty string');
      });

      it('should throw an error for null', () => {
        expect(() => greeter.hello(null)).toThrow('Name must be a non-empty string');
      });

      it('should throw an error for undefined', () => {
        expect(() => greeter.hello(undefined)).toThrow('Name must be a non-empty string');
      });

      it('should throw an error for non-string types', () => {
        expect(() => greeter.hello(123)).toThrow('Name must be a non-empty string');
        expect(() => greeter.hello({})).toThrow('Name must be a non-empty string');
        expect(() => greeter.hello([])).toThrow('Name must be a non-empty string');
      });
    });

    describe('goodbye method', () => {
      it('should return a farewell message for a valid name', () => {
        const result = greeter.goodbye('World');
        expect(result).toBe('Goodbye, World!');
      });

      it('should handle names with extra whitespace', () => {
        const result = greeter.goodbye('  JavaScript  ');
        expect(result).toBe('Goodbye, JavaScript!');
      });

      it('should throw an error for empty string', () => {
        expect(() => greeter.goodbye('')).toThrow('Name must be a non-empty string');
      });

      it('should throw an error for null', () => {
        expect(() => greeter.goodbye(null)).toThrow('Name must be a non-empty string');
      });

      it('should throw an error for undefined', () => {
        expect(() => greeter.goodbye(undefined)).toThrow('Name must be a non-empty string');
      });

      it('should throw an error for non-string types', () => {
        expect(() => greeter.goodbye(123)).toThrow('Name must be a non-empty string');
        expect(() => greeter.goodbye({})).toThrow('Name must be a non-empty string');
        expect(() => greeter.goodbye([])).toThrow('Name must be a non-empty string');
      });
    });
  });

  describe('hello function', () => {
    it('should return a greeting message for a valid name', () => {
      const result = hello('World');
      expect(result).toBe('Hello, World!');
    });

    it('should handle names with extra whitespace', () => {
      const result = hello('  JavaScript  ');
      expect(result).toBe('Hello, JavaScript!');
    });

    it('should throw an error for empty string', () => {
      expect(() => hello('')).toThrow('Name must be a non-empty string');
    });

    it('should throw an error for null', () => {
      expect(() => hello(null)).toThrow('Name must be a non-empty string');
    });

    it('should throw an error for undefined', () => {
      expect(() => hello(undefined)).toThrow('Name must be a non-empty string');
    });

    it('should throw an error for non-string types', () => {
      expect(() => hello(123)).toThrow('Name must be a non-empty string');
      expect(() => hello({})).toThrow('Name must be a non-empty string');
      expect(() => hello([])).toThrow('Name must be a non-empty string');
    });
  });

  describe('goodbye function', () => {
    it('should return a farewell message for a valid name', () => {
      const result = goodbye('World');
      expect(result).toBe('Goodbye, World!');
    });

    it('should handle names with extra whitespace', () => {
      const result = goodbye('  JavaScript  ');
      expect(result).toBe('Goodbye, JavaScript!');
    });

    it('should throw an error for empty string', () => {
      expect(() => goodbye('')).toThrow('Name must be a non-empty string');
    });

    it('should throw an error for null', () => {
      expect(() => goodbye(null)).toThrow('Name must be a non-empty string');
    });

    it('should throw an error for undefined', () => {
      expect(() => goodbye(undefined)).toThrow('Name must be a non-empty string');
    });

    it('should throw an error for non-string types', () => {
      expect(() => goodbye(123)).toThrow('Name must be a non-empty string');
      expect(() => goodbye({})).toThrow('Name must be a non-empty string');
      expect(() => goodbye([])).toThrow('Name must be a non-empty string');
    });
  });
});
