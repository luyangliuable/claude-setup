# Global Claude Configuration

This folder contains system-wide Claude Code configuration that applies across ALL projects.

## Files

### CLAUDE.md
- **Master copy** of global Claude instructions
- Symlinked from `~/CLAUDE.md` → `~/claude-setup/global/CLAUDE.md`
- Contains: coding standards, bug database patterns, testing requirements, etc.
- Applied to ALL Claude sessions unless overridden by project-specific CLAUDE.md

## Symlink Structure

```
~/CLAUDE.md (symlink) → ~/claude-setup/global/CLAUDE.md (master file)
```

## Why This Structure?

- **Avoids confusion** with project-specific CLAUDE.md files
- **Single source of truth** for global config
- **Easy to edit** via symlink at ~/CLAUDE.md
- **Organized** under claude-setup folder

## Project-Specific vs Global

- **Global** (`~/claude-setup/global/CLAUDE.md`): System-wide rules (testing, commit standards, etc.)
- **Project** (`<project>/CLAUDE.md`): Project-specific instructions (architecture, conventions, etc.)
- Claude loads BOTH - project config takes precedence over global config
