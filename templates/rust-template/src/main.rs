//! Main entry point for the Rust Template CLI application.
//!
//! Demonstrates clean code practices following the Rust API Guidelines.

use rust_template::hello;

fn main() {
    match hello("World") {
        Ok(message) => println!("{message}"),
        Err(e) => eprintln!("Error: {e}"),
    }
}
