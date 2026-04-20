#!/usr/bin/env bash
set -euo pipefail

branch="$(git rev-parse --abbrev-ref HEAD)"

# if [[ "$branch" == "main" || "$branch" == "develop" ]]; then
if "$branch" == "main"; then
  echo "Running nix flake check on branch: $branch"
  NIX_SKIP_TEMPLATE=1 nix flake check --impure --no-build
else
  echo "Skipping nix flake check on branch: $branch"
fi
