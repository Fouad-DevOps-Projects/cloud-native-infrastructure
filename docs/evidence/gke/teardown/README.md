# Verified GKE teardown — 3 November 2026

The temporary GKE Standard lab was shut down after the portfolio deployment, incident, and performance evidence had been captured. The verification output below was provided from the operator's WSL terminal at **2026-11-03T03:04:19+02:00**.

## Terraform destroy result

```text
google_container_node_pool.primary: Destruction complete after 2m56s
google_container_cluster.portfolio: Destruction complete after 5m29s

Destroy complete! Resources: 2 destroyed.
```

The managed infrastructure was the `primary` node pool and the `portfolio-gke` cluster in Google Cloud project `cloud-native-platform-513310`, zone `me-central1-a`.

## Independent post-destroy verification

| Read-only command / check | Observed output |
|---|---|
| `terraform state list` | No resources listed |
| `gcloud container clusters list` | No clusters listed |
| `gcloud compute instances list` | Listed 0 items |
| `gcloud compute disks list` | Listed 0 items |
| `gcloud compute addresses list` | Listed 0 items |
| `gcloud compute forwarding-rules list` | Listed 0 items |
| `gcloud compute snapshots list` | Listed 0 items |

The corresponding terminal output was captured locally as `docs/evidence/gke/teardown/verification-after.txt`; commit that sanitized raw output separately to preserve the original check.

## Remaining resources and boundaries

`gcloud secrets list` still returned the **separately created** GCP Secret Manager resource `sre-ghcr-dockerconfig`, which was used for GHCR credentials in the SRE lab. It was **not** part of the two Terraform resources and its deletion was **not** verified. Do not publish secret versions or values.

These checks confirm removal of the GKE lab and selected Compute Engine resource categories, **not** the complete absence of billable Google Cloud services. Confirm any other independently provisioned resources and review billing separately.

The original deployment and observability evidence remain available in the [GKE gallery](../README.md) and the [SRE lab repository](https://github.com/Fouad-DevOps-Projects/observability-resilience-platform-lab).
