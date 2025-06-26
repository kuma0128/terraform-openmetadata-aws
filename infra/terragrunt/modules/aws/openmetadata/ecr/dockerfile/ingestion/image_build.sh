#!/bin/bash

# The directory containing the Dockerfile
cd "$(dirname "$0")"

# Login to the ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build the Docker image
docker build -t openmetadata/ingestion .
docker tag openmetadata/ingestion $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/openmetadata/ingestion:$TAG
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/openmetadata/ingestion:$TAG

# Remove the Docker image
docker rmi $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/openmetadata/ingestion:$TAG

# Remove build cache
docker builder prune -a -f