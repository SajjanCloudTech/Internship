#!/bin/bash

# Exit immediately if a command fails
set -e

# Define variables
APP_NAME="nodejstodoapp"
APP_DIR="/var/www/app"  # Update this if your app is in a different location
PORT=3000
ECR_REGISTRY="664418970145.dkr.ecr.us-east-2.amazonaws.com/nodejstodo"
ECR_REPO_NAME="nodejstodo"

# Authenticate with AWS ECR
echo "Logging in to AWS ECR..."
aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin $ECR_REGISTRY

# Change to the application directory
echo "Navigating to application directory: $APP_DIR"
cd $APP_DIR

# Stop and remove any existing container
if [ "$(docker ps -q -f name=$APP_NAME)" ]; then
    echo "Stopping existing container..."
    docker stop $APP_NAME
    docker rm $APP_NAME
fi

# Remove any existing Docker image
if [ "$(docker images -q $ECR_REGISTRY/$ECR_REPO_NAME:latest)" ]; then
    echo "Removing existing image..."
    docker rmi $ECR_REGISTRY/$ECR_REPO_NAME:latest
fi

# Pull the latest Docker image from AWS ECR
echo "Pulling latest Docker image from AWS ECR..."
docker pull $ECR_REGISTRY/$ECR_REPO_NAME:latest

# Run the new container
echo "Starting new container..."
docker run -d -p $PORT:3000 --name $APP_NAME $ECR_REGISTRY/$ECR_REPO_NAME:latest

echo "Deployment successful!"
