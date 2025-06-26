#!/usr/bin/env bash

# --- Configurazione ---
# Tag per le immagini
LLM_SERVER_IMG="demo-llm-server:latest"
SPRING_LLM_IMG="demo-llm:latest"

# Percorsi relativi ai Dockerfile
LLM_SERVER_DIR="./llm-server"
SPRING_LLM_DIR="./llm-spring"

# Manifest Kubernetes
K8S_MANIFEST="./k8s-demo-llm.yaml"
K8S_NAMESPACE="demo-llm"

# --- Build immagini Docker ---
echo "Building LLM Server image (${LLM_SERVER_IMG})..."
docker build -t "${LLM_SERVER_IMG}" "${LLM_SERVER_DIR}"

echo "Building Spring LLM image (${SPRING_LLM_IMG})..."
docker build -t "${SPRING_LLM_IMG}" "${SPRING_LLM_DIR}"

# --- Deploy su Kubernetes ---
echo "Applying Kubernetes manifest (${K8S_MANIFEST})..."
kubectl apply -f "${K8S_MANIFEST}"