# Drizzle Kit Migrations

## Critical Concepts

### Schema Export Controls What Drizzle Manages

**The schemas exported from `schemas/index.ts` determine which tables Drizzle Kit will create/modify.**

```typescript
// schemas/index.ts
export { users } from '@/database/schemas/users.schema';
// Only exports users - drizzle only manages users table
```

**DO NOT export schemas for tables managed by other systems:**
- Tables from other repositories
- Tables managed by external services
- Shared tables owned by different teams

### Keep Schemas for Type-Safety

Schemas can exist for type-safety without being managed by Drizzle:

```typescript
// Import directly where needed
import { userContextMapping } from '@/database/schemas/user-context-mapping.schema';

// NOT exported from schemas/index.ts
```

## Configuration Pattern

### drizzle.config.ts

```typescript
export default {
  schema: './app/database/schemas/index.ts',
  out: './app/database/migrations',
  dialect: 'postgresql',
  dbCredentials: { /* ... */ },
  // CRITICAL: Only manage specific tables
  tablesFilter: ['users', 'posts'], // Array of table names to manage
} satisfies Config;
```

### Use Both: Schema Export + tablesFilter

**Best Practice: Use BOTH patterns for defense in depth:**

1. **Schema Export (Primary)** - Only export managed tables from `index.ts`
2. **tablesFilter (Safety Net)** - Explicitly list managed tables

Why both?
- Schema export prevents drizzle from knowing about tables
- tablesFilter prevents drizzle from touching unknown tables in DB
- Double protection against accidental modifications

## Running Migrations

### Development (Interactive)

```bash
npx drizzle-kit push --verbose
```

### Production/CI (Headless)

```bash
npx drizzle-kit push --verbose --force
```

**CRITICAL: `--force` skips all prompts and applies changes automatically.**
- Only use with proper safeguards (schema export + tablesFilter)
- Test thoroughly in development first

## Common Patterns

### Multi-Database Setup

When connecting to multiple databases:

```typescript
// Database A - manages users
// drizzle.config.ts points to DATABASE_A
export default {
  schema: './schemas/index.ts', // Only exports users
  dbCredentials: { database: 'database_a' },
  tablesFilter: ['users'],
};

// Database B - read-only access
// No drizzle config - schemas imported directly
import { agentMemory } from '@/schemas/agent-memory.schema';
```

### Shared Tables Pattern

When you need to query tables but NOT manage them:

```typescript
// schemas/shared-table.schema.ts
/**
 * IMPORTANT: This table is managed by [other-repo-name].
 * - This schema is for TYPE-SAFETY and READ/WRITE queries only
 * - Table structure is NOT managed by drizzle migrations in this repo
 * - Import this schema directly where needed
 */
export const sharedTable = pgTable('shared_table', { /* ... */ });

// schemas/index.ts
// DO NOT export sharedTable here

// Usage in code
import { sharedTable } from '@/schemas/shared-table.schema';
```

## Testing Migration Safety

### Phase 1: Table Creation Test

```bash
# Drop managed table
psql -c "DROP TABLE IF EXISTS users CASCADE;"

# Run migration
npx drizzle-kit push --verbose --force

# Verify only managed table created
psql -c "\dt"  # Should show users + unmanaged tables
```

### Phase 2: Data Preservation Test

```bash
# Insert mock data into UNMANAGED table
psql -c "INSERT INTO unmanaged_table (id, name) VALUES (1, 'test');"

# Count rows before
psql -c "SELECT COUNT(*) FROM unmanaged_table;"

# Run migration with --force
npx drizzle-kit push --verbose --force

# Verify rows preserved
psql -c "SELECT COUNT(*) FROM unmanaged_table;"
# Count MUST match
```

## Troubleshooting

### Drizzle tries to manage unmanaged tables

**Symptom:** `CREATE TABLE` statements for tables you don't want to manage

**Fix:**
1. Check `schemas/index.ts` - remove exports for unmanaged tables
2. Add `tablesFilter` to `drizzle.config.ts`
3. Import schemas directly where needed

### Drizzle prompts to rename/drop tables

**Symptom:** Interactive prompts asking about table relationships

**Cause:** Table exists in database but not in schema exports

**Fix:** Add table name to `tablesFilter` to ignore it

### Foreign keys to unmanaged tables

**Pattern:** Managed table references unmanaged table

```typescript
// schemas/users.schema.ts
import { sharedTable } from './shared-table.schema';

export const users = pgTable('users', {
  id: uuid('id').primaryKey(),
  sharedId: uuid('shared_id').references(() => sharedTable.id), // OK - type-safe FK
});

// schemas/index.ts
export { users } from './users.schema';
// DO NOT export sharedTable
```

Drizzle handles the FK correctly as long as `tablesFilter` prevents it from managing the referenced table.

## Anti-Patterns

### ❌ Exporting all schemas

```typescript
// schemas/index.ts - BAD
export * from './users.schema';
export * from './admin-only-table.schema'; // Managed elsewhere!
export * from './third-party-table.schema'; // External!
```

### ❌ No tablesFilter with shared database

```typescript
// drizzle.config.ts - BAD
export default {
  schema: './schemas/index.ts',
  dbCredentials: { database: 'shared_db' }, // Multiple apps use this!
  // Missing tablesFilter - drizzle might touch other app's tables!
};
```

### ❌ Using wrong schema file at runtime

```typescript
// connections/db.ts - BAD
import * as schema from '@/database/schemas'; // Only has managed tables

// Should import schemas directly
import { users } from '@/schemas/users.schema';
import { sharedTable } from '@/schemas/shared-table.schema';
const schema = { users, sharedTable };
```

## Deployment Checklist

Before deploying Drizzle migrations to production:

- [ ] Only managed tables exported from `schemas/index.ts`
- [ ] `tablesFilter` configured in `drizzle.config.ts`
- [ ] Tested with `--force` flag in development
- [ ] Verified unmanaged tables are not touched
- [ ] Mock data preservation test passed
- [ ] Runtime queries import schemas correctly
- [ ] Foreign keys to unmanaged tables work correctly

## References

- Drizzle Kit Docs: https://orm.drizzle.team/kit-docs/overview
- Schema Management: https://orm.drizzle.team/docs/schemas
