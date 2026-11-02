# Validation and evidence register

## Live-tested experiments (recorded)

- **K3s and kubeadm:** Historical GCP Kubernetes experiments documented under [evidence](../evidence/README.md), including network validation, rollbacks, worker drain and outage recovery. These older VMs were destroyed after testing.
- **GKE Standard:** One zonal node was verified `Ready` on 2 November 2026. [Cluster screenshot](../evidence/gke/gke-cluster-overview.png), [kubectl output](../evidence/gke/nodes.txt).
- **Argo CD:** `sample-api` was observed `Synced` / `Healthy` with 2/2 ready Pods. [Resource tree screenshot](../evidence/gke/argocd-resource-tree.png), [application status](../evidence/gke/argocd-applications.txt).
- **Private GHCR image:** Authentication via Kubernetes pull Secret and deployment of an immutable SHA-tagged image were verified. Tokens are not in Git.
- **Prometheus:** Real scrape results from both API replicas, with 2/2 targets UP. [Targets screenshot](../evidence/gke/prometheus-targets.png), [query response](../evidence/gke/prometheus-query.json).
- **Grafana:** A live dashboard with API request rate, HTTP success counters and healthy target count was recorded. [Dashboard screenshot](../evidence/gke/grafana-dashboard.png).

## Automated tests

- [Sample API CI run #6](https://github.com/Fouad-DevOps-Projects/cloud-native-infrastructure/actions/runs/41469595769): successful Python, Helm and image jobs.
- [Security run #18](https://github.com/Fouad-DevOps-Projects/cloud-native-infrastructure/actions/runs/41471185759): successful security job, with historical IaC findings reported separately.
- [GKE Terraform validation](../../.github/workflows/terraform-gke-validate.yml): formatting, initialization and schema validation workflow.

## Not yet verified

- **Teardown of the final GKE lab:** Do not claim deletion without `terraform destroy` output, empty Terraform state and an empty GKE cluster list.
- An alert firing and notification delivery test was not recorded; the Alertmanager Pod was running, but this is not alert-delivery evidence.
- Precise HTTP downtime or recovery time during the earlier kubeadm worker failure was not continuously measured.
- A persistent, always-on production deployment is not claimed.

## Evidence integrity

Screenshots and CLI outputs describe the environment when captured, not its current uptime. Never commit access tokens, Kubernetes Secrets, Terraform state, kubeconfig, or cloud credentials. See the [visual GKE gallery](../evidence/gke/README.md) for proof.
