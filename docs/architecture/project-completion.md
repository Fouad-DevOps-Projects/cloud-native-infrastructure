# Project completion and evidence report

## Historical Kubernetes lab work

- Terraform-provisioned K3s and three-node kubeadm environments on Google Cloud.
- Captured cross-node networking, service discovery, rollout/rollback, planned drain, and worker-failure replacement evidence.
- These older VMs were subsequently destroyed to control cloud costs.

## Verified GKE + delivery + observability demonstration

On 2 November 2026, a zonal GKE Standard cluster with one healthy worker was deployed using Terraform. A private GHCR FastAPI image was deployed with Helm through Argo CD, and the Application reached **Synced / Healthy** with **two ready Pods**.

The FastAPI health endpoints and `/metrics` responded. Prometheus discovered and scraped both API Pod endpoints (`2/2 UP`), and Grafana displayed live metrics. These observations are supported by [four real screenshots and raw CLI outputs](../evidence/gke/README.md).

GitHub Actions automation also passed [CI run #6](https://github.com/Fouad-DevOps-Projects/cloud-native-infrastructure/actions/runs/41469595769) and [Security run #18](https://github.com/Fouad-DevOps-Projects/cloud-native-infrastructure/actions/runs/41471185759).

## Outstanding closure

1. **Cost control — highest priority:** Destroy the GKE Terraform deployment, verify empty state and no remaining GKE cluster or Compute Engine workers, and capture sanitized teardown evidence.
2. Review and update references after resource teardown; historical proof should never be presented as a currently active service.
3. Optional enhancement: demonstrate an actual alert firing and alert notification. Running Alertmanager alone does not prove alert delivery.

## Evidence policy

Historical test outputs and successful workflow URLs are evidence. Repository configuration alone is not evidence of deployment. Do not publish credentials or sensitive Terraform files.
