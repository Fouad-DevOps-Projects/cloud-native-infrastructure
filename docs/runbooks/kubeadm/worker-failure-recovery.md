# Kubernetes Worker Failure and Automatic Recovery

## Environment

- GCP self-managed Kubernetes v1.36.6
- One control-plane node and two workers
- Calico VXLAN CNI
- NGINX Deployment with three replicas

## Baseline

All three nodes were Ready.

NGINX placement:
- Worker 1: two replicas
- Worker 2: one replica

Deployment availability: 3/3.

## Failure Simulation

Stopped k8s-worker-1 using Google Cloud Compute Engine
without first draining the Kubernetes node.

The Kubernetes node transitioned to NotReady.

The Deployment dropped to 1/3 available replicas.

The Pods assigned to the unavailable node temporarily
remained displayed as Running, reflecting stale Pod status.

## Failure Detection

Kubernetes added these node taints:

    node.kubernetes.io/unreachable:NoExecute
    node.kubernetes.io/unreachable:NoSchedule

Affected Pods had a 300-second NoExecute toleration.

## Automatic Recovery

After the toleration period, Kubernetes began terminating
the two affected Pods.

The ReplicaSet created two replacements on k8s-worker-2.

The Deployment returned to 3/3 available replicas while
k8s-worker-1 was still NotReady.

## Node Restoration

Started the existing worker VM again.

Verified that all three Kubernetes nodes returned to Ready.

The Deployment remained at 3/3 available replicas.

## Observations

- Kubernetes automatically detected the unavailable node.
- Node failure temporarily reduced application capacity.
- Pod status could remain stale while the node was offline.
- Replacement Pods were created after eviction processing.
- Worker 2 provided sufficient capacity for all three replicas.
- Restarting Worker 1 restored node readiness.
- Continuous HTTP availability was not measured.
- Recovery timestamps represent snapshots, not exact latency.

## Evidence

See docs/evidence/kubeadm/worker-failure/.

## Operational Lessons

1. A ReplicaSet does not instantly replace Pods on an
   unreachable node.
2. NoExecute tolerations influence recovery timing.
3. Healthy nodes need enough spare capacity for failover.
4. Pod distribution affects the impact of node failure.
5. Graceful drain and unplanned node outage are different tests.
6. Critical workloads need tested recovery objectives,
   monitoring, and appropriate availability policies.
