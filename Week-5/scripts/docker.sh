#!/bin/bash

# Exit immediately if a command fails
set -e

# Define variables
APP_NAME="todoapp"
APP_DIR="/var/www/app"  # Update this if your app is in a different location
PORT=3000

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
if [ "$(docker images -q $APP_NAME)" ]; then
    echo "Removing existing image..."
    docker rmi $APP_NAME
fi

# Build the new Docker image
echo "Building new Docker image..."
docker build -t $APP_NAME .

# Run the new container
echo "Starting new container..."
docker run -d -p $PORT:3000 --name $APP_NAME 

echo "Deployment successful!"
