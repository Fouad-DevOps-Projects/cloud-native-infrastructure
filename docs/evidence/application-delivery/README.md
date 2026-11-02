# Application Delivery Verification

This directory intentionally separates **implemented configuration** from **observed execution**.

## Implemented in repository

- FastAPI sample service with liveness, readiness, and info routes.
- Python endpoint tests.
- Non-root Docker image build.
- Helm Deployment/Service, health checks, resource constraints.
- Declarative Argo CD Application.
- GitHub Actions CI and GHCR publishing workflow.

## Evidence to capture from actual executions

| Check | Evidence location | Status |
|---|---|---|
| API unit tests | GitHub Actions: Sample API CI and Image Publishing | Check run in Actions |
| Helm lint and rendering | GitHub Actions: helm job | Check run in Actions |
| Docker image build | GitHub Actions: image job | Check run in Actions |
| Image pushed to GHCR | GitHub Packages or workflow logs | Requires successful main-branch workflow |
| Argo CD sync | Screenshot or exported Argo CD status | Not verified |
| Live API deployment | Kubernetes pod/service output | Not verified |

No fabricated CI logs, production metrics, or cloud deployment screenshots are stored here.

## Historical Kubernetes evidence

Actual experiments with K3s and kubeadm are under the adjacent `docs/evidence/k3s/` and `docs/evidence/kubeadm/` directories.
