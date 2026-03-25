# Clean Code Principles (ALL PROJECTS)

**Apply these principles to all coding tasks:**

## 1. DRY (Don't Repeat Yourself)

- Single source of truth for shared data (e.g., theme-colors.cjs)
- Import/require shared config instead of duplicating
- Example: `const themeColors = require('./theme-colors.cjs')`

## 2. SOLID Principles

- Keep configurations minimal and focused
- Single Responsibility: Each config file has one purpose
- Open/Closed: Extend via imports, not modification

## 3. Simplicity First

- Minimal configuration - remove unnecessary options
- Use framework defaults when appropriate
- Only customize what's required

## 4. NPM Best Practices

- Use semantic versioning correctly
- Keep devDependencies separate from dependencies
- Export public APIs via package.json "exports" field
- Use standard npm scripts: build, test, dev

## 5. Configuration Files

- Avoid creating config files unless necessary
- Fewer config files = simpler project
- Document why each config exists
