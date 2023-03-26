#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e



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

# Check if SSH command is available
if ! command -v ssh &> /dev/null; then
    echo "Error: SSH command not found. Please install OpenSSH client."
    exit 1
fi

# Check if docker and docker-compose are installed on the remote server, and install them if necessary
ssh -o StrictHostKeyChecking=no ${SERVER_USERNAME}@${SERVER_HOST} "
  if ! command -v docker &> /dev/null; then
    echo 'Docker not found, installing...'
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\"
    sudo apt-get update
    sudo apt-get install -y docker-ce
  fi

  if ! command -v docker-compose &> /dev/null; then
    echo 'Docker Compose not found, installing...'
    sudo apt-get update
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.17.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
"

# Log in to DockerHub, pull the image, and run docker-compose on the target server
ssh -o StrictHostKeyChecking=no ${SERVER_USERNAME}@${SERVER_HOST} "
  echo '${DOCKER_PASSWORD}' | docker login --username '${DOCKER_USERNAME}' --password-stdin
  docker-compose up -d
"

echo "Deployment successful"
