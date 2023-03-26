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
else
    # Run docker-compose on the target server
    ssh -o StrictHostKeyChecking=no ${SERVER_USERNAME}@${SERVER_HOST} && docker-compose up -d
    echo "Deployment successful"
fi
