# ECS Deployment - Workflow Parameters

## deploy-app-docker-image.yml

- `feature_image_tag` (NOT "tag") - Docker image version
- `branch` - Git branch to build from

## deploy-app-ecs.yml

- `environment` - dev/prod
- `image_tag` - Must match Docker image tag
- `branch` - Git branch reference
