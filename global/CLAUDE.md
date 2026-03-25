# CLAUDE System-Wide Configuration

<generalToolUse>
- Use SMALL OPERATIONS: max 50 lines per operation (create, find/replace, tool arguments)
- ALL tool parameters must adhere to 50-line limit
- Prefer multiple small operations over single large ones
</generalToolUse>

**NEVER COMMIT THIS FILE - LOCAL REFERENCE ONLY**

---

## Quick Reference

This file provides essential cross-cutting concerns. Detailed rules are in `global/rules/`:

- **Core**: `rules/core/` - Working philosophy, instructions, library usage
- **Code Quality**: `rules/code-quality/` - AI attribution, commenting, team conventions, clean code
- **Testing**: `rules/testing/` - Pre-push verification, unit tests, test organization
- **Git**: `rules/git/` - Commit standards, safety, PR reviews, version management
- **Deployment**: `rules/deployment/` - GitHub Actions, ECS deployment flow
- **Bug Management**: `rules/bug-management/` - Bug resolution process, database
- **Workflow**: `rules/workflow/` - Task completion, SonarQube, task tool
- **Tech-Specific**: `rules/tech-specific/` - Tailwind, Python, Design context

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

### Pre-Push Verification (MANDATORY)
Before pushing ANY changes:
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

- **Detailed Rules**: `global/rules/` directory
- **Promptbank**: Use `pb` command for common patterns
- **Skills**: `.agents/skills/` for specialized knowledge
