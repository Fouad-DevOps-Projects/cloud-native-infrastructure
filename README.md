# Cloud Native Infrastructure

A hands-on cloud and platform engineering project focused on designing,
provisioning, securing, and operating cloud-native infrastructure on
Google Cloud Platform.

## Objectives

- Provision cloud infrastructure using Terraform.
- Build and operate Kubernetes clusters.
- Implement GitOps-based application delivery.
- Automate CI/CD pipelines using GitHub Actions.
- Apply infrastructure and workload security best practices.
- Monitor infrastructure and application health.

## Technology Stack

| Area | Technologies |
|---|---|
| Cloud | Google Cloud Platform |
| Infrastructure as Code | Terraform |
| Containers | Docker |
| Kubernetes | K3s, kubeadm, GKE |
| Package Management | Helm |
| GitOps | Argo CD |
| CI/CD | GitHub Actions |
| Monitoring | Prometheus, Grafana |
| Version Control | Git, GitHub |

## Learning and Implementation Roadmap

### Phase 1 — K3s on GCP
- Provision a Compute Engine VM using Terraform.
- Configure a K3s Kubernetes cluster.
- Deploy a sample application.
- Configure networking and security.

### Phase 2 — Kubernetes with kubeadm
- Build a multi-node Kubernetes cluster.
- Understand control plane components.
- Configure networking, certificates, and cluster operations.

### Phase 3 — Google Kubernetes Engine
- Provision a GKE cluster.
- Configure node pools and autoscaling.
- Integrate Google Cloud IAM.

### Phase 4 — GitOps and CI/CD
- Build CI pipelines using GitHub Actions.
- Package applications using Helm.
- Deploy applications through Argo CD.

### Phase 5 — Observability and Security
- Deploy Prometheus and Grafana.
- Implement monitoring and alerting.
- Apply Kubernetes and cloud security practices.

## Project Status

🚧 In progress — environment setup and architecture design.

## Cost Awareness

Cloud resources will be provisioned only after reviewing the Terraform
plan and estimated costs. Resources will be shut down or removed when
they are no longer needed.

## Repository Structure

```text
.
├── .github/
│   └── workflows/
├── apps/
│   └── sample-api/
├── argocd/
│   └── applications/
├── docs/
│   ├── architecture/
│   ├── decisions/
│   └── runbooks/
├── helm/
├── kubernetes/
│   ├── gke/
│   ├── kubeadm/
│   ├── k3s/
│   └── namespaces/
├── scripts/
└── terraform/
    ├── environments/
    │   └── dev/
    └── modules/
