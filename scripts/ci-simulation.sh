#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Running CI simulation..."

# Run the same checks that CI would run
echo "🔄 Simulating GitHub Actions CI..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository!"
    exit 1
fi

# Ensure clean working directory for accurate CI simulation
if [[ -n $(git status --porcelain) ]]; then
    echo "⚠️  Working directory is not clean. CI simulation may not be accurate."
    echo "   Consider committing or stashing changes first."
fi

# Run cargo-based CI checks
echo "🦀 Running Cargo CI checks..."
cargo check --all-targets --all-features
cargo test --all-features
cargo clippy --all-targets --all-features -- -D warnings
cargo fmt -- --check

# Run nix-based CI checks
echo "❄️  Running Nix CI checks..."
NIX_SKIP_TEMPLATE=1 nix flake check --impure --no-build

# Test building
echo "🏗️  Testing build..."
nix build --no-link

# Test omnix
echo "🛠️  Testing omnix..."
nix --accept-flake-config run github:juspay/omnix -- ci --no-build

echo "✅ CI simulation completed successfully!"
