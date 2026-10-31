# Cloud-Native Infrastructure — Architecture

## Project objective

Build a practical cloud-native DevOps environment using infrastructure
as code, Kubernetes, GitOps, CI/CD, observability, and security automation.

## Current implementation

The current development environment runs on Google Cloud Platform.

### Infrastructure

- Cloud provider: Google Cloud Platform
- Region: me-central1
- Zone: me-central1-a
- Infrastructure provisioning: Terraform
- Compute: Compute Engine
- Machine type: e2-standard-2
- Operating system: Ubuntu 24.04 LTS
- Container runtime: containerd (managed by K3s)
- Kubernetes distribution: K3s
- Kubernetes access: SSH through Identity-Aware Proxy (IAP)

### Network architecture

- Dedicated VPC: k3s-lab-vpc
- Subnet: k3s-lab-subnet
- Subnet CIDR: 10.20.0.0/24
- VM internal address: 10.20.0.2
- SSH ingress: TCP 22 from Google's IAP range 35.235.240.0/20
- Kubernetes API server port 6443 is not publicly exposed.

### Architecture diagram

```text
                    Developer Workstation
                       (WSL / Ubuntu)
                              |
                              | gcloud compute ssh
                              | --tunnel-through-iap
                              v
                 Google Cloud Identity-Aware Proxy
                              |
                              | TCP 22
                              v
                 +--------------------------+
                 |       GCP Project        |
                 |                          |
                 |   k3s-lab-vpc             |
                 |   10.20.0.0/24           |
                 |                          |
                 |   +------------------+   |
                 |   |  k3s-lab-vm      |   |
                 |   |  Ubuntu 24.04    |   |
                 |   |                  |   |
                 |   |  K3s             |   |
                 |   |   - API Server   |   |
                 |   |   - Scheduler    |   |
                 |   |   - Controller   |   |
                 |   |   - containerd   |   |
                 |   |   - CoreDNS      |   |
                 |   |   - Traefik      |   |
                 |   +------------------+   |
                 +--------------------------+

```
## Kubernetes workloads implemented

The cluster has been used to practice and verify:

- Deployments and replica scaling
- ClusterIP Services
- Rolling updates and rollbacks
- ImagePullBackOff troubleshooting
- CrashLoopBackOff troubleshooting
- ConfigMaps and environment variables
- Secret consumption through environment variables and volumes
- ConfigMap volumes
- Liveness and readiness probes
- EndpointSlice inspection
- Pod restart and readiness behavior

## Security decisions

- SSH access is restricted to IAP TCP forwarding.
- Kubernetes API port 6443 is not exposed through a public ingress rule.
- OS Login is enabled.
- The VM has a dedicated service account.
- The VM service account has no additional project IAM roles.
- Terraform state, variable files, and generated plans are excluded from Git.

## Planned architecture extensions

These are roadmap items, not yet completed:

- Multi-node Kubernetes using kubeadm
- Managed Kubernetes using GKE
- Helm-based application deployment
- Argo CD and GitOps
- GitHub Actions CI/CD
- Prometheus and Grafana
- Centralized logs and distributed tracing
- DevSecOps scanning and supply-chain security
