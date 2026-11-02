# Kubernetes Rolling Update and Rollback

## Environment

- Kubernetes v1.36.6
- Three-node kubeadm cluster on GCP
- Calico VXLAN networking
- NGINX Deployment with three replicas

## Initial Deployment

The NGINX Deployment successfully started three replicas across
two worker nodes.

## Incident 1: Rolling Update Stuck

The Deployment was updated with:

- maxSurge: 1
- maxUnavailable: 0
- Readiness and liveness probes
- Topology spread constraints

One new Pod remained Pending.

The scheduler reported:

    0/3 nodes are available:
    1 node(s) had untolerated taint(s),
    2 node(s) didn't match pod topology spread constraints.

The exact reason for the topology calculation was not fully
investigated.

### Resolution

Changed:

    whenUnsatisfiable: DoNotSchedule

To:

    whenUnsatisfiable: ScheduleAnyway

This changed the topology constraint from a hard scheduling
requirement to a scheduling preference.

The Deployment subsequently completed its rollout with
three available replicas.

## Incident 2: Invalid Container Image

An intentionally invalid NGINX image was deployed:

    nginx:invalid-version-for-rollback-test

The new Pod entered ErrImagePull.

Because maxUnavailable was set to zero, the existing three
healthy replicas remained available during the failed rollout.

### Recovery

Executed:

    kubectl rollout undo deployment/nginx-app -n app-lab

Verified:

    kubectl rollout status deployment/nginx-app -n app-lab
    kubectl get deployment nginx-app -n app-lab

The Deployment returned to:

- Image: nginx:stable-alpine
- Ready replicas: 3/3
- Updated replicas: 3/3
- Available replicas: 3/3

## Lessons Learned

1. Scheduling constraints can prevent rolling updates.
2. maxSurge allows temporary additional Pods during updates.
3. maxUnavailable: 0 preserves the configured minimum availability.
4. ErrImagePull can block an otherwise healthy Deployment rollout.
5. kubectl rollout undo can restore a previous healthy Pod template.
6. Imperative rollback can leave the last-applied annotation
   inconsistent with declarative configuration.
7. Production releases should use immutable image tags or digests.

## Evidence

See:

    docs/evidence/kubeadm/rollout/
