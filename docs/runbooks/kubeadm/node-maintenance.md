# Kubernetes Worker Node Maintenance

## Environment

- Kubernetes v1.36.6
- Three-node kubeadm cluster on GCP
- Calico VXLAN CNI
- NGINX Deployment: 3 replicas
- Maintenance target: k8s-worker-1

## Initial State

All three nodes were Ready.

NGINX distribution:
- Worker 1: 2 Pods
- Worker 2: 1 Pod

## Preflight Inspection

The dry-run initially failed because a standalone
BusyBox Pod (network-test/test-client) had no controller.

The completed network test Pod was deleted before draining.

## Maintenance Procedure

Executed:

    kubectl drain k8s-worker-1 --ignore-daemonsets --timeout=180s

Kubernetes:
- Cordoned Worker 1
- Evicted two NGINX Pods
- Evicted a Calico Typha Pod
- Left DaemonSet-managed Pods running
- Created replacement NGINX Pods on Worker 2

## Observed Result

- Worker 1: Ready,SchedulingDisabled
- Worker 2: Ready
- NGINX Deployment: 3/3 available
- All three NGINX Pods running on Worker 2

## Restore Node

Executed:

    kubectl uncordon k8s-worker-1

Worker 1 returned to Ready.

The NGINX Pods remained on Worker 2 because Kubernetes
does not automatically rebalance existing Pods after uncordoning.

## Lessons Learned

1. Drain performs graceful eviction, not VM shutdown.
2. Standalone Pods can block a drain unless handled explicitly.
3. DaemonSet Pods are ignored with --ignore-daemonsets.
4. Deployment controllers create replacement Pods.
5. Uncordon allows scheduling but does not migrate existing Pods.
6. Graceful drain does not prove recovery from sudden VM failure.
7. Continuous HTTP availability was not measured during the drain.

## Evidence

docs/evidence/kubeadm/node-maintenance/
