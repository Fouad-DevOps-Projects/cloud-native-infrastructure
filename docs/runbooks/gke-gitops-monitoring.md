# Disposable GKE + Argo CD + monitoring demonstration

**Status:** Operator runbook, **not executed**. The repository includes working examples and validation, but no live GKE, Argo CD or monitoring evidence yet.

## Prerequisites and cost safety

Use a billing-enabled GCP project and enough quota for a regional cluster. This Terraform example uses a **zonal** GKE Standard cluster in `me-central1-a` with one worker node. The cluster and node still incur charges subject to billing credits and applicable free-tier credits. Check your plan and quotas carefully. Never commit Terraform state, API tokens or kubeconfig files.

The GKE API is restricted by `admin_cidr`. Use your trusted current public IPv4 `/32`, not `0.0.0.0/0`. The sample image must be accessible to cluster nodes; a private GHCR package needs an imagePullSecret.

## 1. Provision ephemeral GKE

From your WSL checkout:

```bash
cd terraform/environments/gke
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
terraform init
terraform fmt -check
terraform validate
terraform plan -out=cluster.tfplan -var="project_id=YOUR_PROJECT_ID" -var="admin_cidr=YOUR_PUBLIC_IPV4/32"
# Review resources and costs before running:
terraform apply cluster.tfplan
gcloud container clusters get-credentials portfolio-gke --zone me-central1-a --project YOUR_PROJECT_ID
kubectl get nodes -o wide
```

Capture `terraform plan` and `kubectl get nodes` output in `docs/evidence/gke/`, excluding credentials and sensitive identifiers. Running `terraform plan` may need cloud access; the CI validation workflow does not call `plan` or `apply`.

## 2. Argo CD

From repository root:

```bash
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl rollout status deployment/argocd-server -n argocd --timeout=300s
kubectl apply -f argocd/applications/sample-api.yaml
kubectl get applications -n argocd
kubectl get deploy,po,svc -n sample-api
kubectl rollout status deployment/sample-api-sample-api -n sample-api --timeout=300s
```

**Before deployment:** pin the Helm image tag to a successful GHCR SHA, and verify its visibility from GKE. `latest` is mutable and does not provide reliable GitOps promotions.

Capture actual Argo CD Application `Synced`/`Healthy` status and Deployment readiness, not just resource creation.

## 3. Prometheus and Grafana

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f kubernetes/observability/monitoring-values.yaml
kubectl rollout status deployment/monitoring-grafana -n monitoring --timeout=300s
kubectl apply -f kubernetes/observability/api-servicemonitor.yaml
kubectl get servicemonitor sample-api -n monitoring -o yaml
kubectl port-forward -n sample-api svc/sample-api-sample-api 8080:80
# In another terminal:
curl -fsS http://127.0.0.1:8080/metrics | grep sample_api_http_requests_total
```

Confirm the Prometheus **Targets** screen shows `sample-api` as UP. The ServiceMonitor and monitoring release labels must match your deployed chart's selectors.

Grafana UI can be accessed with a local `kubectl port-forward` to its service; use Helm release outputs and Kubernetes resources to verify the actual service name and admin-secret key. Create an API request counter panel using `sum(rate(sample_api_http_requests_total[5m]))`. Capture a screenshot only after actual metrics are visible.

## 4. Evidence and cleanup

Save the outputs of real commands, screenshots of Argo CD health and Grafana metric panels and a link to the successful GitHub Actions runs in `docs/evidence/gke/`. Do not store kubeconfig, Terraform plans/state, or credentials.

**Most important:** Tear down everything while authenticated to the same project:

```bash
cd terraform/environments/gke
terraform destroy -var="project_id=YOUR_PROJECT_ID" -var="admin_cidr=YOUR_PUBLIC_IPV4/32"
gcloud compute instances list --project YOUR_PROJECT_ID
gcloud container clusters list --project YOUR_PROJECT_ID
```

Cloud resource teardown is not guaranteed by deleting repository files. Check billing and networking leftovers (e.g. external load balancers, persistent disks) as well.

Do not report success of GKE, GitOps, or metrics validation until those steps have actually been executed.
