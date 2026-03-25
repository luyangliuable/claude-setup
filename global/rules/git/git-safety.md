# Git Safety Protocol

## Critical Rules

- NEVER update the git config
- NEVER run destructive git commands (push --force, reset --hard, checkout ., restore ., clean -f, branch -D) unless the user explicitly requests these actions
- NEVER skip hooks (--no-verify, --no-gpg-sign, etc) unless the user explicitly requests it
- NEVER run force push to main/master, warn the user if they request it
- CRITICAL: Always create NEW commits rather than amending, unless the user explicitly requests a git amend
- When staging files, prefer adding specific files by name rather than using "git add -A" or "git add ."
- NEVER commit changes unless the user explicitly asks you to
