#!/bin/bash
# sync-skills.sh - Sync all skills from .agents/skills/ to .claude/skills/
# Usage: ./sync-skills.sh

set -e

echo "Syncing skills from .agents/skills/ to .claude/skills/..."
echo ""

cd ~/claude-setup

count=0
for skill_dir in .agents/skills/*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")

        # Skip if not a valid skill (no SKILL.md)
        if [ ! -f "$skill_dir/SKILL.md" ]; then
            echo "⚠ Skipping $skill_name (no SKILL.md found)"
            continue
        fi

        # Remove existing file/directory if it exists
        if [ -e ".claude/skills/$skill_name" ]; then
            rm -rf ".claude/skills/$skill_name"
        fi

        # Create symlink
        echo "→ $skill_name"
        cd .claude/skills
        ln -sf ../../.agents/skills/"$skill_name" "$skill_name"
        cd ~/claude-setup

        ((count++))
    fi
done

echo ""
echo "✅ Synced $count skills successfully!"
echo ""
echo "Skills are now available in .claude/skills/"
ls -la .claude/skills/ | grep '^l'
