#!/bin/bash
# add-skill.sh - Automated skill installation for claude-setup
# Usage: ./add-skill.sh <github-url>

set -e

if [ -z "$1" ]; then
    echo "Usage: ./add-skill.sh <github-url>"
    echo "Example: ./add-skill.sh https://github.com/openclaw/openclaw/tree/HEAD/skills/slack"
    exit 1
fi

GITHUB_URL="$1"
SKILL_NAME=$(basename "$GITHUB_URL")

echo "Installing skill: $SKILL_NAME"
echo "From: $GITHUB_URL"
echo ""

# 1. Install globally
echo "[1/6] Installing skill globally..."
pnpm dlx skills add "$GITHUB_URL"

# 2. Copy to claude-setup
echo "[2/6] Copying to claude-setup..."
cp -r ~/.claude/skills/"$SKILL_NAME" ~/claude-setup/.agents/skills/

# 3. Create symlink
echo "[3/6] Creating symlink..."
cd ~/claude-setup/.claude/skills
rm -rf "$SKILL_NAME"  # Remove if exists (directory or link)
ln -sf ../../.agents/skills/"$SKILL_NAME" "$SKILL_NAME"

# 4. Verify
echo "[4/6] Verifying installation..."
if [ -L ~/claude-setup/.claude/skills/"$SKILL_NAME" ]; then
    echo "✓ Symlink created successfully"
    readlink ~/claude-setup/.claude/skills/"$SKILL_NAME"
else
    echo "✗ Symlink creation failed"
    exit 1
fi

# 5. Extract GitHub source for skills-lock.json
echo "[5/6] Updating skills-lock.json..."
SOURCE_PATH=$(echo "$GITHUB_URL" | sed 's|https://github.com/||' | sed 's|/tree/HEAD/skills/.*||')
cd ~/claude-setup

# Update skills-lock.json using jq
if command -v jq &> /dev/null; then
    HASH=$(shasum -a 256 .agents/skills/"$SKILL_NAME"/SKILL.md | cut -d' ' -f1)
    jq --arg name "$SKILL_NAME" --arg source "$SOURCE_PATH" --arg hash "$HASH" \
        '.skills[$name] = {"source": $source, "sourceType": "github", "computedHash": $hash}' \
        skills-lock.json > skills-lock.json.tmp && mv skills-lock.json.tmp skills-lock.json
    echo "✓ Updated skills-lock.json"
else
    echo "⚠ jq not installed - please manually update skills-lock.json"
fi

# 6. Commit
echo "[6/6] Committing to git..."
git add .agents/skills/"$SKILL_NAME" .claude/skills/"$SKILL_NAME" skills-lock.json
git commit -m "Add $SKILL_NAME skill from $SOURCE_PATH"

echo ""
echo "✅ Skill '$SKILL_NAME' installed successfully!"
echo ""
echo "To use the skill:"
echo "  cd ~/claude-setup"
echo "  c  # or use your profile alias (cpa, cpb, cmy, etc.)"
echo "  # In Claude: /$SKILL_NAME"
