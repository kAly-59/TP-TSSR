#!/bin/bash

# Function to build Docker img
build_docker_img() {
    docker build -t tbmc93/tp38:v2 .
}

# Function to tag and push Docker image to Docker Hub
tag_and_push_docker_img() {
    docker tag tbmc93/tp38:v2 tbmc93/tp38:v2
    docker push tbmc93/tp38:v2
}

# Function to open Kubernetes deployment
open_kubernetes_deployment() {
    sudo nano /home/mysiteweb/goweb-deploy.yaml
}

# Function to apply Kubernetes deployment
apply_kubernetes_deployment() {
    sudo kubectl apply -f goweb-deploy.yaml
}

# Function to check deployment status
check_deployment_status() {
    sudo kubectl rollout status deployment/mon-deployment
}

# Function to get services and pods
get_services_and_pods() {
    sudo kubectl get services
    sudo kubectl get pods
}

# Function to display menu
show_menu() {
    echo "1) Build Docker image"
    echo "2) Tag and push Docker image to Docker Hub"
    echo "3) Open Kubernetes deployment"
    echo "4) Apply Kubernetes deployment"
    echo "5) Check deployment status"
    echo "6) Get services and pods"
    echo "7) Exit"
}

# Menu
while true; do
    show_menu
    read -p "Choose an option: " choice
    case $choice in
        1)
            build_docker_img
            ;;
        2)
            tag_and_push_docker_img
            ;;
        3)
            apply_kubernetes_deployment
            ;;
        4)
            apply_kubernetes_deployment
            ;;
        5)
            check_deployment_status
            ;;
        6)
            get_services_and_pods
            ;;
        7)
            echo "Exit"
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done