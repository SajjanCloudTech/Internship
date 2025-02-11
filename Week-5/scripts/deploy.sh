#!/bin/bash

ECR_REPO="your-account-id.dkr.ecr.us-east-1.amazonaws.com/nodejs-app"

echo "Pulling Docker image from ECR..."
docker pull $ECR_REPO:latest

echo "Stopping existing container..."
docker ps -q -f name=nodejs-app && docker stop nodejs-app && docker rm nodejs-app || echo "No running container found."

echo "Running new container..."
docker run -d -p 3000:3000 --name nodejs-app $ECR_REPO:latest

echo "Deployment successful!"
