#!/usr/bin/env bash
set -euo pipefail

GIT_COMMIT=${GIT_COMMIT:-latest}
IMAGE="dhavalnarale/devops-nodejs-app:$GIT_COMMIT"
LATEST_IMAGE="dhavalnarale/devops-nodejs-app:latest"

echo "Building Docker Image: $IMAGE"
docker build -t "$IMAGE" .
docker tag "$IMAGE" "$LATEST_IMAGE"

echo "Pushing Docker Image to DockerHub: $IMAGE"
docker push "$LATEST_IMAGE"
