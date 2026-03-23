# Claude Code Configuration

Centralized configuration repository for Claude Code setup, including skills, profiles, and extensible profile management system.

## Overview

This repository contains:
- **Claude Code Skills**: Installed and ready-to-use skills (code-reviewer, fetch-unresolved-comments)
- **Profile Management**: Extensible shell functions for switching between Claude profiles
- **Profile Configurations**: JSON files defining different Claude Code environments
- **CLAUDE.md**: Global coding standards and project instructions

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/luyangliuable/claude-config.git ~/claude-setup
```

### 2. Source Profile Management in .zshrc

Add this line to your `~/.zshrc`:

```bash
source ~/claude-setup/claude-profiles.sh
```

Then reload your shell:

```bash
source ~/.zshrc
```

### 3. Use Claude Profiles

```bash
# Default Claude (uses current environment)
c

# Claude via GenAI Studio (Sonnet default)
cgs
cgs -h    # Use Haiku model
cgs -g    # Use GPT model

# Claude via DHP (Opus default)
cdh
cdh -h    # Use Haiku model
cdh -c    # Use Sonnet model
```

## Profile Management

### List Available Profiles

```bash
claude-profile list
```

Output:
```
Available Claude profiles:

  - genai-studio (cgs, lcgs)
      API: https://api.studio.genai.cba
      Model: aipe-bedrock-claude-4-5-sonnet

  - dhp-opus (cdh, lcdh)
      API: https://api.dhp.example.com
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
claude-profile edit genai-studio
```

### Remove Profile

```bash
claude-profile remove my-custom
```

### Reload Profiles

```bash
claude-profile reload
```

## Loop Commands (Continuous Tasks)

Loop commands run Claude in a continuous loop with automatic restart on completion:

```bash
# Usage: l<profile> [timeout_minutes] ["task description"]

lc                    # Default profile, 1 min timeout
lcgs 5                # GenAI Studio, 5 min timeout
lcdh 10 "monitor PR"  # DHP, 10 min timeout, custom task
```

**Default Loop Task:**
> Monitor the current PR using gh pr view. Run npm build, test, lint and format. Fix any failures and push. Use the code-quality skill when fixing code. Iterate until all checks pass.

## Skills

### Installed Skills

#### 1. code-reviewer
**Purpose**: Comprehensive code review for pull requests and code quality audits

**Capabilities**:
- Identifies bugs and logic errors
- Detects security vulnerabilities (SQL injection, XSS, insecure deserialization)
- Finds code smells and architectural issues
- Detects N+1 queries and performance problems
- Produces structured review reports

**Usage**:
```bash
/code-reviewer
```

#### 2. fetch-unresolved-comments
**Purpose**: GitHub PR review comment management

**Capabilities**:
- Fetches unresolved PR review comments via GitHub GraphQL API
- Filters out resolved feedback automatically
- Helps track outstanding review comments

**Usage**:
```bash
/fetch-unresolved-comments
```

### Updating Skills

Skills are tracked via `skills-lock.json` which records source repositories:

```bash
# Update all skills to latest versions
pnpm dlx skills update

# Or manually re-install a specific skill
pnpm dlx add-skill <skill-url>
```

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

The `CLAUDE.md` file (symlink to `~/CLAUDE.md`) contains:
- Global coding standards and conventions
- Project instructions and guidelines
- Team-specific best practices
- Bug resolution processes
- Testing standards

This file is automatically loaded by Claude Code in all projects.

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
cp profiles/genai-studio.json profiles/genai-studio.local.json
# Edit .local.json with machine-specific settings
```

### Model Flags

All profile commands support model flags:

- `-h`: Use Haiku model (fast, lightweight)
- `-c`: Use Sonnet model (balanced)
- `-g`: Use GPT model (for compatible profiles)

```bash
cgs -h          # GenAI Studio with Haiku
cdh -c          # DHP with Sonnet
cmy -h          # Custom profile with Haiku
```

## Security

**Never commit API tokens or secrets!**

- Profiles use environment variables for authentication
- API tokens should be set in your shell environment (.zshrc, .bashrc)
- `.gitignore` excludes `*.local.json` files for machine-specific configs
- For GenAI Studio, set `OPENAI_API_KEY` environment variable
- For other endpoints, set `ANTHROPIC_API_KEY`

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
│   └── skills/
│       ├── code-reviewer/
│       └── fetch-unresolved-comments/
├── .claude/                    # Claude symlinks
│   └── skills/ -> ../.agents/skills/
├── profiles/                   # Profile configurations
│   ├── genai-studio.json
│   ├── dhp-opus.json
│   └── template.json
├── claude-profiles.sh          # Profile management script
├── install.sh                  # Installation script
├── skills-lock.json            # Skill source tracking
├── CLAUDE.md -> ~/CLAUDE.md    # Global coding standards (symlink)
├── .gitignore
└── README.md
```

## License

MIT

## Author

luyangliuable (luyang.l@proton.me)
