#!/bin/bash

# Build Docker image
docker build -t tbmc93/tp38:v2 .

# Tag and push sur Docker Hub
docker tag tbmc93/tp38:v1 tbmc93/tp38:v1
docker push tbmc93/tp38:v1

# Apply Kubernetes deployment
sudo kubectl apply -f goweb-deploy.yaml

# Check deployment status
sudo kubectl rollout status deployment/mon-deployment

# Get services and pods
sudo kubectl get services
sudo kubectl get pods