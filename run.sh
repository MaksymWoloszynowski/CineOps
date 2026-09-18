#!/usr/bin/env bash
set -e

NAMESPACE_FILE="namespace.yaml"

echo "Starting deployment..."

echo "Applying namespace..."
kubectl apply -f k8s/$NAMESPACE_FILE

echo "Deploying PostgreSQL..."
kubectl apply -f k8s/postgres/postgres-secrets.yaml
kubectl apply -f k8s/postgres/postgres-service.yaml
kubectl apply -f k8s/postgres/postgres-config.yaml
kubectl apply -f k8s/postgres/postgres-pvc.yaml
kubectl apply -f k8s/postgres/postgres-stateful.yaml

echo "Deploying Redis..."
kubectl apply -f k8s/redis/redis-service.yaml
kubectl apply -f k8s/redis/redis-deployment.yaml
kubectl apply -f k8s/redis/redis-network.yaml

echo "Deploying Backend..."
kubectl apply -f k8s/backend/backend-secrets.yaml
kubectl apply -f k8s/backend/backend-configmap.yaml
kubectl apply -f k8s/backend/backend-service.yaml
kubectl apply -f k8s/backend/backend-deployment.yaml
kubectl apply -f k8s/backend/backend-hpa.yaml
kubectl apply -f k8s/backend/backend-network.yaml

echo "Deploying Frontend..."
kubectl apply -f k8s/frontend/frontend-configmap.yaml
kubectl apply -f k8s/frontend/frontend-service.yaml
kubectl apply -f k8s/frontend/frontend-deployment.yaml

echo "Deploying Kubernetes..."
kubectl apply -f k8s/keycloak/keycloak-secrets.yaml
kubectl apply -f k8s/keycloak/keycloak-service.yaml
kubectl apply -f k8s/keycloak/keycloak-deployment.yaml

echo "Applying network policies..."
kubectl apply -f k8s/network.yaml
kubectl apply -f k8s/postgres/postgres-network.yaml
kubectl apply -f k8s/redis/redis-network.yaml
kubectl apply -f k8s/backend/backend-network.yaml

echo "Applying ingress..."
kubectl apply -f k8s/ingress.yaml

echo "Deployment finished!"

echo "Cluster status:"
kubectl get pods -n cineops

kubectl config set-context --current --namespace=cineops