# ECS Deployment - ECS Service Deployment

**Workflow:** `deploy-app-ecs.yml`

## Trigger Deployment

**After Docker build succeeds:**

```bash
gh workflow run deploy-app-ecs.yml \
  -f environment=dev \
  -f image_tag=0.1.4 \
  -f branch=feature/TICKET-123-description

# Monitor deployment
gh run watch
```

## Blue-Green Deployment Process

- New task definition created with updated image tag
- New tasks started in ECS cluster
- Health checks pass
- ALB switches traffic to new tasks
- Old tasks drained and stopped
