# K3s Lab

This directory contains declarative Kubernetes manifests for the K3s development cluster deployed on Google Cloud Platform.

## Components

| File | Purpose |
|---|---|
| base/nginx.yaml | NGINX Deployment and ClusterIP Service |
| base/app-config.yaml | Application ConfigMap |
| base/config-demo.yaml | ConfigMap and Secret environment variables |
| base/volume-demo.yaml | ConfigMap volume |
| base/secret-volume-demo.yaml | Secret volume |
| base/probe-demo.yaml | Liveness and readiness probes |
| examples/secret.example.yaml | Secret template with placeholder only |

## Prerequisites

- A working Kubernetes cluster
- kubectl configured for the target cluster
- A lab-only Secret created locally

## Deployment

### 1. Apply the ConfigMap

```bash
kubectl apply -f base/app-config.yaml
```

### 2. Create the lab Secret

Do not commit the actual Secret manifest. Use a lab-only password.

```bash
kubectl create secret generic app-secret \
  --from-literal=DB_PASSWORD='REPLACE_WITH_LAB_ONLY_PASSWORD' \
  --dry-run=client -o yaml | kubectl apply -f -
```

### 3. Apply the workloads

```bash
kubectl apply -f base/
```

### 4. Verify the deployment

```bash
kubectl get deployments
kubectl get pods -o wide
kubectl get services
kubectl get endpointslices
```

## Security notes

- Never commit real passwords, tokens, certificates, or kubeconfig files.
- Kubernetes Secret values are base64-encoded by default; base64 is not encryption.
- Demo workloads should not print Secret values into logs.
- Use lab-only credentials for this environment.

## Lab exercises completed

- Deployment scaling and Service connectivity
- Rolling updates and rollback
- ImagePullBackOff troubleshooting
- CrashLoopBackOff troubleshooting
- ConfigMaps and Secrets
- Read-only configuration and Secret volumes
- Readiness and liveness probes

## Environment

- Platform: Google Cloud Compute Engine
- Kubernetes distribution: K3s
- Infrastructure provisioning: Terraform
- Access: SSH through Identity-Aware Proxy (IAP)
