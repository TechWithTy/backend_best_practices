# `kubectl` Best Practices

Use `kubectl` deliberately: inspect context, render locally, diff changes,
apply the smallest scope, and verify the resulting rollout.

## Context Safety

Always identify the active context and namespace before changing resources:

```powershell
kubectl config current-context
kubectl config get-contexts
kubectl get namespaces
kubectl -n tic-tac-toe get all
```

Prefer an explicit `--context` and `--namespace` for scripts or commands that
could affect shared infrastructure. Never assume the current context is the
intended cluster.

## Render And Diff Before Apply

Render Kustomize locally and inspect the result:

```powershell
kubectl kustomize backend/deploy/kubernetes
kubectl diff -k backend/deploy/kubernetes
```

The diff should be reviewed before applying:

```powershell
kubectl apply -k backend/deploy/kubernetes
```

Prefer declarative `apply -k` over imperative changes that are difficult to
review or reproduce. Use `--dry-run=server -o yaml` when the API server should
validate the object without changing it.

## Secrets

Create Secrets from environment variables or an approved secret manager. Do
not place values directly in shell history, manifests, or pull requests:

```powershell
kubectl -n tic-tac-toe create secret generic lightspeed-mcp-secrets `
  --from-literal=OPENAI_API_KEY=$env:OPENAI_API_KEY `
  --dry-run=client -o yaml | kubectl apply -f -
```

Treat `kubectl get secret ... -o yaml` as sensitive output. Base64 encoding is
not encryption.

## Rollout Verification

After applying a Deployment, verify the rollout and endpoints:

```powershell
kubectl -n tic-tac-toe rollout status deployment/tic-tac-toe-api
kubectl -n tic-tac-toe rollout status deployment/tic-tac-toe-mcp
kubectl -n tic-tac-toe get pods -o wide
kubectl -n tic-tac-toe get svc,endpoints
kubectl -n tic-tac-toe describe deployment/tic-tac-toe-api
```

A successful rollout is not sufficient by itself: confirm readiness, service
endpoints, and an application-level health response.

## Debugging

Start with scoped, read-only inspection:

```powershell
kubectl -n tic-tac-toe get events --sort-by=.lastTimestamp
kubectl -n tic-tac-toe logs deployment/tic-tac-toe-api --tail=100
kubectl -n tic-tac-toe logs deployment/tic-tac-toe-mcp --tail=100
kubectl -n tic-tac-toe describe pod <pod-name>
```

For a temporary local check, use port-forwarding instead of exposing a service:

```powershell
kubectl -n tic-tac-toe port-forward svc/tic-tac-toe-api 8001:8001
```

Do not use `kubectl exec` as a substitute for health checks or normal service
access. If it is necessary for diagnosis, document the command and avoid
modifying running containers.

## Rollback And Cleanup

Inspect rollout history before rolling back:

```powershell
kubectl -n tic-tac-toe rollout history deployment/tic-tac-toe-api
kubectl -n tic-tac-toe rollout undo deployment/tic-tac-toe-api
kubectl -n tic-tac-toe rollout status deployment/tic-tac-toe-api
```

Use namespace-scoped deletion only when the impact is understood:

```powershell
kubectl delete -k backend/deploy/kubernetes
```

Do not use `kubectl delete namespace` for routine cleanup; it removes every
resource in that namespace.

## When No Cluster Is Available

Manifest validation and application testing are separate concerns. If local
Kubernetes cannot start because of disk or resource limits, render the
Kustomize bundle and parse the YAML without creating a cluster:

```powershell
kubectl kustomize backend/deploy/kubernetes
python -c "import yaml, pathlib; [list(yaml.safe_load_all(p.read_text())) for p in pathlib.Path('backend/deploy/kubernetes').glob('*.yaml')]; print('YAML valid')"
```

Build and smoke-test the Docker images, then run the API and frontend locally
for behavioral verification. `kubectl apply --dry-run=client` can still try to
contact the configured API server for discovery and is not a reliable offline
validation command; use `kubectl kustomize` plus a YAML parser instead.

## Automation Rules

- Use `--dry-run` and explicit namespaces in scripts.
- Fail scripts when a command fails; do not hide rollout or validation errors.
- Avoid parsing human-oriented table output when JSONPath or structured output
  is available.
- Use `kubectl wait` for readiness gates in repeatable automation.
- Keep destructive commands out of CI unless the target cluster and scope are
  explicitly protected.

## Further Reading

- [kubectl command reference](https://kubernetes.io/docs/reference/kubectl/)
- [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Declarative management with Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)
- [Kubernetes Best Practices 101 cookbook](https://github.com/diegolnasc/kubernetes-best-practices)
