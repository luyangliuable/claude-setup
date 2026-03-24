# Skill Management Guide

## Overview

This repository includes a skill management system that allows you to:
1. Install skills from GitHub repositories
2. Create custom skills
3. Sync skills across the codebase
4. Track skill versions

## Directory Structure

```
~/claude-setup/
├── .agents/skills/          # Version-controlled skill definitions
│   ├── code-reviewer/
│   ├── list-models/        # Custom skill
│   └── ...
├── .claude/skills/          # Symlinks (not tracked in git)
│   ├── code-reviewer -> ../../.agents/skills/code-reviewer
│   ├── list-models -> ../../.agents/skills/list-models
│   └── ...
├── add-skill.sh            # Install skill from GitHub
├── sync-skills.sh          # Sync all skills
└── skills-lock.json        # Track skill sources and versions
```

## Quick Start

### Install Skill from GitHub

```bash
cd ~/claude-setup
./add-skill.sh <github-url>

# Example:
./add-skill.sh https://github.com/openclaw/openclaw/tree/HEAD/skills/slack
```

This script will:
1. Install globally via `pnpm dlx skills add`
2. Copy to `.agents/skills/`
3. Create symlink in `.claude/skills/`
4. Update `skills-lock.json`
5. Commit to git

### Sync Existing Skills

After cloning or pulling changes:

```bash
cd ~/claude-setup
./sync-skills.sh
```

This creates symlinks for all skills in `.agents/skills/`.

### Create Custom Skill

```bash
cd ~/claude-setup
mkdir -p .agents/skills/my-skill
nano .agents/skills/my-skill/SKILL.md

# Add content following the SKILL.md format (see below)

# Create symlink
./sync-skills.sh

# Update skills-lock.json
HASH=$(shasum -a 256 .agents/skills/my-skill/SKILL.md | cut -d' ' -f1)
# Add entry to skills-lock.json manually or via jq

# Commit
git add .agents/skills/my-skill skills-lock.json
git commit -m "Add my-skill custom skill"
```

## SKILL.md Format

```markdown
---
name: skill-name
description: What this skill does
license: MIT
allowed-tools: Read, Grep, Bash
metadata:
  author: your-name
  version: "1.0.0"
  domain: category
  triggers: keywords, trigger, phrases
---

# Skill Name

## When to Use
- Use case 1
- Use case 2

## Instructions
What Claude should do.
```

## Using Skills

```bash
cd ~/claude-setup
cgs  # or cdh, c, etc. (profile alias)

# In Claude:
/skill-name
```

## Available Custom Skills

### list-models
Query API endpoints to list available models (OpenAI, LiteLLM, GenAI Studio).

```
Usage: /list-models
```

Prompts for:
- API Endpoint URL
- API Key
- Auth Type (Bearer or x-api-key)

## Troubleshooting

### Symlinks not working
```bash
cd ~/claude-setup
./sync-skills.sh
```

### Skill not appearing
1. Check `.agents/skills/<name>/SKILL.md` exists
2. Run `./sync-skills.sh`
3. Restart Claude session

### Update skill from GitHub
```bash
pnpm dlx skills add <github-url>  # Re-install
cp -r ~/.claude/skills/<name> ~/claude-setup/.agents/skills/
./sync-skills.sh
git add .agents/skills/<name> skills-lock.json
git commit -m "Update <name> skill"
```

## Best Practices

1. **Always use scripts** - Use `add-skill.sh` and `sync-skills.sh` instead of manual commands
2. **Track in skills-lock.json** - Document skill sources for reproducibility
3. **Use relative symlinks** - Ensures portability across systems
4. **Commit .agents/skills/** - Version control skill definitions
5. **Don't commit .claude/skills/** - Symlinks are recreated by sync script
