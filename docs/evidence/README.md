# Evidence index

The portfolio distinguishes historical Kubernetes test output from live GitHub CI checks and unverified deployment configurations.

| Area | Evidence | Verified outcome |
|---|---|---|
| Single-node K3s | [Cluster status](k3s/cluster-status.txt) | Historical operational cluster snapshot |
| Three-node kubeadm | [Nodes](kubeadm/nodes.txt), [Calico](kubeadm/calico-status.txt), [Services](kubeadm/services.txt) | Cluster and networking experiments |
| Rollout and rollback | [Deployment snapshots](kubeadm/rollout/), [Runbook](../runbooks/kubeadm/rolling-update-rollback.md) | Application rollout and recovery |
| Planned drain | [Maintenance outputs](kubeadm/node-maintenance/), [Runbook](../runbooks/kubeadm/node-maintenance.md) | Pod evacuation and node uncordon |
| Worker failure | [Before/after](kubeadm/worker-failure/), [Runbook](../runbooks/kubeadm/worker-failure-recovery.md) | Two replacement Pods on surviving worker, Deployment returned to 3/3 |
| API tests, Helm, image | [Successful CI run #6](https://github.com/Fouad-DevOps-Projects/cloud-native-infrastructure/actions/runs/41469595769) | All three jobs passed |
| Security | [Successful run #18](https://github.com/Fouad-DevOps-Projects/cloud-native-infrastructure/actions/runs/41471185759) | Active security gates passed; historical issues archived separately |

## Worker failure proof path

1. [Baseline Deployment](kubeadm/worker-failure/deployment-before.txt).
2. [Node NotReady](kubeadm/worker-failure/nodes-during-failure.txt).
3. [Recovered Deployment](kubeadm/worker-failure/deployment-after-recovery.txt).
4. [Rescheduled Pod placement](kubeadm/worker-failure/pods-after-recovery.txt).
5. [Restored worker node](kubeadm/worker-failure/nodes-after-restoration.txt).

**Evidence limitations:** These snapshots do not establish exact outage duration or HTTP request continuity. No live GKE, Argo CD sync or Prometheus/Grafana dashboard has been verified. The underlying Compute Engine lab VMs were deleted after evidence collection.
