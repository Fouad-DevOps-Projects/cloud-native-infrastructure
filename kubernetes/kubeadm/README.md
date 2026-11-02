# Self-Managed Kubernetes Cluster on GCP

## Overview

Three-node Kubernetes v1.36.6 cluster deployed on Google Cloud
using Terraform and kubeadm.

Unlike GKE, this cluster is self-managed: the Kubernetes control plane,
container runtime, and CNI were configured manually.

## Architecture

| Node | Role | Internal IP |
|------|------|-------------|
| k8s-control-plane | Control plane | 10.30.0.10 |
| k8s-worker-1 | Worker | 10.30.0.11 |
| k8s-worker-2 | Worker | 10.30.0.12 |

## Technologies

- Google Cloud Compute Engine
- Terraform
- Ubuntu 24.04 LTS
- Kubernetes v1.36.6
- kubeadm, kubelet, kubectl
- containerd 2.2.1
- Calico CNI with VXLAN
- Google Cloud IAP for SSH access

## Networking

| Network | CIDR |
|---------|------|
| GCP subnet | 10.30.0.0/24 |
| Pod network | 192.168.0.0/16 |
| Service network | 10.96.0.0/12 |

## Security

- SSH restricted through Google Cloud IAP
- No public Kubernetes API ingress firewall rule
- Kubernetes API advertised on private IP 10.30.0.10
- Kubernetes credentials and Terraform state excluded from Git

## Networking Validation

The following tests passed:

1. All three Kubernetes nodes reached Ready.
2. Calico node agents became healthy on all three nodes.
3. BusyBox Pod on Worker 1 successfully accessed NGINX on Worker 2.
4. CoreDNS resolved the web-service DNS name.
5. ClusterIP Service routed HTTP traffic to the NGINX Pod.
6. EndpointSlice referenced the correct NGINX Pod IP.

## Reproduce the Networking Test

From the repository root, apply:

    kubectl apply -f kubernetes/kubeadm/network-test/pods.yaml
    kubectl apply -f kubernetes/kubeadm/network-test/service.yaml

These manifests require worker nodes named k8s-worker-1 and k8s-worker-2.

Verify:

    kubectl get pods -n network-test -o wide
    kubectl get svc -n network-test

Test DNS:

    kubectl exec -n network-test test-client -- nslookup web-service.network-test.svc.cluster.local

Test HTTP:

    kubectl exec -n network-test test-client -- wget -qO- http://web-service.network-test.svc.cluster.local

## Evidence

Point-in-time verification snapshots:

    docs/evidence/kubeadm/

## Terraform

Infrastructure configuration:

    terraform/environments/kubeadm/

Destroy temporary GCP lab resources when they are no longer needed
to avoid continued cloud charges.
