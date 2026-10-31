# Runbook: Kubernetes Pod Troubleshooting

## 1. Inspect cluster health

```bash
kubectl get nodes -o wide
kubectl get pods -A
kubectl get deployments
kubectl get services
```

## 2. Inspect a failing Pod

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
```

## 3. ImagePullBackOff

Inspect the Pod events:

```bash
kubectl describe pod <pod-name>
```

Check the image name, tag, registry access, and image pull credentials.

## 4. CrashLoopBackOff

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name> --previous
```

Check the container command, arguments, application logs, configuration, and resource constraints.

## 5. Readiness probe failures

A failed readiness probe marks a Pod as not ready. It does not necessarily restart the container.

```bash
kubectl describe pod <pod-name>
kubectl get endpointslices
```

Check the probe path, port, startup time, and endpoint membership.

## 6. Liveness probe failures

A failed liveness probe can cause the kubelet to restart the container.

```bash
kubectl describe pod <pod-name>
kubectl get pods
```

Check the probe path, port, timeout, period, and failure threshold.

## 7. Verify recovery

```bash
kubectl get pods -o wide
kubectl get deployments
kubectl get endpointslices
kubectl get events --sort-by=.metadata.creationTimestamp
```
