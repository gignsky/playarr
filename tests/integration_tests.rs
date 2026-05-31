use playarr::{format_greeting, get_name_or_default, is_verbose_mode, Args};

#[test]
fn integration_test_greeting_functionality() {
    // Test the complete greeting functionality
    let args_with_name = Args {
        verbose: false,
        name: Some("Integration".to_string()),
    };

    let greeting = format_greeting(args_with_name.name.clone());
    assert_eq!(greeting, "Hello Integration (from playarr)!");
    assert!(!is_verbose_mode(&args_with_name));
    assert_eq!(get_name_or_default(&args_with_name), "Integration");
}

#[test]
fn integration_test_verbose_mode() {
    let args_verbose = Args {
        verbose: true,
        name: None,
    };

    assert!(is_verbose_mode(&args_verbose));
    assert_eq!(get_name_or_default(&args_verbose), "world");

    let greeting = format_greeting(args_verbose.name.clone());
    assert_eq!(greeting, "Hello world (from playarr)!");
}

#[test]
fn integration_test_edge_cases() {
    // Test with empty string name (should still work)
    let greeting = format_greeting(Some("".to_string()));
    assert_eq!(greeting, "Hello  (from playarr)!");

    // Test with None name
    let greeting = format_greeting(None);
    assert_eq!(greeting, "Hello world (from playarr)!");
}
