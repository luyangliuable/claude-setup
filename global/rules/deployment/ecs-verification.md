# ECS Deployment - Verification (CloudWatch Logs)

## View Logs

```bash
# CLI method
aws logs tail /ecs/app-name-env --follow --since 1h

# AWS Console method
# ECS → Clusters → cluster-name-env → Services → app-name-env
# → Tasks → (click running task) → Logs tab
```

## Success Indicators

- "Running Drizzle migrations..."
- "Reading config file '/app-directory/drizzle.config.ts'" (no "Cannot find module" errors)
- "Using dialect postgresql"
- "Pushing changes to database"
- Migration success messages
- "Starting Next.js server on port 8080"

## Red Flags

- "Cannot find module" - Missing dependency
- "ECONNREFUSED" - Database connection failed
- "relation does not exist" - Migration didn't run or failed
- Container exit code 1 - Check full logs for error
