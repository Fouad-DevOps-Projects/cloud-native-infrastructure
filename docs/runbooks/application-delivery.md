# Application Delivery and Troubleshooting

## Validate without Kubernetes

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r apps/sample-api/requirements-dev.txt
cd apps/sample-api
pytest -v
cd ../..
helm lint helm/sample-api
helm template sample-api helm/sample-api
docker build -t sample-api:local apps/sample-api
```

## CI and GHCR

The `Sample API CI and Image Publishing` workflow runs tests and Helm checks before building the image.
Pushes to `main` publish to GHCR with mutable `latest` and immutable-by-convention `sha-<commit>` tags.
PR builds do not publish. Check the Actions page for results and GitHub Packages for the image.
If publication fails with 403, verify organization package permissions and Actions workflow policy.

## Helm deploy

```bash
helm upgrade --install sample-api helm/sample-api \
  --namespace sample-api --create-namespace \
  --set image.repository=ghcr.io/fouad-devops-projects/cloud-native-infrastructure/sample-api \
  --set image.tag=sha-REPLACE_WITH_COMMIT_SHA
kubectl rollout status deployment/sample-api-sample-api -n sample-api
kubectl port-forward -n sample-api service/sample-api-sample-api 8080:80
curl http://127.0.0.1:8080/health/ready
```

For private GHCR images, configure an imagePullSecret or make the image public.

## Argo CD

Install Argo CD separately in a running Kubernetes cluster, then apply
`argocd/applications/sample-api.yaml`. Argo CD tracks the chart in `main`.
For reliable GitOps promotion, update the chart's `image.tag` to a specific published SHA in Git and commit it.
The CI workflow **does not** currently auto-commit image-tag updates, so image production and promotion are separate steps.

## Cleanup

```bash
helm uninstall sample-api -n sample-api
kubectl delete namespace sample-api
```

If the infrastructure is Terraform-managed, review its destroy plan before removing it.
