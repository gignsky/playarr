#!/usr/bin/env bash
set -euo pipefail

echo "🧪 Running template-specific tests..."

# Test that template.nix doesn't break the build
echo "📋 Testing template.nix inclusion..."
nix flake check --impure --no-build

# Test that omnix can process the template
echo "🛠️  Testing omnix compatibility..."
nix --accept-flake-config run github:juspay/omnix -- ci --no-build

echo "✅ Template tests passed!"
