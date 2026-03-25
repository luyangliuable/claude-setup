#!/usr/bin/env bash
# Setup global rules symlink

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_SOURCE="$SCRIPT_DIR/global/rules"
RULES_TARGET="$HOME/.claude/rules/global"

echo "Setting up global rules..."

# Create parent directory if it doesn't exist
mkdir -p "$HOME/.claude/rules"

# Remove existing symlink or directory if it exists
if [ -L "$RULES_TARGET" ] || [ -e "$RULES_TARGET" ]; then
    echo "Removing existing $RULES_TARGET"
    rm -rf "$RULES_TARGET"
fi

# Create symlink
ln -sf "$RULES_SOURCE" "$RULES_TARGET"

if [ -L "$RULES_TARGET" ]; then
    echo "✓ Global rules symlinked: ~/.claude/rules/global -> $RULES_SOURCE"
else
    echo "✗ Failed to create symlink"
    exit 1
fi

echo "Setup complete!"
