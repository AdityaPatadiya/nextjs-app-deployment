# 🚀 Next.js Application Deployment using Docker, GitHub Actions, and Minikube

This project demonstrates the complete DevOps workflow of **containerizing**, **automating**, and **deploying** a Next.js application using **Docker**, **GitHub Actions**, **GitHub Container Registry (GHCR)**, and **Kubernetes (Minikube)**.

---

## 📋 Objectives

- Containerize a Next.js application using Docker
- Automate build and image push using GitHub Actions and GHCR
- Deploy the containerized app to Minikube using Kubernetes manifests
- Implement best practices for CI/CD, scalability, and health monitoring

---

## 🏗️ Project Architecture

```bash
flowchart LR
    A[Next.js App] --> B[Dockerfile]
    B --> C[GitHub Actions]
    C --> D[GHCR - GitHub Container Registry]
    D --> E[Kubernetes (Minikube)]
    E --> F[User Access via NodePort Service]
```

## Tech Stack
- Next.js
- Docker
- GitHub Actions (CI/CD)
- GitHub Container Registry (GHDR)
- Kubernetes (Minikube)

## Setup Instruction
1. Clone the Repo:
```bash
git clone https://github.com/AdityaPatadiya/nextjs-app-deployment.git
cd nextjs-app-deployment
```

2. Run Locally (Optional)
```bash
npm install
npm run dev
```

## Docker Setup
### Build the Docker Image
```bash
docker build -t nextjs-k8s-demo .
```

### Run the Container Locally
```bash
docker run -p 3000:3000 nextjs-k8s-demo
```

- Access it at: http://localhost:3000

## Github Actions Workflow
- The workflow is located at `.github/workflows/docker-image.yml`
- It automatically:
  
  1. Builds the Docker image on every push to the main branch
  2. Tags and pushes it to GHCR
  3. Uses the image in Kubernetes deployment

## Github Container Registry (GHCR)
Image URL:
[nextjs-k8s-demo](https://ghcr.io/AdityaPatadiya/nextjs-k8s-demo)


## Kubernetes Deployment
- `deployment.yaml` — defines pods, replicas, and health checks
- `service.yaml` — exposes the app via NodePort

### 1. Start Minikube
```bash
minikube start
```

### 2. Apply Manigests
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 3. Verify Pods and Services
```bash
kubectl get pods
kubectl get svc
```

### 4. Access the Application
```bash
minikube service nextjs-service
```

or manually open:
http://<MINIKUBE_IP>:<NODE_PORT>
Example:
```bash
http://192.168.49.2:30001
```

## Health Check
The container includes a health check to ensure the application is running properly:
```bash
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
    CMD wget -qO- http://localhost:3000/ || exit 1
```
