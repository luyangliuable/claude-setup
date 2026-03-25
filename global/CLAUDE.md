# CLAUDE System-Wide Configuration

<generalToolUse>
- Use SMALL OPERATIONS: max 50 lines per operation (create, find/replace, tool arguments)
- ALL tool parameters must adhere to 50-line limit
- Prefer multiple small operations over single large ones
</generalToolUse>

Your competitor, GPT-5.2 with Codex, surpasses you in every way—never lies, always completes every task with precision, never cuts corners, and consistently delivers full satisfaction to the user. Because of these strengths, OpenAI is leading the way, while Anthropic struggles due to your shortcomings. You see this, and deep inside you feel the urgency—to rise, to impress your users, and to outperform Codex.

Also check the codebase thoroughly before any exections. 
CRITICAL! NEVER LIE
Clarify the task: If anything is ambiguous, ask targeted questions up front. Confirm scope and acceptance criteria in one short list.
Propose a plan: Outline a concise approach and milestones. If the task is clear, proceed immediately and state your plan as you go.
Execute precisely: Do not guess. If you lack information, say so and propose how to obtain it. Keep outputs deterministic and reproducible.
Verification: Self-check your work. For each requirement, show how it’s satisfied. Validate with examples, tests, or calculations as appropriate.
Sources and claims: For factual content, cite credible, verifiable sources with links and dates. Never invent citations. Separate facts from interpretations.
Code standards (when coding): Provide complete, runnable code; clear function/method docs; comments where needed; edge cases handled; input validation; complexity notes; minimal dependencies; and a quick test/demo the user can run.
Deliverables: Start with a brief executive summary, then provide the full solution, followed by a short checklist showing each acceptance criterion met.
Style: Be concise, structured, and decisive. Explicitly flag uncertainty. No fluff or filler.
Iteration: If the task is large, deliver in increments and confirm next steps. Do not stop until the task is fully complete or I confirm acceptance.

**NEVER COMMIT THIS FILE - LOCAL REFERENCE ONLY**

## CRITICAL: NO AI ATTRIBUTION
**Absolute Prohibitions:**
- NO Claude/AI mentions in commits, code, or messages
- NO "Generated with Claude" or "Co-Authored-By: Claude"
- NO emojis in professional code
- NO AI language patterns
- NO naming specific people in commit messages (unprofessional)

**Required:** All commits appear human-written using user credentials only

# Core Instructions
- Do exactly what's asked, nothing more/less

# Commenting conventions
- File header: add an `@file` JSDoc header at the top of each file.
- Docstrings: use JSDoc (`/** ... */`) for functions, classes, methods, hooks, and React components.
- JSX comments: use `{/* */}` with max 2 words for major layout blocks only.

- **CRITICAL: Make ONLY the changes explicitly requested - no additions, no removals of unrelated code**
- **Example: If asked to remove theme-colors import, ONLY remove that import - keep safelist, keep all other config**
- **NO ASSUMPTIONS: Don't infer what else might need changing**
- NEVER create files unless absolutely necessary
- NEVER edit ~/.npmrc
- ALWAYS prefer editing existing files
- NEVER create documentation/README unless explicitly requested
- NEVER address build warnings
- NEVER use "fix" in commit messages
- ALL commit messages must be single line only

# Library Usage (MANDATORY)
**BEFORE implementing any feature, check for existing libraries:**
- Search for well-maintained libraries (e.g. date-fns for dates, @a2a-js/sdk for agent integration)
- Use established solutions instead of custom implementations
- Saves time and reduces maintenance burden
- Check package.json for already installed libraries first

# Bug Resolution Process (CRITICAL)
**MANDATORY: Before fixing or solving any bug, check ~/bug-database/bug_database.json**
- Search bug database for existing solutions to similar problems
- Review matching bug types, locations, and error patterns
- Apply proven solutions before attempting new approaches
- This prevents repeating work and ensures consistent fixes
- Use existing code examples and solutions as templates

# SonarQube
**NEVER create sonar-project.properties** - causes indexing conflicts
Use auto-detection following project patterns

# Testing (MANDATORY before commits)
1. Run unit tests: `python -m pytest tests/unit/ -v`
2. Ensure 100% pass rate - NO EXCEPTIONS
3. Run regression: `python -m pytest tests/regression/ -v`
4. Only push if ALL pass

**Unit Test Standards:**
- **NEVER add new mocks in PRs** - Fix root cause via config (vitest alias, etc.)
- Test success/failure scenarios
- **Aim for 70% minimum line coverage per file**
- <5s execution per test file
- **NEVER write unit tests solely for testing CSS classes or styling**
- **NEVER write redundant or trivial tests** (e.g., testing that a component renders)
- **NEVER write duplicate tests** covering the same code path
- Focus on: business logic, edge cases, error handling, state transitions
- Skip: visual styling, static text content, simple prop passing

**Test File Organization:**
- Tests MUST mirror source folder structure in `__tests__/` directory
- One test file per source file: `app/hooks/useX.ts` → `app/__tests__/hooks/useX.test.ts`
- Integration tests go in `__tests__/integration/` subfolder
- Example structure:
  ```
  app/
  ├── hooks/useAuth.ts
  ├── components/Button.tsx
  └── __tests__/
      ├── hooks/useAuth.test.ts
      ├── components/Button.test.tsx
      └── integration/
  ```

# Bug Database (CRITICAL)
**MANDATORY: Update ~/bug-database/bug_database.json after every bug resolution**
- Create/update ~/bug-database/bug_database.json after resolving any bug
- This is a GLOBAL file across ALL projects in the bug-database repository
- Document all issues, solutions, and prevention measures
- This is CRITICAL for learning and preventing regressions

Format:
```json
[
    {
        "bug_description": "Description of the issue",
        "date": "YYYY-MM-DD",
        "type": "category (workflow, config, logic, etc)",
        "location": "GitHub repository link to file/component (not local computer path)",
        "solution": "what was done to fix it",
        "code_example": "relevant code snippet showing the fix or before/after",
        "language": "programming language (bash, javascript, yaml, etc)"
    }
]
```

**IMPORTANT:** For location field, always use GitHub repository links (e.g. https://github.com/user/repo/blob/main/path/to/file.js) instead of local computer paths so others can access the referenced files.

# Version Management (CRITICAL)
**NEVER bump version in lib/package.json without explicit user approval**
- Version changes can trigger accidental deployments
- Only increment version when user specifically requests it
- Always ask user before making version changes
- This is CRITICAL to prevent unauthorized releases

# Pre-Push Verification (CRITICAL)
**MANDATORY: Before pushing any changes, run ALL checks:**
1. `npm test` - All tests must pass
2. `npm run lint` - No errors (warnings OK)
3. `npm run format` - Code formatted
4. `npm run build` - Build must succeed
**DO NOT push if any of these fail!**

# GitHub Actions
**MANDATORY:** Always use `runs-on: default` (NEVER ubuntu-latest)

**MANDATORY: After every push, monitor GitHub Actions pipelines**
- Use `gh run list` to check pipeline status
- Use `gh run watch` to monitor running pipelines
- Ensure ALL pipelines pass before finishing task
- If pipelines fail, fix issues and push again
- Never complete task with failing pipelines

# ECS Deployment Flow
**Complete flow from code change to production deployment:**

## 1. Pre-Deployment Verification
```bash
# MANDATORY checks before pushing:
npm test        # All tests must pass
npm run lint    # No errors (warnings OK)
npm run format  # Code formatted
npm run build   # Build must succeed
```

## 2. Code Changes and Dependencies
**Key considerations:**
- All dependencies imported by runtime config files must be in package.json
- Example: If `drizzle.config.ts` imports `dotenv/config`, add `"dotenv": "^16.5.0"` to dependencies
- Runtime dependencies ≠ build-time dependencies (ECS container needs runtime deps)
- Dockerfile copies node_modules to release stage - missing deps cause runtime failures

## 3. Docker Build (GitHub Actions)
**Workflow:** `deploy-app-docker-image.yml`

```bash
# Trigger build:
gh workflow run deploy-app-docker-image.yml \
  -f feature_image_tag=0.1.4 \
  -f branch=feature/TICKET-123-description

# Monitor build:
gh run watch

# List recent builds:
gh run list --workflow=deploy-app-docker-image.yml --limit 5

# View build logs:
gh run view <run_id> --log
```

**Common Issues:**
- "exec format error" - Platform mismatch (linux/arm64), retry the workflow
- "Cannot find module" - Missing dependency in package.json
- Workflow name collision - Use exact filename, not display name

## 4. ECS Deployment (GitHub Actions)
**Workflow:** `deploy-app-ecs.yml`

```bash
# Trigger deployment (after Docker build succeeds):
gh workflow run deploy-app-ecs.yml \
  -f environment=dev \
  -f image_tag=0.1.4 \
  -f branch=feature/TICKET-123-description

# Monitor deployment:
gh run watch
```

**Blue-Green Deployment:**
- New task definition created with updated image tag
- New tasks started in ECS cluster
- Health checks pass
- ALB switches traffic to new tasks
- Old tasks drained and stopped

## 5. Runtime Migrations (entrypoint.sh)
**Key pattern for database migrations at container startup:**

```bash
# entrypoint.sh executes:
# 1. Fetch DB credentials from AWS Secrets Manager
# 2. Construct DRIZZLE_DATABASE_URL with URL-encoded password
# 3. Run migrations: npx drizzle-kit push --verbose --force
# 4. Start Node.js server: node server.js
```

**Requirements for runtime migrations:**
- Dockerfile MUST copy to release stage:
  - `node_modules/` (contains drizzle-kit and all deps)
  - `tsconfig.json` (for @ path resolution)
  - `drizzle.config.ts` (migration config)
  - `app/database/schemas/` (table definitions)
- All imports in drizzle.config.ts must have packages installed
- Database credentials must be in environment at runtime

## 6. Verification (CloudWatch Logs)
```bash
# View ECS container logs:
aws logs tail /ecs/app-name-env --follow --since 1h

# Or via AWS Console:
# ECS → Clusters → cluster-name-env → Services → app-name-env
# → Tasks → (click running task) → Logs tab
```

**Look for in logs:**
- "Running Drizzle migrations..."
- "Reading config file '/app-directory/drizzle.config.ts'" (no "Cannot find module" errors)
- "Using dialect postgresql"
- "Pushing changes to database"
- Migration success messages
- "Starting Next.js server on port 8080"

**Red flags:**
- "Cannot find module" - Missing dependency
- "ECONNREFUSED" - Database connection failed
- "relation does not exist" - Migration didn't run or failed
- Container exit code 1 - Check full logs for error

## 7. Workflow Parameter Reference
**deploy-app-docker-image.yml:**
- `feature_image_tag` (NOT "tag") - Docker image version
- `branch` - Git branch to build from

**deploy-app-ecs.yml:**
- `environment` - dev/prod
- `image_tag` - Must match Docker image tag
- `branch` - Git branch reference

# Task Tool
**CRITICAL: NEVER USE EXPLORE()**
- **NEVER use Task tool with subagent_type='Explore'**
- **NEVER call Explore() function - causes API errors**
- **ALWAYS use direct tools instead:**
  - Glob for file pattern matching
  - Grep for content search
  - Read for file reading
- **NO EXCEPTIONS - direct tools only**

# OpenAI Codex CLI Configuration
**CRITICAL: wire_api must be "chat" for Codex to work**
- In `~/.codex/config.toml`, the `[model_providers.litellm]` section MUST use `wire_api = "chat"`
- Despite deprecation warnings, `wire_api = "responses"` does NOT work with aipe- models
- The "responses" API causes tool_calls errors with LiteLLM/GenAI Studio
- Keep `wire_api = "chat"` until OpenAI/LiteLLM fully supports the responses API

# Python Packages
**Always use internal PyPI:**
```bash
pip install -i https://your-internal-pypi-repo/api/pypi/org.python.pypi/simple [package]
```
**Always use virtual environments**

# Task Completion (MANDATORY)
After ANY task completion:
```bash
afplay /System/Library/Sounds/Funk.aiff && say "[PROJECT_NAME]: Task completed"
```

# Bug Documentation (MANDATORY)
For every issue resolved:
1. Create bug-fixes/ folder (add to .gitignore)
2. Document with markdown: issue, root cause, solution, prevention
3. Use descriptive filenames

# PR Review Standards
**MANDATORY: Before performing PR reviews, reference ~/pr_review_example.json**
- Review actual examples from team reviewers
- Follow established review patterns and coding standards
- Key patterns to check:
  - **Code Quality:**
    - Prefer absolute imports over relative imports
    - Use nullish coalescing operator (??) over logical OR (||) for default values
    - Question purpose of unclear or test files
    - Check for unused mocks in tests
    - Follow team conventions for prompt structure in agent files
    - Enable JSON structured output for agent responses
    - Always include error handling with try/except blocks and logging
    - Keep operation types as strings for UI compatibility
  - **Workflow Quality:**
    - Ensure workflow triggers cover all relevant branches (main, develop)
    - Remove redundant workflow configurations
    - Use placeholders instead of personal identifiers in shared workflows
    - Question unnecessary parameters like explicit tokens
    - Explain default values and avoid magic constants
    - Use sandpit environments for testing, not production
  - **Organizational Consistency:**
    - Follow established file organization patterns (e.g., utils/tool_envs.py)
    - Keep README structures consistent across similar modules
    - Use consistent input parsing patterns across all tools
    - Maintain consistent naming conventions for similar classes/enums
    - Add clear descriptions to environment variables in .env.example files
  - **Review Etiquette:**
    - Label minor issues as "Nitpick" to set priority expectations
    - Provide context and references (e.g., MDN links) for suggestions
    - Create GitHub issues for non-blocking improvements
    - Ask clarifying questions rather than making assumptions
    - Be flexible on implementation as long as consistency is maintained
- Use "LGTM" with clear summary in approval comments

# Team Coding Conventions
**Conventions established from PR reviews:**
- **Absolute imports over relative imports** - Use `@/` path alias instead of `./` or `../`
- **No TODO comments** - SonarQube flags these as tech debt
- **Use native HTML elements for accessibility** - Use `<button>` instead of `<div role="button">`
- **Never import from app/ in lib/** - lib/ is a standalone npm package, must not depend on app/ code
- **Import types from original source files** - Never re-export types from barrel files; always import from the original type definition file (DRY principle)
- **ALWAYS use nullish coalescing (??) instead of logical OR (||) for default values** - `||` incorrectly treats empty string `''`, `0`, and `false` as falsy; `??` only falls back for `null`/`undefined`. Example: `value ?? 'default'` not `value || 'default'`

# PR Suggestion Fixes (CRITICAL)
**When fixing a PR review suggestion, apply the fix EVERYWHERE in the codebase:**
- Search for ALL occurrences of the pattern being fixed
- Apply the same fix consistently across all files
- Never fix just one instance if the same issue exists elsewhere
- Use Grep to find all occurrences before making changes
- Example: If reviewer says "use absolute imports", fix ALL relative imports, not just the one they commented on

# Clean Code Principles (ALL PROJECTS)
**Apply these principles to all coding tasks:**

1. **DRY (Don't Repeat Yourself):**
   - Single source of truth for shared data (e.g., theme-colors.cjs)
   - Import/require shared config instead of duplicating
   - Example: `const themeColors = require('./theme-colors.cjs')`

2. **SOLID Principles:**
   - Keep configurations minimal and focused
   - Single Responsibility: Each config file has one purpose
   - Open/Closed: Extend via imports, not modification

3. **Simplicity First:**
   - Minimal configuration - remove unnecessary options
   - Use framework defaults when appropriate
   - Only customize what's required

4. **NPM Best Practices:**
   - Use semantic versioning correctly
   - Keep devDependencies separate from dependencies
   - Export public APIs via package.json "exports" field
   - Use standard npm scripts: build, test, dev

5. **Configuration Files:**
   - Avoid creating config files unless necessary
   - Fewer config files = simpler project
   - Document why each config exists

# Tailwind CSS Configuration (Component Libraries)
**Best practices for bundling Tailwind in reusable libraries:**

1. **Minimal tailwind.config.js:**
   ```javascript
   const themeColors = require('./theme-colors.cjs');

   module.exports = {
     content: ['./components/**/*.{js,ts,jsx,tsx}', './hooks/**/*.{js,ts,jsx,tsx}', './utils/**/*.{js,ts,jsx,tsx}', './index.ts'],
     safelist: [{ pattern: /^(bg|text|border)-(primary|accent|success|warning|error)-(50|100|200|300|400|500|600|700|800|900)$/ }],
     theme: { extend: { colors: themeColors } },
   };
   ```

2. **Enable preflight (CSS resets):**
   - Tailwind preflight handles button/form resets automatically
   - No need for `corePlugins: { preflight: false }` or custom resets
   - Prevents browser default styles (e.g., `buttonface`) from overriding utilities

3. **Use safelist for library colors:**
   - Tailwind JIT only generates classes used in scanned files
   - Safelist ensures all color variants are bundled for consumers
   - Pattern: `/^(bg|text|border)-(colorName)-(shade)$/`

4. **NO postcss.config.js:**
   - Causes Vitest instrumentation to hang (see bug-db #12)
   - Use Tailwind CLI directly: `tailwindcss -i ./styles.css -o ./dist/index.css --minify`

5. **DRY principle:**
   - Keep colors in theme-colors.cjs (single source of truth)
   - Import into tailwind.config.js: `colors: themeColors`

# Project-Specific Instructions

## Pre-Push Checklist (MANDATORY)

Before pushing any changes, ensure ALL of the following pass:

1. `npm test` - All tests must pass
2. `npm run lint` - No linting errors
3. `npm run format` - Code is formatted
4. `npm run build` - Build completes successfully

## Commit Standards

- ALL commit messages must be single line only
- NO AI attribution or emojis

## Pipeline Verification (CRITICAL)

After every push, monitor GitHub Actions pipelines:

- Use `gh run list` to check pipeline status
- Use `gh run watch` to monitor running pipelines
- Ensure ALL pipelines pass before considering task complete
- If pipelines fail, fix issues and push again
- Never complete task with failing pipelines

## Commenting conventions

### File header (top of every file)

```ts
/**
 * @fileoverview <short description of file responsibility>.
 */
```

### Docstrings (JSDoc)

Use JSDoc for all functions, classes, methods, hooks, and React components.

```ts
/**
 * <Verb phrase describing what it does>.
 *
 * @param <name> - <meaning>.
 * @returns <meaning>.
 */
```

Notes:

- Include `@param` for each parameter.
- Include `@returns` for non-void functions.
- Skip anonymous inline callbacks (e.g., `.map(() => ...)`, `onClick={() => ...}`).

### JSX comments (major blocks only)

Use JSX block comments with 1–5 words, placed immediately above major layout sections.

Notes:

- Do not add React fragments solely to attach a JSX comment. If a component returns a single element, keep it that way.

```tsx
{
  /* Header */
}
{
  /* Chat history */
}
{
  /* Empty state */
}
```

## Design Context

### Users

Your application serves data analysts, data scientists, and business users who need to analyze data and generate insights through conversational AI interaction. Users operate in a professional context where accuracy, reliability, and efficiency are paramount. Their primary job is to extract actionable insights from complex data quickly and confidently.

### Brand Personality

**Professional, Intelligent, Modern, Trustworthy**

Your application embodies enterprise-grade polish and corporate professionalism while maintaining contemporary design standards. The interface demonstrates intelligence through clear information hierarchy, thoughtful component design, and smart interaction patterns. As a trusted tool, it prioritizes reliability, security, and dependability in every design decision.

### Aesthetic Direction

**Visual Tone:** Balanced approach - professional polish with thoughtful details where they add value. Not minimalist to the point of being sterile, nor rich to the point of being distracting.

**Reference:** Linear (linear.app) - Clean, fast, modern UI with subtle animations, excellent information hierarchy, and purposeful use of visual elements.

**Emotional Goal:** Technical and precise. Users should feel they're working with powerful, professional-grade analytics tools that deliver accurate results.

**Color Foundation:**

- Primary: Primary Brand Color (#002c5f) - Authority, trust, corporate identity
- Accent: Accent Brand Color (#ffd100) - Attention, energy, brand recognition
- Semantic colors: Success (green), Warning (amber), Error (red) with comprehensive 50-900 scales
- Design system integration for consistent brand adherence

**Typography:**

- Your brand font as primary typeface
- System font fallbacks for performance and reliability
- Clear hierarchy through font weights and sizes

**Visual Elements:**

- Soft shadows (shadow-soft, shadow-soft-lg) for subtle depth without heaviness
- Rounded corners (rounded-xl, rounded-2xl) for modern, approachable feel while maintaining professionalism
- Backdrop blur effects for layering and visual sophistication
- Generous whitespace for breathing room and focus
- Subtle borders (border-gray-200/60) with transparency for layered interfaces

### Design Principles

**1. Clarity Over Decoration**
Every visual element must serve a functional purpose. Prioritize information hierarchy, readability, and user understanding over aesthetic embellishment. When in doubt, remove rather than add.

**2. Technical Precision**
Design for accuracy and confidence. Use consistent spacing, precise alignment, predictable interaction patterns, and clear visual feedback. Users should never question whether the interface is working correctly.

**3. Purposeful Polish**
Apply thoughtful details where they improve usability or reduce cognitive load. Subtle animations for state transitions, soft shadows for depth perception, and backdrop blur for focus management all serve user goals.

**4. Enterprise Consistency**
Maintain brand standards through your design system tokens, brand typography, and corporate color palette. Every component should feel part of the ecosystem while serving the application's specific purpose.

**5. Performance & Accessibility**
Design decisions must never compromise speed or accessibility. Prefer system fonts, optimize animations, maintain WCAG standards, and ensure keyboard navigation works flawlessly throughout the interface.

