# Claude Code Configuration

Centralized configuration repository for Claude Code setup, including skills, profiles, and extensible profile management system.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
  - [Installation](#installation)
  - [Source Profile Management](#source-profile-management)
  - [Using Profiles](#using-profiles)
- [Profile Management](#profile-management)
  - [List Available Profiles](#list-available-profiles)
  - [Create Custom Profile](#create-custom-profile)
  - [Edit Existing Profile](#edit-existing-profile)
  - [Remove Profile](#remove-profile)
  - [Reload Profiles](#reload-profiles)
- [Loop Commands](#loop-commands)
- [Skills Management](#skills-management)
  - [Installed Skills](#installed-skills)
  - [Using Skills](#using-skills)
  - [Installing Skills from GitHub](#installing-skills-from-github)
  - [Creating Custom Skills](#creating-custom-skills)
  - [Syncing Skills](#syncing-skills)
  - [Updating Skills](#updating-skills)
- [Profile Configuration](#profile-configuration)
- [CLAUDE.md](#claudemd)
- [Rules System](#rules-system)
- [Promptbank](#promptbank)
- [Advanced Usage](#advanced-usage)
  - [Custom System Prompt](#custom-system-prompt)
  - [Environment-Specific Profiles](#environment-specific-profiles)
  - [Model Flags](#model-flags)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Repository Structure](#repository-structure)
- [License](#license)

## Overview

This repository contains:
- **Claude Code Skills**: 26 installed and ready-to-use skills (design/UI, code quality, development tools, PR review)
- **Profile Management**: Extensible shell functions for switching between Claude profiles
- **Profile Configurations**: JSON files defining different Claude Code environments
- **CLAUDE.md**: Global coding standards and project instructions
- **Skill Management System**: Install from GitHub, create custom skills, sync across codebase

## Quick Start

### Installation

```bash
git clone https://github.com/luyangliuable/claude-config.git ~/claude-setup
```

### Source Profile Management

Add this line to your `~/.zshrc`:

```bash
source ~/claude-setup/claude-profiles.sh
```

Then reload your shell:

```bash
source ~/.zshrc
```

### Using Profiles

```bash
# Default Claude (uses current environment)
c

# Profile A (example profile)
cpa
cpa -h    # Use Haiku model
cpa -g    # Use GPT model

# Profile B (example profile)
cpb
cpb -h    # Use Haiku model
cpb -c    # Use Sonnet model
```

## Profile Management

### List Available Profiles

```bash
claude-profile list
```

Output:
```
Available Claude profiles:

  - profile-a (cpa, lcpa)
      API: https://api.example.com
      Model: aipe-bedrock-claude-4-5-sonnet

  - profile-b (cpb, lcpb)
      API: https://api.other.com
      Model: claude-opus-4-6
```

### Create Custom Profile

```bash
claude-profile add my-custom
# Creates profiles/my-custom.json from template

claude-profile edit my-custom
# Edit the profile in your $EDITOR

# Use your custom profile
cmy           # Regular mode
lcmy 5 "task" # Loop mode with 5 min timeout
```

### Edit Existing Profile

```bash
claude-profile edit my-profile
```

### Remove Profile

```bash
claude-profile remove my-custom
```

### Reload Profiles

```bash
claude-profile reload
```

## Loop Commands

Loop commands run Claude in a continuous loop with automatic restart on completion:

```bash
# Usage: l<profile> [timeout_minutes] ["task description"]

lc                    # Default profile, 1 min timeout
lcpa 5                # Profile A, 5 min timeout
lcpb 10 "monitor PR"  # Profile B, 10 min timeout, custom task
```

**Default Loop Task:**
> Monitor the current PR using gh pr view. Run npm build, test, lint and format. Fix any failures and push. Use the code-quality skill when fixing code. Iterate until all checks pass.

## Skills Management

This repository includes a comprehensive skill management system that allows you to:
- Install skills from GitHub repositories
- Create custom skills
- Sync skills across the codebase
- Track skill versions via `skills-lock.json`

**Directory Structure:**
```
~/claude-setup/
├── .agents/skills/          # Version-controlled skill definitions
│   ├── code-reviewer/
│   ├── list-models/        # Custom skill
│   └── ...
├── .claude/skills/          # Symlinks (not tracked in git)
│   ├── code-reviewer -> ../../.agents/skills/code-reviewer
│   └── ...
├── add-skill.sh            # Install skill from GitHub
├── sync-skills.sh          # Sync all skills
└── skills-lock.json        # Track skill sources and versions
```

### Installed Skills

All skills from `~/.claude/skills/` are included and organized by category:

#### Design & UI Skills (17)

1. **adapt** - Adapt designs across screen sizes, devices, contexts, or platforms
2. **animate** - Add purposeful animations, micro-interactions, and motion effects
3. **audit** - Comprehensive interface quality audit (accessibility, performance, theming, responsive)
4. **bolder** - Amplify safe or boring designs to be more visually interesting
5. **clarify** - Improve unclear UX copy, error messages, microcopy, and labels
6. **colorize** - Add strategic color to monochromatic interfaces
7. **critique** - Evaluate design effectiveness from UX perspective (visual hierarchy, IA, emotional resonance)
8. **delight** - Add moments of joy, personality, and unexpected touches
9. **distill** - Strip designs to essence by removing unnecessary complexity
10. **extract** - Extract reusable components and patterns into design system
11. **frontend-design** - Create distinctive, production-grade interfaces with high design quality
12. **normalize** - Normalize design to match design system for consistency
13. **onboard** - Design or improve onboarding flows and first-time user experiences
14. **optimize** - Improve interface performance (loading, rendering, animations, bundle size)
15. **polish** - Final quality pass fixing alignment, spacing, consistency issues
16. **quieter** - Tone down overly bold or visually aggressive designs
17. **teach-impeccable** - One-time setup gathering design context for persistent guidelines

#### Code Quality & Review Skills (3)

18. **code-quality** - Comprehensive code quality guide (Clean Code, SOLID, DRY, CUPID, Coupling, Connascence, Code Smells)
19. **code-reviewer** - Analyze code diffs for bugs, vulnerabilities (SQL injection, XSS), code smells, N+1 queries
20. **react-best-practices** - React and Next.js performance optimization guidelines from Vercel Engineering

#### Development Tools (5)

21. **drawio** - AI-powered Draw.io diagram generation with Design System and real-time browser preview
22. **emacs-elisp-debugging** - Strategies for debugging Emacs Lisp code and Common Lisp compatibility
23. **find-skills** - Discover and install agent skills (use when looking for new functionality)
24. **github-actions** - Comprehensive GitHub Actions examples (workflows, jobs, Docker, OIDC, deployment)
25. **harden** - Improve interface resilience (error handling, i18n, text overflow, edge cases)

#### PR/Review Skills (1)

26. **fetch-unresolved-comments** - Fetch unresolved PR review comments via GitHub GraphQL API

### Using Skills

Skills are invoked using the `/` prefix in Claude Code:

```bash
# Design skills
/frontend-design     # Create production-grade interface
/audit              # Comprehensive interface audit
/polish             # Final quality pass

# Code quality
/code-quality       # Apply Clean Code principles
/code-reviewer      # Review PR for bugs/vulnerabilities
/react-best-practices  # Optimize React/Next.js performance

# Development tools
/drawio             # Generate Draw.io diagrams
/github-actions     # GitHub Actions examples
/find-skills        # Discover more skills

# PR management
/fetch-unresolved-comments  # Get unresolved PR comments
```

Skills are automatically available to Claude Code when working in projects.

### Installing Skills from GitHub

Install a new skill from a GitHub repository:

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

### Creating Custom Skills

Create your own custom skill:

```bash
cd ~/claude-setup
mkdir -p .agents/skills/my-skill
nano .agents/skills/my-skill/SKILL.md

# Add content following the SKILL.md format:
# ---
# name: my-skill
# description: What this skill does
# license: MIT
# allowed-tools: Read, Grep, Bash
# metadata:
#   author: your-name
#   version: "1.0.0"
#   domain: category
#   triggers: keywords, trigger, phrases
# ---
#
# # Skill Name
#
# ## When to Use
# - Use case 1
# - Use case 2
#
# ## Instructions
# What Claude should do.

# Create symlink
./sync-skills.sh

# Update skills-lock.json
HASH=$(shasum -a 256 .agents/skills/my-skill/SKILL.md | cut -d' ' -f1)
# Add entry to skills-lock.json manually or via jq

# Commit
git add .agents/skills/my-skill skills-lock.json
git commit -m "Add my-skill custom skill"
```

**Available Custom Skills:**
- **list-models** - Query API endpoints to list available models (OpenAI, LiteLLM, GenAI Studio)

### Syncing Skills

After cloning or pulling changes, sync skills to create symlinks:

```bash
cd ~/claude-setup
./sync-skills.sh
```

This creates symlinks for all skills in `.agents/skills/`.

### Updating Skills

Skills in this repository are copied from `~/.claude/skills/` and tracked via `skills-lock.json`.

**To update skills:**

```bash
# Update all skills to latest versions
pnpm dlx skills update

# Install a new skill from repository
pnpm dlx skills add <skill-url>

# Copy updated skills to this repository
cd ~/claude-setup
for skill in ~/.claude/skills/*; do
    skill_name=$(basename "$skill")
    if [[ -d "$skill" ]]; then
        rm -rf ".agents/skills/$skill_name"
        cp -r "$skill" .agents/skills/
    fi
done

# Commit and push
git add .agents/skills/
git commit -m "Update Claude Code skills"
git push
```

**Best Practices:**
- Always use `add-skill.sh` and `sync-skills.sh` scripts instead of manual commands
- Track skill sources in `skills-lock.json` for reproducibility
- Use relative symlinks for portability across systems
- Version control `.agents/skills/` directory
- Don't commit `.claude/skills/` (symlinks are recreated by sync script)

## Profile Configuration

Profiles are JSON files in `profiles/` directory with this structure:

```json
{
    "permissions": {
        "allow": ["WebFetch", "WebSearch"]
    },
    "skipWebFetchPreflight": true,
    "env": {
        "ANTHROPIC_BASE_URL": "https://api.anthropic.com",
        "ANTHROPIC_MODEL": "claude-opus-4-6",
        "NODE_TLS_REJECT_UNAUTHORIZED": "0",
        "CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS": "true",
        "ANTHROPIC_SMALL_FAST_MODEL": "claude-haiku-4-5-20251001",
        "CLAUDE_CODE_MAX_OUTPUT_TOKENS": "18192"
    },
    "hooks": {}
}
```

### Profile Fields

- **permissions.allow**: List of tools Claude can use automatically
- **skipWebFetchPreflight**: Skip web fetch preflight checks
- **env.ANTHROPIC_BASE_URL**: API endpoint (change for custom endpoints)
- **env.ANTHROPIC_MODEL**: Default model to use
- **env.NODE_TLS_REJECT_UNAUTHORIZED**: Set to "0" for self-signed certs
- **env.CLAUDE_CODE_MAX_OUTPUT_TOKENS**: Max tokens per response
- **hooks**: Custom hooks for events (empty by default)

## CLAUDE.md

The `CLAUDE.md` file contains global coding standards and conventions that apply across ALL projects.

### Structure

```
~/CLAUDE.md (symlink) → ~/claude-setup/global/CLAUDE.md (master file)
```

### Why This Structure?

- **Avoids confusion** with project-specific CLAUDE.md files
- **Single source of truth** for global config
- **Easy to edit** via symlink at ~/CLAUDE.md
- **Organized** under claude-setup folder

### Project-Specific vs Global

- **Global** (`~/claude-setup/global/CLAUDE.md`): System-wide rules (testing, commit standards, etc.)
- **Project** (`<project>/CLAUDE.md`): Project-specific instructions (architecture, conventions, etc.)
- Claude loads BOTH - project config takes precedence over global config

### Content

The minimal `CLAUDE.md` provides essential cross-cutting concerns and pointers to detailed rules in `global/rules/`:

- Core principles and working philosophy
- Critical reminders (NO AI attribution, git safety)
- Pre-push verification requirements
- Bug management workflow
- GitHub Actions monitoring

This file is automatically loaded by Claude Code in all projects.

## Rules System

Detailed rules are organized modularly in `global/rules/` for better maintainability.

### Directory Structure

```
global/rules/
├── core/               # Working philosophy, core instructions, library usage
├── code-quality/       # AI attribution, commenting, team conventions, clean code
├── react-patterns/     # Performance principles reference
├── testing/            # Pre-push verification, unit tests, test organization
├── git/                # Commit standards, safety, PR reviews, version management
├── deployment/         # GitHub Actions, ECS deployment flow
├── bug-management/     # Bug resolution process, database, documentation
├── workflow/           # Task completion, SonarQube, task tool
└── tech-specific/      # Tailwind, Python, design context
```

### Accessing Rules

Rules are automatically loaded via symlink:

```
~/.claude/rules/global → ~/claude-setup/global/rules
```

Created automatically by `install.sh` via `setup-rules.sh`.

### Rule Categories

- **Core** (3 files): Working philosophy, core instructions, library usage
- **Code Quality** (5 files): NO AI attribution, commenting conventions, team conventions, clean code principles, universal principles reference
- **React Patterns** (1 file): Performance principles reference pointing to react-best-practices skill
- **Testing** (3 files): Pre-push verification, unit test standards, test file organization
- **Git** (8 files): Commit standards, git safety, version management, PR review standards (quality, workflow, organization, etiquette), PR suggestion fixes
- **Deployment** (7 files): GitHub Actions, ECS pre-deployment, dependencies, Docker build, service deployment, runtime migrations, verification, workflow parameters
- **Bug Management** (3 files): Bug resolution process, bug database, bug documentation
- **Workflow** (3 files): Task completion, SonarQube, task tool
- **Tech-Specific** (7 files): Tailwind config, OpenAI Codex config, Python packages, design users, brand personality, aesthetic, principles

**Total: 40 modular rule files**

## Promptbank

Quick access to common patterns and templates for Claude Code workflows via the `pb` command.

### Usage

**Interactive Mode (Easiest):**
```bash
pb                   # Shows numbered selection menu - no need to remember paths!
# 1. git/commit-message
# 2. git/pr-description
# ...
# Enter number: 1
# ✓ Copied 'git/commit-message' to clipboard
```

**Direct Commands:**
```bash
pb list              # List all available prompts
pb show <name>       # Display prompt content
pb copy <name>       # Copy prompt to clipboard (pbcopy)
pb edit <name>       # Open prompt in $EDITOR
```

### Available Templates (17 total)

**Git Workflows:**
- `git/commit-message` - Single-line commit message template
- `git/pr-description` - Pull request description template
- `git/branch-workflow` - Common git branch commands

**Testing:**
- `testing/test-boilerplate` - Vitest test structure (Arrange/Act/Assert)
- `testing/coverage-request` - Commands for running tests with coverage
- `testing/pre-push-checklist` - Pre-push verification for all languages

**Code Review:**
- `code-review/review-checklist` - Comprehensive PR review checklist
- `code-review/lgtm-template` - Approval comment template
- `code-review/nitpick-template` - Minor suggestion template

**Debugging:**
- `debugging/error-analysis` - Bug report template
- `debugging/rca-template` - Root cause analysis template
- `debugging/common-commands` - Common debugging commands

**Workflow & Quality:**
- `workflow/clean-solution` - Ensure clean, robust, and simple solutions
- `workflow/thorough-exploration` - Explore codebase thoroughly before changes
- `workflow/concise-plan` - Guidelines for concise plan creation
- `workflow/pipeline-monitoring` - Monitor GitHub Actions until all pass
- `workflow/use-skills` - Invoke appropriate agent skills for tasks

### Examples

```bash
# Interactive mode (easiest)
pb

# Copy commit message template
pb copy git/commit-message

# View test boilerplate
pb show testing/test-boilerplate

# Copy workflow quality prompt
pb copy workflow/clean-solution

# Edit custom template
pb edit git/pr-description
```

See `promptbank/README.md` for detailed usage.

## Toggle System

Temporarily disable rules and skills on a per-profile basis (session-only).

### What Happens When You Disable?

When you disable a rule or skill:
1. The symlink in `~/.claude/rules/global/` or `~/.claude/skills/` is removed
2. Claude cannot see the file (it doesn't exist in Claude's search path)
3. The disabled state is tracked in an environment variable for the current session

**Important:**
- **Session-only**: State is lost when you close the terminal
- **Per-terminal**: Each terminal window has independent toggle state
- **Per-profile**: Different profiles (cpa, cpb, c) have independent state within a session

### Usage

#### Interactive UI (Recommended)

```bash
# Launch interactive checkbox interface
claude-toggle ui

# Alternative command
claude-toggle interactive

# Navigate with arrow keys
# Space to toggle checkboxes
# Enter to apply changes
```

The interactive UI provides:
- Visual checkbox interface for bulk toggling
- Real-time status display (checked = disabled, unchecked = enabled)
- Profile-specific views
- Automatic fallback to bash `select` if `dialog` command unavailable

#### Command Line Interface

```bash
# Disable a rule
claude-toggle disable rule core/working-philosophy.md

# Disable a skill
claude-toggle disable skill code-reviewer

# Enable a rule
claude-toggle enable rule core/working-philosophy.md

# Enable a skill
claude-toggle enable skill code-reviewer

# List all with status
claude-toggle list

# Show current profile's disabled items
claude-toggle status

# Reset all (re-enable everything)
claude-toggle reset
```

### Key Features

- **Interactive UI**: Visual checkbox interface for bulk toggling
- **Session-only**: Toggle state lost when shell exits
- **Per-terminal**: Each terminal window has independent state
- **Per-profile**: Each profile (cpa, cpb, c) has independent toggle state
- **Clean**: Uses symlink manipulation, no config files
- **Reversible**: Easy to enable/disable repeatedly

### Profile Detection

The system attempts to detect the current profile from your command history. For explicit control:

```bash
export CLAUDE_TOGGLE_CURRENT_PROFILE="CPA"
claude-toggle disable rule testing/pre-push-verification.md
```

### Examples

**Scenario 1: Disable multiple rules for this session**
```bash
claude-toggle ui
# Select Rules
# Check: bug-management/bug-database.md
# Check: testing/pre-push-verification.md
# Apply
```

**Scenario 2: Different terminals, different states**
```bash
# Terminal 1
claude-toggle disable rule core/library-usage.md

# Terminal 2 (separate window)
# core/library-usage.md is still ENABLED here
```

**Scenario 3: Different profiles, different states**
```bash
cpa
claude-toggle disable skill animate
# animate disabled for profile 'cpa'

cpb
# animate still ENABLED for profile 'cpb'
```

## Advanced Usage

### Custom System Prompt

The default system prompt is defined in `claude-profiles.sh`:

```bash
export CLAUDE_SYSTEM_PROMPT='After pushing code, ALWAYS monitor GitHub Actions pipelines...'
```

To customize, edit `claude-profiles.sh` and reload:

```bash
claude-profile reload
```

### Environment-Specific Profiles

Create `.local.json` profiles for machine-specific configurations (automatically ignored by git):

```bash
cp profiles/profile-a.json profiles/profile-a.local.json
# Edit .local.json with machine-specific settings
```

### Model Flags

All profile commands support model flags:

- `-h`: Use Haiku model (fast, lightweight)
- `-c`: Use Sonnet model (balanced)
- `-g`: Use GPT model (for compatible profiles)

```bash
cpa -h          # Profile A with Haiku
cpb -c          # Profile B with Sonnet
cmy -h          # Custom profile with Haiku
```

## Security

**Never commit API tokens or secrets!**

- Profiles use environment variables for authentication
- API tokens should be set in your shell environment (.zshrc, .bashrc)
- `.gitignore` excludes `*.local.json` files for machine-specific configs
- Set appropriate environment variables:
  - `OPENAI_API_KEY` for OpenAI-compatible endpoints
  - `ANTHROPIC_API_KEY` for Anthropic endpoints

## Troubleshooting

### Profiles Not Loading

```bash
# Check profiles directory
ls -la ~/claude-setup/profiles/

# Reload profiles manually
claude-profile reload

# Check for errors
source ~/claude-setup/claude-profiles.sh
```

### Command Not Found

Make sure `claude-profiles.sh` is sourced in your `.zshrc`:

```bash
grep "claude-profiles.sh" ~/.zshrc
```

### Skills Not Available

Skills are loaded from `.agents/skills/` directory. Check:

```bash
ls -la ~/claude-setup/.agents/skills/
```

To reinstall skills:

```bash
cd ~/claude-setup
pnpm dlx skills add <skill-url>
```

### Symlinks Not Working

```bash
cd ~/claude-setup
./sync-skills.sh
```

### Skill Not Appearing

1. Check `.agents/skills/<name>/SKILL.md` exists
2. Run `./sync-skills.sh`
3. Restart Claude session

### Update Skill from GitHub

```bash
pnpm dlx skills add <github-url>  # Re-install
cp -r ~/.claude/skills/<name> ~/claude-setup/.agents/skills/
./sync-skills.sh
git add .agents/skills/<name> skills-lock.json
git commit -m "Update <name> skill"
```

## Contributing

### Adding New Profiles

1. Create profile from template:
   ```bash
   claude-profile add new-profile
   ```

2. Edit configuration:
   ```bash
   claude-profile edit new-profile
   ```

3. Commit and push:
   ```bash
   cd ~/claude-setup
   git add profiles/new-profile.json
   git commit -m "Add new-profile configuration"
   git push
   ```

### Updating Skills

1. Update skills:
   ```bash
   pnpm dlx skills update
   ```

2. Commit changes:
   ```bash
   git add .agents/ .claude/ skills-lock.json
   git commit -m "Update Claude Code skills"
   git push
   ```

## Repository Structure

```
claude-setup/
├── .agents/                    # Skills directory
│   └── skills/                 # 26 installed skills
│       ├── adapt/
│       ├── animate/
│       ├── code-quality/
│       ├── code-reviewer/
│       ├── frontend-design/
│       ├── list-models/        # Custom skill
│       ├── react-best-practices/
│       └── ...
├── .claude/                    # Claude symlinks
│   └── skills/ -> ../.agents/skills/
├── global/                     # Global configuration
│   ├── CLAUDE.md               # Minimal global config (master file)
│   ├── rules/                  # Modular rule files (40 files)
│   │   ├── core/               # Working philosophy, instructions
│   │   ├── code-quality/       # AI attribution, commenting, clean code
│   │   ├── react-patterns/     # Performance principles reference
│   │   ├── testing/            # Pre-push, unit tests, organization
│   │   ├── git/                # Commit, safety, PR reviews
│   │   ├── deployment/         # GitHub Actions, ECS
│   │   ├── bug-management/     # Bug resolution, database
│   │   ├── workflow/           # Task completion, SonarQube
│   │   └── tech-specific/      # Tailwind, Python, design
│   └── snapshots/              # CLAUDE.md backups
├── promptbank/                 # Common templates (17 files)
│   ├── git/                    # commit-message, pr-description, branch-workflow
│   ├── testing/                # test-boilerplate, coverage-request, pre-push-checklist
│   ├── code-review/            # review-checklist, lgtm-template, nitpick-template
│   ├── debugging/              # error-analysis, rca-template, common-commands
│   ├── workflow/               # clean-solution, thorough-exploration, concise-plan, pipeline-monitoring, use-skills
│   └── README.md
├── profiles/                   # Profile configurations
│   ├── profile-a.json
│   ├── profile-b.json
│   └── template.json
├── claude-profiles.sh          # Profile management script
├── claude-promptbank.sh        # Promptbank CLI (pb command)
├── add-skill.sh                # Install skill from GitHub
├── sync-skills.sh              # Sync skills (create symlinks)
├── setup-rules.sh              # Setup global rules symlink
├── install.sh                  # Installation script
├── skills-lock.json            # Skill source tracking
├── ~/CLAUDE.md -> global/CLAUDE.md    # Symlink to global config
├── ~/.claude/rules/global -> global/rules/  # Symlink to rules
├── .gitignore
└── README.md
```

## License

MIT

## Author

luyangliuable (luyang.l@proton.me)
