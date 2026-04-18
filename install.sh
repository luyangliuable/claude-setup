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
    echo "[OK] Claude setup directory found at: $INSTALL_DIR"
else
    echo "[ERROR] Error: Installation directory not found: $INSTALL_DIR"
    echo "  Clone the repository first:"
    echo "  git clone https://github.com/luyangliuable/claude-config.git ~/claude-setup"
    exit 1
fi

# Check for .zshrc
if [[ ! -f "$ZSHRC" ]]; then
    echo "[ERROR] Error: .zshrc not found at: $ZSHRC"
    echo "  Create it first or use bash instead of zsh"
    exit 1
fi

# Add claude-setup to .zshrc
echo ""
echo "Configuring .zshrc..."

# Check if already configured in .zshrc
if grep -q "claude-setup/claude-profiles.sh" "$ZSHRC" 2>/dev/null; then
    echo "[OK] Claude setup already configured in .zshrc"
else
    echo "Adding claude-setup to .zshrc..."
    echo "" >> "$ZSHRC"
    echo "# Claude Code setup" >> "$ZSHRC"
    echo "source ${INSTALL_DIR}/claude-profiles.sh" >> "$ZSHRC"
    echo "source ${INSTALL_DIR}/claude-functions.sh" >> "$ZSHRC"
    echo "[OK] Added claude-setup to .zshrc"
fi

# Check for environment variables
echo ""
echo "Checking environment variables..."

if [[ -z "$ANTHROPIC_API_KEY" ]] && [[ -z "$OPENAI_API_KEY" ]]; then
    echo "⚠  Warning: No API keys found in environment"
    echo "  Set ANTHROPIC_API_KEY or OPENAI_API_KEY in your .zshrc:"
    echo "  export ANTHROPIC_API_KEY='your-key-here'"
    echo "  export OPENAI_API_KEY='your-key-here'  # For OpenAI-compatible endpoints"
else
    if [[ -n "$ANTHROPIC_API_KEY" ]]; then
        echo "[OK] ANTHROPIC_API_KEY is set"
    fi
    if [[ -n "$OPENAI_API_KEY" ]]; then
        echo "[OK] OPENAI_API_KEY is set"
    fi
fi

# Check for Claude CLI
echo ""
if command -v claude &> /dev/null; then
    echo "[OK] Claude CLI installed: $(command -v claude)"
else
    echo "⚠  Warning: Claude CLI not found"
    echo "  Install it from: https://docs.anthropic.com/claude/docs/claude-cli"
fi

# Check for skills
echo ""
if [[ -d "${INSTALL_DIR}/.agents/skills" ]]; then
    skill_count=$(find "${INSTALL_DIR}/.agents/skills" -maxdepth 1 -type d | wc -l | tr -d ' ')
    skill_count=$((skill_count - 1))  # Subtract .agents/skills itself
    echo "[OK] ${skill_count} skills found"

    ls -1 "${INSTALL_DIR}/.agents/skills" | while read -r skill; do
        [[ -d "${INSTALL_DIR}/.agents/skills/$skill" ]] && echo "  - $skill"
    done
else
    echo "⚠  Warning: No skills directory found"
fi

# Setup CLAUDE.md symlink
echo ""
echo "Setting up CLAUDE.md symlink..."
if [[ -L "${HOME}/CLAUDE.md" ]]; then
    echo "[OK] CLAUDE.md symlink already exists"
elif [[ -f "${HOME}/CLAUDE.md" ]]; then
    echo "⚠  Warning: CLAUDE.md exists as a regular file (not a symlink)"
    echo "  Move it and rerun install if you want to use the global version"
else
    ln -sf "${INSTALL_DIR}/global/CLAUDE.md" "${HOME}/CLAUDE.md"
    echo "[OK] Created CLAUDE.md symlink"
fi

# Setup global rules symlink
echo ""
echo "Setting up global rules..."
"${INSTALL_DIR}/setup-rules.sh"

# Sync skills
echo ""
echo "Syncing skills..."
"${INSTALL_DIR}/sync-skills.sh"

# List available profiles
echo ""
echo "Available profiles:"
ls -1 "${INSTALL_DIR}/profiles" 2>/dev/null | grep '\.json$' | sed 's/\.json$//' | sed 's/^/  - /' || echo "  (none)"

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Next steps:"
echo "  1. Reload your shell: source ~/.zshrc"
echo "  2. Try a command: claude-profile list"
echo "  3. Test a profile: cgs (GenAI Studio)"
echo ""
echo "For more information, see: ${INSTALL_DIR}/README.md"
