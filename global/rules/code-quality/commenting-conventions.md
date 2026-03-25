# Commenting Conventions

## File Header (Top of Every File)

```ts
/**
 * @fileoverview <short description of file responsibility>.
 */
```

## Docstrings (JSDoc)

Use JSDoc for all functions, classes, methods, hooks, and React components.

```ts
/**
 * <Verb phrase describing what it does>.
 *
 * @param <name> - <meaning>.
 * @returns <meaning>.
 */
```

**Notes:**
- Include `@param` for each parameter
- Include `@returns` for non-void functions
- Skip anonymous inline callbacks (e.g., `.map(() => ...)`, `onClick={() => ...)`)

## JSX Comments (Major Blocks Only)

Use JSX block comments with 1–5 words, placed immediately above major layout sections.

```tsx
{/* Header */}
{/* Chat history */}
{/* Empty state */}
```

**Notes:**
- Do not add React fragments solely to attach a JSX comment
- If a component returns a single element, keep it that way
