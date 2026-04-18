# Pre-Push Verification (MANDATORY)

**MANDATORY: Before pushing any changes, run ALL code quality and language-specific checks:**

## Performance Option: Run Checks in Parallel

For faster verification, use: `promptbank/testing/parallel-pre-push-checks.txt`

This spawns independent background tasks for test/lint/build simultaneously, providing 3x faster feedback. Use for projects with longer check times or when you want local parity with parallel CI/CD pipelines.

---

## Code Quality Checks (MANDATORY - ALL Languages)

**Before running language-specific checks, ensure:**

### 1. Trailing Whitespace
- Remove trailing whitespace from all modified/new files
- Most formatters handle this automatically
- Manual check: `git diff --check` (detects trailing whitespace)

### 2. Unused Imports
- Remove unused imports from all modified/new files
- ESLint/TSLint: Handled by `npm run lint` with appropriate rules
- Python: `ruff check` with unused-import rules
- Rust: `cargo clippy` catches unused imports
- Go: `goimports` removes unused imports automatically

### 3. Team Conventions
Apply conventions from `global/rules/code-quality/team-conventions.md`:
- Use `??` (nullish coalescing) instead of `||` for default values
- Use absolute imports (`@/`) instead of relative imports
- No TODO comments (creates tech debt)
- Use native HTML elements for accessibility

**Automated Check**: Most of these are caught by linters if configured properly.
**Manual Review**: For new files, verify conventions are followed.

---

## JavaScript/TypeScript/Node.js

- `npm test` or `yarn test` - All tests must pass
- `npm run lint` or `yarn lint` - No errors (warnings OK)
- `npm run format` or `yarn format` - Code formatted
- `npm run build` or `yarn build` - Build must succeed

## Python

- `python -m pytest tests/` or `pytest` - All tests must pass
- `python -m pylint` or `ruff check` - Linting passes
- `python -m black .` or `ruff format` - Code formatted
- Build verification depends on project type (setuptools, poetry, etc.)

## Rust

- `cargo test` - All tests must pass
- `cargo clippy` - Linting passes
- `cargo fmt --check` - Code formatted
- `cargo build --release` - Build succeeds

## Go

- `go test ./...` - All tests must pass
- `golangci-lint run` - Linting passes
- `gofmt -l .` or `go fmt ./...` - Code formatted
- `go build` - Build succeeds

**DO NOT push if any checks fail!**
