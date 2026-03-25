# Test File Organization

## Structure Requirements

- Tests MUST mirror source folder structure in `__tests__/` directory
- One test file per source file: `app/hooks/useX.ts` → `app/__tests__/hooks/useX.test.ts`
- Integration tests go in `__tests__/integration/` subfolder

## Example Structure

```
app/
├── hooks/useAuth.ts
├── components/Button.tsx
└── __tests__/
    ├── hooks/useAuth.test.ts
    ├── components/Button.test.tsx
    └── integration/
```
