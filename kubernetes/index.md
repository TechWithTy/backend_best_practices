# Kubernetes Best Practices

This guide documents the Kubernetes practices used by this project. It is a
practical checklist for a small FastAPI and MCP deployment, not a replacement
for the [official Kubernetes documentation](https://kubernetes.io/docs/).

The ideas are also informed by the external [Kubernetes Best Practices 101
cookbook](https://github.com/diegolnasc/kubernetes-best-practices). That
repository is research material only; it is not vendored, copied, or added as
a Git submodule.

## Repository Deployment Baseline

The project manifests live in [`backend/deploy/kubernetes`](../../deploy/kubernetes/):

- `kustomization.yaml` is the deployment entry point.
- The API and MCP each have a Deployment and ClusterIP Service.
- The namespace is `tic-tac-toe`.
- The MCP reads `OPENAI_API_KEY` from a Kubernetes Secret.
- Images are pinned through the Kustomize `newTag` field rather than using
  `latest`.

Render before applying:

```powershell
kubectl kustomize backend/deploy/kubernetes
```

Apply only after reviewing the rendered output:

```powershell
kubectl apply -k backend/deploy/kubernetes
```

## Namespaces And Ownership

- Deploy application resources into a dedicated namespace.
- Use consistent `app.kubernetes.io/*` labels for name, component, version,
  and management tooling.
- Keep environment-specific values in Kustomize overlays or deployment
  configuration, not in application source.
- Add ResourceQuota and LimitRange policies when the application moves beyond
  a single take-home cluster.

## Workload Security

- Run containers as a non-root user, as the Dockerfiles already do.
- Set `allowPrivilegeEscalation: false` and drop Linux capabilities unless a
  capability is explicitly required.
- Prefer a read-only root filesystem after confirming the application does not
  need to write to its image filesystem.
- Use a dedicated ServiceAccount for workloads that need Kubernetes API access;
  do not use the default account by habit.
- Apply Pod Security Admission labels at the namespace level for production
  environments, starting with `baseline` and moving toward `restricted`.
- Keep API and MCP Services internal unless an Ingress or gateway is required.

## Secrets

- Never commit `.env` files, API keys, or rendered Secret manifests containing
  real values.
- Create the local secret from an environment variable, as documented in
  [`backend/README.md`](../../README.md).
- For production, prefer an external secret manager or sealed/encrypted secret
  workflow over plaintext Kubernetes Secret YAML.
- Limit Secret access with namespace-scoped RBAC and rotate keys when exposure
  is suspected.

## Health And Resources

- Keep liveness probes focused on process health; do not use them to test every
  downstream dependency.
- Use readiness probes to remove a Pod from Service endpoints when it cannot
  serve traffic.
- Add startup probes for applications with long initialization times.
- Set CPU and memory requests for every production workload. Set memory limits
  deliberately because memory is not compressible and an overage can cause an
  OOM kill.
- Measure resource usage before tuning requests or adding autoscaling.

## State And Scaling

The current API stores active games in process memory. That is why the
deployment intentionally runs one API replica. Do not increase `replicas` or
add an HPA until game state is moved to shared durable storage and concurrent
updates are protected.

When the state model is ready for scaling:

1. Define ownership and concurrency behavior for a game ID.
2. Move state to a shared store with an explicit expiration policy.
3. Add integration tests that exercise multiple API replicas.
4. Add a PodDisruptionBudget only when replica count and availability targets
   justify it.
5. Add an HPA using measured metrics and bounded scale-up/scale-down behavior.

## Deployment Safety

- Pin images by immutable digest or CI commit SHA.
- Review `kubectl diff -k` output before applying changes.
- Use rolling updates for compatible releases and configure rollback history.
- Check rollout status and application health after every deployment.
- Keep the previous image available so rollback is fast.
- Treat database or shared-state migrations as a separate compatibility step.

## Observability And Operations

- Emit structured logs with service, version, request, and game identifiers;
  never log API keys or full prompts containing sensitive data.
- Monitor request errors, latency, restarts, readiness failures, and resource
  saturation.
- Record MCP tool attempts and whether the deterministic game engine accepted
  them.
- Document the rollback command and the owner for production changes.

## Take-Home Scope

For this project, the highest-value Kubernetes evidence is: valid manifests,
non-root images, probes, resource settings, secret separation, Kustomize
rendering, and a documented single-replica state limitation. Kubernetes
autoscaling, service meshes, GitOps controllers, and multi-zone deployment are
deliberately deferred until the application state model requires them.

## Further Reading

- [Kubernetes production environment guidance](https://kubernetes.io/docs/setup/production-environment/)
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [Application security checklist](https://kubernetes.io/docs/concepts/security/application-security-checklist/)
- [Configure liveness, readiness, and startup probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- [Resource management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Kubernetes Best Practices 101 cookbook](https://github.com/diegolnasc/kubernetes-best-practices)
