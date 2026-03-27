//! Rust Bootstrap Template
//!
//! A modern Rust project template with testing, linting, formatting,
//! and quality tools built-in.
//!
//! # Examples
//!
//! ```
//! use rust_template::{Greeter, hello};
//!
//! // Using the convenience function
//! let message = hello("World").unwrap();
//! assert_eq!(message, "Hello, World!");
//!
//! // Using the Greeter struct
//! let greeter = Greeter::new();
//! let message = greeter.hello("Rust").unwrap();
//! assert_eq!(message, "Hello, Rust!");
//! ```

mod greeter;

pub use greeter::{goodbye, hello, Greeter, GreeterError};
