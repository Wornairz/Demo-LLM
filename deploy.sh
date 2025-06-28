#!/usr/bin/env bash

# --- Configurazione ---
# Tag per le immagini
LLM_SERVER_IMG="demo-llm-server:latest"
SPRING_LLM_IMG="demo-spring-llm:latest"

# Percorsi relativi ai Dockerfile
LLM_SERVER_DIR="./llm-server"
SPRING_LLM_DIR="./spring-llm"

# Manifest Kubernetes
K8S_MANIFEST="./k8s-demo-llm.yaml"
K8S_NAMESPACE="demo-llm"

# --- Build Docker images ---
echo "Building LLM Server image (${LLM_SERVER_IMG})..."
docker build -t "${LLM_SERVER_IMG}" "${LLM_SERVER_DIR}"

echo "Building Spring LLM image (${SPRING_LLM_IMG})..."
docker build -t "${SPRING_LLM_IMG}" "${SPRING_LLM_DIR}"

# --- Load images into local Kubernetes cluster ---
# --- K3D ---
k3d cluster create demo-llm-cluster --port "8080:80@loadbalancer" --port "6443:6443@loadbalancer"
k3d image import -c demo-llm-cluster "${LLM_SERVER_IMG}" "${SPRING_LLM_IMG}"

# --- Kubernetes deploy ---
echo "Applying Kubernetes manifest (${K8S_MANIFEST})..."
kubectl create namespace "${K8S_NAMESPACE}"
kubectl apply -f "${K8S_MANIFEST}"
kubectl -n demo-llm port-forward svc/spring-llm 8080:80