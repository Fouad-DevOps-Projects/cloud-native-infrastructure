# Observability blueprint (not yet deployed)

This directory provides an optional monitoring configuration for kube-prometheus-stack. To deploy to a disposable Kubernetes cluster:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace -f kubernetes/observability/monitoring-values.yaml
kubectl get pods -n monitoring
```

The API exposes health routes but **does not yet expose Prometheus metrics**. Do not apply the example ServiceMonitor expecting working metrics until instrumentation and chart Service labels are confirmed. The ServiceMonitor file is a future integration example.

No Grafana dashboard screenshot, active alert, or successful Prometheus scrape is claimed. GitHub code and historical Kubernetes evidence are separate.
