# Observability blueprint (not yet deployed)

This directory provides an optional monitoring configuration for kube-prometheus-stack. To deploy to a disposable Kubernetes cluster:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace -f kubernetes/observability/monitoring-values.yaml
kubectl get pods -n monitoring
```

The API includes a Prometheus `/metrics` endpoint and the Helm Service has the matching label and port. Apply `api-servicemonitor.yaml` after the monitoring chart and sample API are deployed. Confirm actual targets using Prometheus; a ServiceMonitor manifest alone does not verify a successful scrape.

No Grafana dashboard screenshot, active alert, or successful Prometheus scrape is claimed. GitHub code and historical Kubernetes evidence are separate.
