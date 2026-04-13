# Architecture

## Content Organization

### .agents/skills/
Runtime agent capabilities. Each skill provides specialized knowledge invoked with `/skill-name`.

Examples: code-quality, frontend-design, github-actions

### global/rules/
Authoritative standards loaded via CLAUDE.md symlinks. Always active for all projects.

Categories: core, code-quality, testing, git, deployment, workflow

### promptbank/
Quick-access templates via `pb` CLI command. For copy/paste into conversations.

Categories: git, testing, code-review, debugging, workflow

## Key Distinction

Files with similar names serve different purposes:
- **Promptbank**: Templates for humans to copy/paste
- **Skills**: Reference docs for agent runtime
- **Rules**: Enforced standards always loaded

## Examples

### Review Checklists
- `promptbank/code-review/review-checklist.txt` - Simple checklist for `pb` CLI
- `.agents/skills/code-reviewer/references/review-checklist.md` - Comprehensive runtime guide

### Pre-Push Verification
- `promptbank/testing/pre-push-checklist.txt` - Simple checklist for `pb` CLI
- `global/rules/testing/pre-push-verification.md` - Authoritative standards

Both serve their specific purposes and are not duplicates.
