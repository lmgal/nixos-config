#!/usr/bin/env bash

# Install Git hooks from the repository
# Run this script after cloning the repository

REPO_ROOT=$(git rev-parse --show-toplevel)
HOOKS_DIR="$REPO_ROOT/hooks"
GIT_HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo "Installing Git hooks..."

# Copy pre-commit hook
if [[ -f "$HOOKS_DIR/pre-commit" ]]; then
    cp "$HOOKS_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
    chmod +x "$GIT_HOOKS_DIR/pre-commit"
    echo "✓ Installed pre-commit hook"
else
    echo "✗ pre-commit hook not found"
fi

echo "Git hooks installation complete!"