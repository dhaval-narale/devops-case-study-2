#!/usr/bin/env bash
set -euo pipefail

IMAGE="dhavalnarale/devops-case-study:$(git rev-parse --short HEAD)"

echo "[+] Building image: $IMAGE"
docker build -t $IMAGE .

echo "[+] Pushing image to DockerHub"
docker push $IMAGE
