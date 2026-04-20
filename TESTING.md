# Test Configuration for playarr

## Test Environments

This template supports testing in multiple environments:

### 1. Development Environment
- Use `nix develop` to enter the development shell
- All tools (cargo, rustc, clippy, etc.) are available
- Pre-commit hooks are automatically installed

### 2. CI Environment
- GitHub Actions workflows test on Ubuntu
- Tests run in isolated Nix environments
- Multiple Rust toolchain versions supported

### 3. Template Testing
- Special tests for template functionality
- Ensures downstream users can use this template
- Tests omnix compatibility

## Test Categories

### Unit Tests
- Located in `src/lib.rs` 
- Test individual functions and modules
- Run with `cargo test`

### Integration Tests
- Located in `tests/` directory
- Test interaction between components
- Run with `cargo test --test integration_tests`

### Nix Tests
- Flake check validation
- Build reproducibility
- Cross-platform compatibility

### Template Tests
- Template.nix functionality
- Omnix integration
- Downstream usability

## Running Tests Locally

```bash
# Full test suite
just test

# Individual test categories
just test-rust       # Only Rust tests
just test-template   # Only template tests
just ci             # Simulate full CI

# Manual testing
cargo test --all-features
nix flake check
nix build --no-link
```

## Expected Outputs

All tests should pass with exit code 0. Common test outputs:

```
✅ All tests passed!
✅ Template tests passed!
✅ CI simulation completed successfully!
```

## Troubleshooting

### Common Issues

1. **Flake check fails**: Ensure all .nix files are tracked by git
2. **Rust tests fail**: Check that dependencies are up to date
3. **Template tests fail**: Verify template.nix syntax is correct

### Debug Commands

```bash
# Verbose test output
cargo test -- --nocapture

# Detailed flake check
nix flake check --show-trace

# Template debugging
just check-template
```
