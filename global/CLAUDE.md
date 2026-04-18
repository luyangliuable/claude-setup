## CLAUDE System-Wide Configuration

<generalToolUse>
- Use SMALL OPERATIONS: max 50 lines per operation (create, find/replace, tool arguments)
- ALL tool parameters must adhere to 50-line limit
- Prefer multiple small operations over single large ones
</generalToolUse>

**NEVER COMMIT THIS FILE - LOCAL REFERENCE ONLY**

---

## Quick Reference

This file provides essential cross-cutting concerns. Detailed rules are organized by category:

- **Core** - Working philosophy, instructions, library usage
- **Code Quality** - AI attribution, commenting, team conventions, clean code
- **Testing** - Pre-push verification, unit tests, test organization
- **Git** - Commit standards, safety, PR reviews, version management
- **Deployment** - GitHub Actions, ECS deployment flow
- **Bug Management** - Bug resolution process, database
- **Workflow** - Task completion, SonarQube, task tool
- **Tech-Specific** - Tailwind, Python, Design context

---

## Critical Reminders

### NO AI Attribution (CRITICAL)
- NO Claude/AI mentions in commits, code, or messages
- NO "Generated with Claude" or "Co-Authored-By: Claude"
- NO emojis in professional code
- All commits appear human-written

### Git Safety
- NEVER destructive git commands without explicit user request
- NEVER skip hooks (--no-verify)
- NEVER amend commits (create NEW commits)
- NEVER commit without explicit user request

### Rebase Policy (CRITICAL)
- NEVER use git rebase unless explicitly requested
- Use merge commits to preserve full history
- Rebasing can unintentionally reintroduce removed code
- Rebasing obscures what changes were made and when
- If user wants to update branch: `git merge origin/develop`, NOT rebase

### Pre-Push Verification (MANDATORY)
Before pushing ANY changes:

**Code Quality (ALL files modified/added):**
- Remove all trailing whitespace
- Remove all unused imports
- Apply team conventions (use ?? not ||, absolute imports, etc.)

**Language-Specific Tests:**
```bash
npm test && npm run lint && npm run build  # JS/TS
pytest && ruff check                        # Python
cargo test && cargo clippy                  # Rust
go test ./... && golangci-lint run          # Go
```

### Bug Management (MANDATORY)
- **BEFORE fixing**: Check `~/bug-database/bug_database.json`
- **AFTER fixing**: Update `~/bug-database/bug_database.json`

### GitHub Actions Monitoring (MANDATORY)
After EVERY push:
```bash
gh run list    # Check status
gh run watch   # Monitor until ALL pipelines pass
```

---

## See Also

- **Detailed Rules**: Global rules directory (toggle-controlled)
- **Promptbank**: Use `pb` command for common patterns
- **Skills**: `.agents/skills/` for specialized knowledge
