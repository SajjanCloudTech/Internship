#!/bin/bash

# Exit immediately if a command fails
set -e

# Define variables
AWS_REGION="us-east-2"  # Update to match your AWS region
ECR_REPO_URL="664418970145.dkr.ecr.us-east-2.amazonaws.com/nodejs-todo-app"
APP_NAME="todoapp"
APP_DIR="/var/www/app"
PORT=3000

# Log in to AWS ECR
echo "Logging into AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URL

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
if [ "$(docker images -q $ECR_REPO_URL)" ]; then
    echo "Removing existing image..."
    docker rmi $ECR_REPO_URL
fi

# Pull the latest image from ECR
echo "Pulling the latest image from ECR..."
docker pull $ECR_REPO_URL:latest

# Run the new container
echo "Starting new container..."
docker run -d -p $PORT:3000 --name $APP_NAME $ECR_REPO_URL:latest

echo "Deployment successful!"
