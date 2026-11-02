# ADR-001 — Evidence integrity and security scope

Status: Accepted

## Context

This repository preserves results of GCP-hosted K3s and kubeadm labs and includes new CI/CD, GKE, GitOps and observability configurations. Historical experimental Kubernetes manifests have high-severity findings. Cluster resources were removed after the experiments to control cloud costs.

## Decision

- Preserve original lab manifests and command output so history remains reproducible and auditable.
- Link actual GitHub Actions results for test, Helm, image and security pipelines.
- Block high/critical secrets, dependency vulnerabilities and active infrastructure misconfigurations.
- Scan historical lab IaC in a separate report-only step and publish findings as a workflow artifact; do not silently suppress them.
- Clearly mark Argo CD, GKE and observability live deployment as unverified.
- Do not invent screenshots, uptime guarantees, real-world metrics or deployment output.

## Consequences

This is a documented, source-complete and CI-tested portfolio with strong historical Kubernetes experiments. It is not marketed as a continuously operating production platform.
