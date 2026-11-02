# Validation and evidence register

## Confirmed historical tests
- `docs/evidence/k3s/`: VM-hosted K3s application operations and captured command output.
- `docs/evidence/kubeadm/`: three-node kubeadm + Calico networking, deployment rollouts and rollback, planned drain, and worker outage recovery.
- `docs/evidence/kubeadm/worker-failure/`: pre-failure and post-recovery node, Pod, and Deployment states.
- Cloud lab infrastructure was destroyed by Terraform; the repository is reproducible, but **no live GCP cluster is currently claimed**.

## Automation
- `sample-api-ci.yml`: Python tests, Helm lint/template, Docker image build.
- `sample-api-ci.yml`: publishes a sample API container image to GHCR on main after validation.
- `security.yml`: Trivy filesystem and configuration checks.
- GitHub Actions execution history is the source of truth for job outcomes, not this document.

## Not yet established
- A successful Argo CD application synchronization has not been captured.
- GKE cluster creation, monitoring dashboards and alerting are not yet evidenced.
- HTTP service continuity across the worker outage was not continuously measured.

## Suggested proof collection
1. Save workflow run URL and job result from GitHub Actions.
2. Run `helm lint helm/sample-api` and `helm template sample-api helm/sample-api` on a test runner.
3. On a future ephemeral Kubernetes cluster, install Argo CD, apply `argocd/applications/sample-api.yaml`, then capture `kubectl get deployments,pods,svc -n sample-api` and the Argo CD Application status.
