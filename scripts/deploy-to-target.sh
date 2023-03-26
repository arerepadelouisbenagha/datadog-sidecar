#!/bin/bash


# Get variables from environment
DOCKER_USERNAME="${DOCKER_USERNAME:-dockerhub-username}"
DOCKER_PASSWORD="${DOCKER_PASSWORD:-dockerhub-token}"
DOCKER_IMAGE="${DOCKER_IMAGE:-elitesolutionsit/datadogsidecar:v1}"
SERVER_USERNAME="${SERVER_USERNAME:-ubuntu}"
SERVER_HOST="${SERVER_HOST:-52.3.224.2}"

# Check if variables are set
if [[ -z $DOCKER_USERNAME || -z $DOCKER_PASSWORD || -z $DOCKER_IMAGE || -z $SERVER_USERNAME || -z $SERVER_HOST ]]; then
    echo "Error: One or more required variables are not set."
    exit 1
fi

# Log in to DockerHub, pull the image, and run docker-compose on the target server
ssh -o StrictHostKeyChecking=no ${SERVER_USERNAME}@${SERVER_HOST} "
  echo '${DOCKER_PASSWORD}' | docker login --username '${DOCKER_USERNAME}' --password-stdin
  docker-compose up -d
"

echo "Deployment successful"
