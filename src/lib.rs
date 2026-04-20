/// A simple library for demonstration purposes
use clap::Parser;

#[derive(Parser, Debug, Clone)]
#[clap(author = "Maxwell Rupp", version, about)]
/// Application configuration
pub struct Args {
    /// whether to be verbose
    #[arg(short = 'v')]
    pub verbose: bool,

    /// an optional name to greet
    #[arg()]
    pub name: Option<String>,
}

/// Formats a greeting message based on the provided name
pub fn format_greeting(name: Option<String>) -> String {
    format!(
        "Hello {} (from playarr)!",
        name.unwrap_or_else(|| "world".to_string())
    )
}

/// Checks if verbose mode is enabled
pub fn is_verbose_mode(args: &Args) -> bool {
    args.verbose
}

/// Gets the name from args or returns a default
pub fn get_name_or_default(args: &Args) -> String {
    args.name.clone().unwrap_or_else(|| "world".to_string())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_format_greeting_with_name() {
        let result = format_greeting(Some("Alice".to_string()));
        assert_eq!(result, "Hello Alice (from playarr)!");
    }

    #[test]
    fn test_format_greeting_without_name() {
        let result = format_greeting(None);
        assert_eq!(result, "Hello world (from playarr)!");
    }

    #[test]
    fn test_is_verbose_mode_true() {
        let args = Args {
            verbose: true,
            name: None,
        };
        assert!(is_verbose_mode(&args));
    }

    #[test]
    fn test_is_verbose_mode_false() {
        let args = Args {
            verbose: false,
            name: None,
        };
        assert!(!is_verbose_mode(&args));
    }

    #[test]
    fn test_get_name_or_default_with_name() {
        let args = Args {
            verbose: false,
            name: Some("Bob".to_string()),
        };
        assert_eq!(get_name_or_default(&args), "Bob");
    }

    #[test]
    fn test_get_name_or_default_without_name() {
        let args = Args {
            verbose: false,
            name: None,
        };
        assert_eq!(get_name_or_default(&args), "world");
    }

    #[test]
    fn test_args_debug_format() {
        let args = Args {
            verbose: true,
            name: Some("Test".to_string()),
        };
        let debug_str = format!("{:?}", args);
        assert!(debug_str.contains("verbose: true"));
        assert!(debug_str.contains("Test"));
    }
}
