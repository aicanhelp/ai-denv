//! Integration tests for the rust-template library.
//!
//! These tests verify the public API behavior of the greeter module.

use rust_template::{goodbye, hello, Greeter, GreeterError};

#[test]
fn test_hello_function_valid_name() {
    let result = hello("World").unwrap();
    assert_eq!(result, "Hello, World!");
}

#[test]
fn test_hello_function_with_whitespace() {
    let result = hello("  Rust  ").unwrap();
    assert_eq!(result, "Hello, Rust!");
}

#[test]
fn test_hello_function_empty_string() {
    let result = hello("");
    assert!(result.is_err());
    match result {
        Err(GreeterError::EmptyName) => (),
        _ => panic!("Expected EmptyName error"),
    }
}

#[test]
fn test_hello_function_whitespace_only() {
    let result = hello("   ");
    assert!(result.is_err());
    assert_eq!(result.unwrap_err(), GreeterError::EmptyName);
}

#[test]
fn test_goodbye_function_valid_name() {
    let result = goodbye("World").unwrap();
    assert_eq!(result, "Goodbye, World!");
}

#[test]
fn test_goodbye_function_with_whitespace() {
    let result = goodbye("  Rust  ").unwrap();
    assert_eq!(result, "Goodbye, Rust!");
}

#[test]
fn test_goodbye_function_empty_string() {
    let result = goodbye("");
    assert!(result.is_err());
    match result {
        Err(GreeterError::EmptyName) => (),
        _ => panic!("Expected EmptyName error"),
    }
}

#[test]
fn test_goodbye_function_whitespace_only() {
    let result = goodbye("   ");
    assert!(result.is_err());
}

#[test]
fn test_greeter_struct_api() {
    let greeter = Greeter::new();

    let hello_result = greeter.hello("Integration").unwrap();
    assert_eq!(hello_result, "Hello, Integration!");

    let goodbye_result = greeter.goodbye("Test").unwrap();
    assert_eq!(goodbye_result, "Goodbye, Test!");
}

#[test]
fn test_greeter_error_display() {
    let error = GreeterError::EmptyName;
    let error_msg = format!("{error}");
    assert_eq!(error_msg, "Name must be a non-empty string");
}

#[test]
fn test_greeter_multiple_instances() {
    let greeter1 = Greeter::new();
    let greeter2 = Greeter::new();

    let msg1 = greeter1.hello("One").unwrap();
    let msg2 = greeter2.hello("Two").unwrap();

    assert_eq!(msg1, "Hello, One!");
    assert_eq!(msg2, "Hello, Two!");
}
