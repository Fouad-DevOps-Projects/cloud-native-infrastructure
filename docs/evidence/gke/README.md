# GKE Deployment — Visual Evidence Gallery

[← Main portfolio README](../../../README.md) · [Architecture](../../architecture/portfolio-overview.md) · [Evidence index](../README.md)

This gallery documents the **real GKE, Argo CD, private GHCR, Prometheus and Grafana deployment** validated in November 2026. Screenshots show the temporary live environment; they are historical evidence, not proof that it remains running.

## Observability: Grafana dashboard

[![Grafana: request rate, HTTP success counters, and healthy Prometheus targets](grafana-dashboard.png)](grafana-dashboard.png)

*Actual Grafana dashboard from GKE. API request rate, HTTP status counters and two healthy scrape targets were displayed. Counter values include health checks and are snapshots, not lifetime traffic totals.*

## Live deployment evidence

| Stage | Observed verification | Captured artifacts |
|---|---|---|
| GKE Standard cluster | Single zonal cluster, one worker Ready, 2 vCPUs and 8 GiB RAM | [Node output](nodes.txt), [Version](kubernetes-version.txt) |
| Argo CD GitOps | Application Synced / Healthy, two running Pods | [Argo CD status](argocd-applications.txt), [Argo CD components](argocd-pods.txt) |
| Private GHCR image | Authenticated image pull using Kubernetes Secret; immutable SHA image deployed | [Deployed image](deployed-image.txt), [Deployment status](sample-api-resources.txt) |
| Prometheus Operator | 2 / 2 FastAPI targets scraped, metric series returned | [Prometheus query JSON](prometheus-query.json), [ServiceMonitor](servicemonitor.yaml) |
| Grafana | Dashboard with three live panels | [Grafana screenshot](grafana-dashboard.png) |
| Monitoring stack | Prometheus, Grafana, Alertmanager and exporters running | [Monitoring Pods](monitoring-pods.txt) |

## Additional screenshots to publish

Three more screenshots were captured during the session and can be added to this folder once copied from the Windows Screenshots directory:

- `gke-cluster-overview.png` — Google Cloud Console GKE status.
- `argocd-resource-tree.png` — Application health, sync and the Deployment → ReplicaSet → Pods topology.
- `prometheus-targets.png` — Prometheus Targets page, including the `sample-api` ServiceMonitor showing **2/2 up**.

When the three files are uploaded, add the following Markdown to this gallery to display them directly:

```md
### GKE cluster
![GKE cluster status](gke-cluster-overview.png)

### GitOps resource tree
![Argo CD synced and healthy](argocd-resource-tree.png)

### Prometheus scrape targets
![Prometheus 2/2 API targets UP](prometheus-targets.png)
```

**Credential safety:** Do not upload GitHub PATs, `argocd-initial-admin-secret`, kubeconfig, Terraform state, or Grafana passwords. Image pull credentials remain inside Kubernetes and are not stored in Git.

**Teardown:** As soon as the evidence is committed, use Terraform destroy from `terraform/environments/gke` and verify all billable resources have been deleted. If the cluster hasn't been destroyed, it continues incurring costs.
