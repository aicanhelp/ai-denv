//! Greeter module - demonstrates struct design and Rust doc comments
//! following Rust API Guidelines.
//!
//! This module provides greeting and farewell functionality through both
//! a struct-based API and convenience functions.

use std::fmt;

/// A Greeter struct that provides greeting and farewell functionality.
/// Demonstrates proper struct design following Rust API Guidelines.
///
/// # Examples
///
/// ```
/// use rust_template::Greeter;
///
/// let greeter = Greeter::new();
/// let message = greeter.hello("World").unwrap();
/// assert_eq!(message, "Hello, World!");
/// ```
#[derive(Debug, Clone, Default)]
pub struct Greeter;

/// Error type for greeting operations.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum GreeterError {
    /// Name was empty or contained only whitespace
    EmptyName,
    /// Name contained invalid characters or format
    InvalidName(String),
}

impl fmt::Display for GreeterError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::EmptyName => write!(f, "Name must be a non-empty string"),
            Self::InvalidName(msg) => write!(f, "Invalid name: {msg}"),
        }
    }
}

impl std::error::Error for GreeterError {}

impl Greeter {
    /// Creates a new Greeter instance.
    ///
    /// # Examples
    ///
    /// ```
    /// use rust_template::Greeter;
    ///
    /// let greeter = Greeter::new();
    /// ```
    #[must_use]
    pub fn new() -> Self {
        Self
    }

    /// Creates a greeting message for the specified name.
    ///
    /// # Arguments
    ///
    /// * `name` - The name to greet
    ///
    /// # Returns
    ///
    /// A `Result` containing the formatted greeting message or an error.
    ///
    /// # Errors
    ///
    /// Returns `GreeterError::EmptyName` when name is empty or contains only whitespace.
    ///
    /// # Examples
    ///
    /// ```
    /// use rust_template::Greeter;
    ///
    /// let greeter = Greeter::new();
    /// let message = greeter.hello("World").unwrap();
    /// assert_eq!(message, "Hello, World!");
    /// ```
    pub fn hello(&self, name: &str) -> Result<String, GreeterError> {
        let trimmed = name.trim();
        if trimmed.is_empty() {
            return Err(GreeterError::EmptyName);
        }
        Ok(format!("Hello, {trimmed}!"))
    }

    /// Creates a farewell message for the specified name.
    ///
    /// # Arguments
    ///
    /// * `name` - The name to bid farewell
    ///
    /// # Returns
    ///
    /// A `Result` containing the formatted farewell message or an error.
    ///
    /// # Errors
    ///
    /// Returns `GreeterError::EmptyName` when name is empty or contains only whitespace.
    ///
    /// # Examples
    ///
    /// ```
    /// use rust_template::Greeter;
    ///
    /// let greeter = Greeter::new();
    /// let message = greeter.goodbye("World").unwrap();
    /// assert_eq!(message, "Goodbye, World!");
    /// ```
    pub fn goodbye(&self, name: &str) -> Result<String, GreeterError> {
        let trimmed = name.trim();
        if trimmed.is_empty() {
            return Err(GreeterError::EmptyName);
        }
        Ok(format!("Goodbye, {trimmed}!"))
    }
}

/// Convenience function to create a greeting message.
///
/// This is a shorthand for creating a `Greeter` instance and calling `hello`.
///
/// # Arguments
///
/// * `name` - The name to greet
///
/// # Returns
///
/// A `Result` containing the formatted greeting message or an error.
///
/// # Errors
///
/// Returns `GreeterError::EmptyName` when name is empty or contains only whitespace.
///
/// # Examples
///
/// ```
/// use rust_template::hello;
///
/// let message = hello("World").unwrap();
/// assert_eq!(message, "Hello, World!");
/// ```
pub fn hello(name: &str) -> Result<String, GreeterError> {
    Greeter::new().hello(name)
}

/// Convenience function to create a farewell message.
///
/// This is a shorthand for creating a `Greeter` instance and calling `goodbye`.
///
/// # Arguments
///
/// * `name` - The name to bid farewell
///
/// # Returns
///
/// A `Result` containing the formatted farewell message or an error.
///
/// # Errors
///
/// Returns `GreeterError::EmptyName` when name is empty or contains only whitespace.
///
/// # Examples
///
/// ```
/// use rust_template::goodbye;
///
/// let message = goodbye("World").unwrap();
/// assert_eq!(message, "Goodbye, World!");
/// ```
pub fn goodbye(name: &str) -> Result<String, GreeterError> {
    Greeter::new().goodbye(name)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_greeter_hello_valid_name() {
        let greeter = Greeter::new();
        let result = greeter.hello("World").unwrap();
        assert_eq!(result, "Hello, World!");
    }

    #[test]
    fn test_greeter_hello_with_whitespace() {
        let greeter = Greeter::new();
        let result = greeter.hello("  Rust  ").unwrap();
        assert_eq!(result, "Hello, Rust!");
    }

    #[test]
    fn test_greeter_hello_empty_string() {
        let greeter = Greeter::new();
        let result = greeter.hello("");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), GreeterError::EmptyName);
    }

    #[test]
    fn test_greeter_hello_whitespace_only() {
        let greeter = Greeter::new();
        let result = greeter.hello("   ");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), GreeterError::EmptyName);
    }

    #[test]
    fn test_greeter_goodbye_valid_name() {
        let greeter = Greeter::new();
        let result = greeter.goodbye("World").unwrap();
        assert_eq!(result, "Goodbye, World!");
    }

    #[test]
    fn test_greeter_goodbye_with_whitespace() {
        let greeter = Greeter::new();
        let result = greeter.goodbye("  Rust  ").unwrap();
        assert_eq!(result, "Goodbye, Rust!");
    }

    #[test]
    fn test_greeter_goodbye_empty_string() {
        let greeter = Greeter::new();
        let result = greeter.goodbye("");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), GreeterError::EmptyName);
    }

    #[test]
    fn test_greeter_goodbye_whitespace_only() {
        let greeter = Greeter::new();
        let result = greeter.goodbye("   ");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), GreeterError::EmptyName);
    }

    #[test]
    fn test_hello_function() {
        let result = hello("World").unwrap();
        assert_eq!(result, "Hello, World!");
    }

    #[test]
    fn test_hello_function_with_whitespace() {
        let result = hello("  Rust  ").unwrap();
        assert_eq!(result, "Hello, Rust!");
    }

    #[test]
    fn test_hello_function_empty() {
        let result = hello("");
        assert!(result.is_err());
    }

    #[test]
    fn test_goodbye_function() {
        let result = goodbye("World").unwrap();
        assert_eq!(result, "Goodbye, World!");
    }

    #[test]
    fn test_goodbye_function_with_whitespace() {
        let result = goodbye("  Rust  ").unwrap();
        assert_eq!(result, "Goodbye, Rust!");
    }

    #[test]
    fn test_goodbye_function_empty() {
        let result = goodbye("");
        assert!(result.is_err());
    }

    #[test]
    fn test_greeter_default() {
        let greeter = Greeter;
        let result = greeter.hello("Default").unwrap();
        assert_eq!(result, "Hello, Default!");
    }
}
