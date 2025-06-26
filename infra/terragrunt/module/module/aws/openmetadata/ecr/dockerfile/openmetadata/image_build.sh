#!/bin/bash

# The directory containing the Dockerfile
cd "$(dirname "$0")"

# Login to the ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# bot token
openssl genrsa -out conf/private_key.pem 2048
openssl pkcs8 -topk8 -inform PEM -outform DER -in conf/private_key.pem -out conf/private_key.der -nocrypt
openssl rsa -in conf/private_key.pem -pubout -outform DER -out conf/public_key.der

mvn clean install -DskipTests -f openmetadata-dist/pom.xml

# Build the Docker image
docker build -t openmetadata/server .
docker tag openmetadata/server $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/openmetadata/server:$TAG
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/openmetadata/server:$TAG

# Remove the Docker image
docker rmi $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/openmetadata/server:$TAG

# Remove build cache
docker builder prune -a -f