# ECS Deployment - Runtime Migrations

**Key pattern for database migrations at container startup:**

## entrypoint.sh Process

```bash
# 1. Fetch DB credentials from AWS Secrets Manager
# 2. Construct DRIZZLE_DATABASE_URL with URL-encoded password
# 3. Run migrations: npx drizzle-kit push --verbose --force
# 4. Start Node.js server: node server.js
```

## Requirements for Runtime Migrations

**Dockerfile MUST copy to release stage:**

- `node_modules/` (contains drizzle-kit and all deps)
- `tsconfig.json` (for @ path resolution)
- `drizzle.config.ts` (migration config)
- `app/database/schemas/` (table definitions)

**Environment Requirements:**

- All imports in drizzle.config.ts must have packages installed
- Database credentials must be in environment at runtime
