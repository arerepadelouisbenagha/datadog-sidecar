#!/bin/bash

# Get variables from environment
DOCKER_USERNAME="${DOCKER_USERNAME:-dockerhub-username}"
DOCKER_PASSWORD="${DOCKER_PASSWORD:-dockerhub-token}"
SERVER_USERNAME="ubuntu"
SERVER_HOST="44.205.16.50"
datadog_api_key="${DATADOG_API_KEY:-datadog_api_key}"

# Run as non root user
sudo usermod -aG docker $USER

sed "s/${datadog_api_key}/${DATADOG_API_KEY}/g" datadog-sidecar/datadog-sidecar/datadog-config.yml

# Check if variables are set
if [[ -z $DOCKER_USERNAME || -z $DOCKER_PASSWORD || -z $SERVER_USERNAME || -z $SERVER_HOST ]]; then
    echo "Error: One or more required variables are not set."
    exit 1
else
    # Run docker-compose on the target server
    docker-compose --env-file <(echo "datadog_api_key=${datadog_api_key}") up -d
    echo "Deployment successful"
fi
