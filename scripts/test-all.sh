#!/usr/bin/env bash
set -euo pipefail

echo "🧪 Running comprehensive Rust project tests..."

# Ensure we don't miss any nix files
echo "📁 Adding any untracked .nix files..."
git ls-files --others --exclude-standard -- '*.nix' | xargs -r git add -v

# Run cargo tests
echo "🦀 Running Cargo tests..."
cargo test --all-features

# Run cargo check
echo "🔍 Running Cargo check..."
cargo check --all-targets --all-features

# Run clippy
echo "📎 Running Clippy..."
cargo clippy --all-targets --all-features -- -D warnings

# Run rustfmt check
echo "🎨 Checking Rust formatting..."
cargo fmt -- --check

# Run nix formatting check
echo "❄️📝 Checking Nix formatting..."
find . -name "*.nix" -not -path "./result*" | xargs nixpkgs-fmt --check

# Run nix flake check (skip template for regular tests)
echo "❄️  Running Nix flake check..."
NIX_SKIP_TEMPLATE=1 nix flake check --impure

echo "✅ All tests passed!"
