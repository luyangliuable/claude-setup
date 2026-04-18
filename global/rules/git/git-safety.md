# Git Safety Protocol

## Critical Rules

- NEVER update the git config
- NEVER run destructive git commands (push --force, reset --hard, checkout ., restore ., clean -f, branch -D) unless the user explicitly requests these actions
- NEVER skip hooks (--no-verify, --no-gpg-sign, etc) unless the user explicitly requests it
- NEVER run force push to main/master, warn the user if they request it
- CRITICAL: Always create NEW commits rather than amending, unless the user explicitly requests a git amend
- When staging files, prefer adding specific files by name rather than using "git add -A" or "git add ."
- NEVER commit changes unless the user explicitly asks you to

## Local-Only Configuration Files

- Before committing, verify no local-only config files are staged
- Common local-only files: database configs, drizzle.config.ts, connections/*
- Use: promptbank/git/local-only-files-check.txt
- If project has local-only files, document them in project's CLAUDE.md
