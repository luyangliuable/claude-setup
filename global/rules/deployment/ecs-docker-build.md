# ECS Deployment - Docker Build (GitHub Actions)

**Workflow:** `deploy-app-docker-image.yml`

## Trigger Build

```bash
gh workflow run deploy-app-docker-image.yml \
  -f feature_image_tag=0.1.4 \
  -f branch=feature/TICKET-123-description
```

## Monitor Build

```bash
# Watch in real-time
gh run watch

# List recent builds
gh run list --workflow=deploy-app-docker-image.yml --limit 5

# View build logs
gh run view <run_id> --log
```

## Common Issues

- "exec format error" - Platform mismatch (linux/arm64), retry the workflow
- "Cannot find module" - Missing dependency in package.json
- Workflow name collision - Use exact filename, not display name
