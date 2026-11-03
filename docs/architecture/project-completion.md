# Project completion and evidence report

## Historical Kubernetes lab work

- Terraform-provisioned K3s and three-node kubeadm environments on Google Cloud.
- Captured cross-node networking, service discovery, rollout/rollback, planned drain, and worker-failure replacement evidence.
- These older VMs were subsequently destroyed to control cloud costs.

## Verified GKE + delivery + observability demonstration

On 2 November 2026, a zonal GKE Standard cluster with one healthy worker was deployed using Terraform. A private GHCR FastAPI image was deployed with Helm through Argo CD, and the Application reached **Synced / Healthy** with **two ready Pods**.

The FastAPI health endpoints and `/metrics` responded. Prometheus discovered and scraped both API Pod endpoints (`2/2 UP`), and Grafana displayed live metrics. These observations are supported by [four real screenshots and raw CLI outputs](../evidence/gke/README.md).

GitHub Actions automation also passed [CI run #6](https://github.com/Fouad-DevOps-Projects/cloud-native-infrastructure/actions/runs/41469595769) and [Security run #18](https://github.com/Fouad-DevOps-Projects/cloud-native-infrastructure/actions/runs/41471185759).

## Verified teardown and remaining boundary

On **3 November 2026**, `terraform destroy` completed with **2 resources destroyed** (the `primary` node pool and `portfolio-gke` cluster). Follow-up checks found an empty Terraform state and no GKE clusters, Compute Engine instances, persistent disks, reserved IPs, forwarding rules or snapshots in the project. See the [teardown verification](../evidence/gke/teardown/README.md). The repository retains the deployed configuration and captured evidence for reproducibility.

One separately created GCP Secret Manager secret (`sre-ghcr-dockerconfig`) was still present at verification time and is not covered by this Terraform state. Its cleanup requires a separate decision. An actual external Alertmanager notification and continuously measured HTTP downtime were not demonstrated; these are scope boundaries, not failures of the verified deployment.

## Evidence policy

Historical test outputs and successful workflow URLs are evidence. Repository configuration alone is not evidence of deployment. Do not publish credentials or sensitive Terraform files.
