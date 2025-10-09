# https://github.com/casey/just

alias cc := clean-cargo

# set shell := ["nu", "-c"]
release_d := "both"
msg_d := "!!MISSING MESSAGE!!"

# ------------------------------ BASICS -----------------------------#
default:
  @just --choose

message msg=msg_d:
  @echo "{{msg}}"

# ------------------------------ BUILD -----------------------------#
# Builds binary if passed some form of `windows` after run then it will run in windows mode
[confirm]
[parallel]
build release=release_d: clean check-flake
  @just check-cargo
  {{ if release =~ "debug" { "just build-debug" } else { "just build-release" } }}

build-debug:
  @nix develop -c cargo build

build-release:
  @nix develop -c cargo build --release

# DOES NOT CLEAN: Builds binary if passed some form of `windows` after run then it will run in windows mode
[parallel]
build-now release=release_d: check-flake
  @just check-cargo
  {{ if release =~ "debug" { "just build-debug" } else { "just build-release" } }}

# ------------------------------ RUN -----------------------------#
[private]
run-linux release=release_d:
  {{ if release =~ "debug" { "just run-debug" } else { "just run-release" } }}

[private]
run-debug:
  -nix develop -c cargo run

[private]
run-release:
  -nix develop -c cargo run

# ------------------------------ CHECKS -----------------------------#
# Run Nix Flake Check inside linux devShell
check-flake: 
  @just message "Checking Flake (via Linux devShell)"
  nix flake check
  @just message "Flake Check COMPLETE (via Linux devShell)"

# Run Cargo Check inside linux devShell
check-cargo:
  @just message "Checking Cargo Pkg (via Linux devShell)"
  nix develop -c cargo check --all-targets --target-dir target/just/check
  @just message "Cargo Pkg Check COMPLETE (via Linux devShell)"

# ------------------------------ CLEANING -----------------------------#
# Clean repo in preperation for windows build
[parallel]
clean: clean-nix clean-cargo
  @just message "Everything Cleaned"

[private]
clean-nix:
  @just message "Cleaning Nix"
  nix-store --gc --quiet
  @just message "Nix Cleaned"

# [private]
clean-cargo:
  @just message "Cleaning Cargo"
  nix shell --inputs-from . nixpkgs#cargo -c cargo clean
  rm -rf ~/.cargo/
  @just message "Cargo Cleaned"

# ------------------------------ DOCS -----------------------------#
# generate all docs (release + debug)
[parallel]
all-basic-docs: docs-basic docs-basic-release 
  @just message "All docs (basic) Generated!"

# generate all workspace docs (release + debug)
[parallel]
all-workspace-docs: docs-workspace docs-workspace-release
  @just message "All docs (workspace) Generated!"

# generate all workspace docs (release + debug)
[parallel]
all-docs: check-cargo && all-basic-docs all-workspace-docs
  @just message "Generating ALL docs"

level_d := "no-deps"
version_d := "debug"
open_d := "no"

[private]
docs level=level_d version=version_d open=open_d:
  @just message "Generating Docs with the following details..."
  @just message "Release Version: {{version}}"
  @just message "Docs Depth: {{level}}"
  @just message "Will Open?: {{open}}"

  nix develop -c cargo doc {{ if level =~ "full" { "--workspace" } else { "--no-deps" } }} {{ if version =~ "release" { "--release --target-dir target/docs/release" } else { "--target-dir target/docs/debug" } }} {{ if open == "yes" { "--open" } else { "" } }}

# generate basic docs (debug) 
docs-basic: docs
  @just message "Basic Docs (debug) Generated!"

# generate workspace docs (debug) 
docs-workspace: (docs "full" "debug")
  @just message "Workspace Docs (debug) Generated!"

# generate basic docs (release) 
docs-basic-release: (docs "no-deps" "release")
  @just message "Basic Docs (release) Generated!"

# generate workspace docs (release) 
docs-workspace-release: (docs "full" "release")
  @just message "Workspace Docs (release) Generated!"

# open basic docs (debug) 
open-docs-basic: && (docs "no-deps" "debug" "yes")
  @just message "Opening Basic Docs (debug)"

# open workspace docs (debug) 
open-docs-workspace: && (docs "full" "debug" "yes")
  @just message "Opening Workspace Docs (debug)"

# open basic docs (release) 
open-docs-basic-release: && (docs "no-deps" "release" "yes")
  @just message "Opening Basic Docs (release)"

# open workspace docs (release) 
open-docs-workspace-release: && (docs "full" "release" "yes")
  @just message "Opening Workspace Docs (release)"

# ------------------------------ TESTING ---------------------------#
# Run all Rust tests (debug and release)
[parallel]
test: test-rust-debug test-rust-release
  @just message "All Rust tests complete!"

test-rust-debug:
  @just message "Running Rust tests (debug)"
  nix develop -c cargo test --all-targets --target-dir target/just/test/debug

test-rust-release:
  @just message "Running Rust tests (release)"
  nix develop -c cargo test --release --all-targets --target-dir target/just/test/release

# Run tests with coverage
test-coverage:
  @just message "Running tests with coverage"
  nix develop -c cargo tarpaulin --all-targets --target-dir target/coverage --out Html --output-dir target/coverage/html || echo "Tarpaulin not available, skipping coverage"

# Run unit tests only
test-unit:
  @just message "Running unit tests only"
  nix develop -c cargo test tests::unit --target-dir target/just/test/unit

# Run integration tests only
test-integration:
  @just message "Running integration tests only"
  nix develop -c cargo test tests::integration --target-dir target/just/test/integration

# Run property-based tests only
test-property:
  @just message "Running property-based tests only"
  nix develop -c cargo test tests::property --target-dir target/just/test/property

# Run benchmarks
bench:
  @just message "Running benchmarks"
  nix develop -c cargo bench --target-dir target/just/bench

# Run all test types including benchmarks
test-all: test test-unit test-integration test-property bench
  @just message "All tests and benchmarks complete!"

# Run tests in separate directory structure (our new approach)
test-separated:
  @just message "Running separated test structure"
  nix develop -c cargo test --test mod --target-dir target/just/test/separated
