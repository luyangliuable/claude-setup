#!/bin/bash
# install.sh
# Installation script for Claude Code configuration

set -e

INSTALL_DIR="${HOME}/claude-setup"
ZSHRC="${HOME}/.zshrc"

echo "=== Claude Code Configuration Installer ==="
echo ""

# Check if already installed
if [[ -d "$INSTALL_DIR" ]]; then
    echo "✓ Claude setup directory found at: $INSTALL_DIR"
else
    echo "✗ Error: Installation directory not found: $INSTALL_DIR"
    echo "  Clone the repository first:"
    echo "  git clone https://github.com/luyangliuable/claude-config.git ~/claude-setup"
    exit 1
fi

# Check for .zshrc
if [[ ! -f "$ZSHRC" ]]; then
    echo "✗ Error: .zshrc not found at: $ZSHRC"
    echo "  Create it first or use bash instead of zsh"
    exit 1
fi

# Check if already sourced
if grep -q "claude-profiles.sh" "$ZSHRC" 2>/dev/null; then
    echo "✓ claude-profiles.sh already sourced in .zshrc"
else
    echo ""
    echo "Adding claude-profiles.sh to .zshrc..."

    # Add source line to .zshrc
    echo "" >> "$ZSHRC"
    echo "# Claude Code profile management" >> "$ZSHRC"
    echo "source ${INSTALL_DIR}/claude-profiles.sh" >> "$ZSHRC"

    echo "✓ Added to .zshrc"
fi

# Check for environment variables
echo ""
echo "Checking environment variables..."

if [[ -z "$ANTHROPIC_API_KEY" ]] && [[ -z "$OPENAI_API_KEY" ]]; then
    echo "⚠  Warning: No API keys found in environment"
    echo "  Set ANTHROPIC_API_KEY or OPENAI_API_KEY in your .zshrc:"
    echo "  export ANTHROPIC_API_KEY='your-key-here'"
    echo "  export OPENAI_API_KEY='your-key-here'  # For GenAI Studio"
else
    if [[ -n "$ANTHROPIC_API_KEY" ]]; then
        echo "✓ ANTHROPIC_API_KEY is set"
    fi
    if [[ -n "$OPENAI_API_KEY" ]]; then
        echo "✓ OPENAI_API_KEY is set"
    fi
fi

# Check for Claude CLI
echo ""
if command -v claude &> /dev/null; then
    echo "✓ Claude CLI installed: $(command -v claude)"
else
    echo "⚠  Warning: Claude CLI not found"
    echo "  Install it from: https://docs.anthropic.com/claude/docs/claude-cli"
fi

# Check for skills
echo ""
if [[ -d "${INSTALL_DIR}/.agents/skills" ]]; then
    skill_count=$(find "${INSTALL_DIR}/.agents/skills" -maxdepth 1 -type d | wc -l | tr -d ' ')
    skill_count=$((skill_count - 1))  # Subtract .agents/skills itself
    echo "✓ ${skill_count} skills found"

    ls -1 "${INSTALL_DIR}/.agents/skills" | while read -r skill; do
        [[ -d "${INSTALL_DIR}/.agents/skills/$skill" ]] && echo "  - $skill"
    done
else
    echo "⚠  Warning: No skills directory found"
fi

# Load profiles
echo ""
echo "Loading profiles..."
source "${INSTALL_DIR}/claude-profiles.sh"

# List available profiles
echo ""
echo "Available profiles:"
claude-profile list | grep -E "^  -" || echo "  (none)"

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Next steps:"
echo "  1. Reload your shell: source ~/.zshrc"
echo "  2. Try a command: cgs --version"
echo "  3. List profiles: claude-profile list"
echo "  4. Add custom profile: claude-profile add my-custom"
echo ""
echo "For more information, see: ${INSTALL_DIR}/README.md"
