# Pre-Push Verification (MANDATORY)

**MANDATORY: Before pushing any changes, run ALL language-specific checks:**

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
