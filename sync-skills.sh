#!/bin/bash
# sync-skills.sh - Sync all skills from .agents/skills/ to ~/.claude/skills/
# Usage: ./sync-skills.sh

set -e

SOURCE_DIR="${HOME}/claude-setup/.agents/skills"
TARGET_DIR="${HOME}/.claude/skills"

echo "Syncing skills from .agents/skills/ to .claude/skills/..."
echo ""

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

cd "$SOURCE_DIR"

count=0
for skill_dir in */; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")

        # Skip if not a valid skill (no SKILL.md)
        if [ ! -f "$skill_dir/SKILL.md" ]; then
            echo "⚠ Skipping $skill_name (no SKILL.md found)"
            continue
        fi

        # Remove existing file/directory if it exists
        if [ -e "$TARGET_DIR/$skill_name" ]; then
            rm -rf "$TARGET_DIR/$skill_name"
        fi

        # Create symlink
        echo "→ $skill_name"
        ln -sf "$SOURCE_DIR/$skill_name" "$TARGET_DIR/$skill_name"

        ((count++))
    fi
done

echo ""
echo "✅ Synced $count skills successfully!"
echo ""
echo "Skills are now available in ~/.claude/skills/"
ls -la "$TARGET_DIR" | grep '^l'
