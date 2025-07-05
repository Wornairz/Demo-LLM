#!/usr/bin/env bash

# --- Configurazione ---
# Tag per le immagini
LLM_SERVER_IMAGE_NAME="demo-llm-server"
SPRING_LLM_IMAGE_NAME="demo-spring-llm"

# Percorsi relativi ai Dockerfile
LLM_SERVER_DIR="./llm-server"
SPRING_LLM_DIR="./spring-llm"

# Manifest Kubernetes
K8S_MANIFEST="./k8s-manifest-aws.yaml"
K8S_NAMESPACE="demo-llm"

# --- AWS ECR configuration from user input ---
read -p "Enter AWS Account ID: " AWS_ACCOUNT_ID
read -p "Enter AWS Region [us-east-1]: " AWS_REGION
AWS_REGION=${AWS_REGION:-us-east-1}
AWS_ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
AWS_EKS_CLUSTER_NAME=demo-llm-cluster

# --- Create AWS ECR repository ---
echo "Creating ECR repositories"
aws ecr create-repository --repository-name demo-llm-server --region "${AWS_REGION}"
aws ecr create-repository --repository-name demo-spring-llm --region "${AWS_REGION}"

echo "Authenticating Docker to ECR..."
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${AWS_ECR_URL}"

# --- Build & Push Docker images on ECR ---
echo "Building LLM Server image (${LLM_SERVER_IMAGE_NAME})..."
docker buildx build --platform linux/amd64 -t "${AWS_ECR_URL}/${LLM_SERVER_IMAGE_NAME}:latest" --push "${LLM_SERVER_DIR}"

echo "Building Spring LLM image (${SPRING_LLM_IMAGE_NAME})..."
docker buildx build --platform linux/amd64 -t "${AWS_ECR_URL}/${SPRING_LLM_IMAGE_NAME}:latest" --push "${SPRING_LLM_DIR}"

# --- Tag all subnets in the AWS account for Load Balancer ---
echo "Listing all subnet IDs in account..."
SUBNET_ARRAY=($(aws ec2 describe-subnets --query "Subnets[].SubnetId" --output text))
echo "Tagging all subnets (${SUBNET_ARRAY[*]}) for AWS Load Balancer..."
aws ec2 create-tags \
  --resources "${SUBNET_ARRAY[@]}" \
  --tags Key=kubernetes.io/role/elb,Value=1 \
         Key=kubernetes.io/role/internal-elb,Value=1 \
         Key=kubernetes.io/cluster/${AWS_EKS_CLUSTER_NAME},Value=shared \
  --region "${AWS_REGION}" 

# --- Kubernetes deploy ---
echo "Applying Kubernetes manifest (${K8S_MANIFEST})..."
kubectl create namespace "${K8S_NAMESPACE}"
envsubst < ${K8S_MANIFEST} | kubectl apply -f -