# Infisical Secret Management

This guide describes how this project should manage application secrets with
Infisical. The goal is to keep credentials out of source control, local logs,
container images, and browser code while keeping deployment repeatable.

The guidance is informed by the [Infisical guides repository](https://github.com/Infisical/infisical-guides),
especially its static-secret, secret-syncing, and Kubernetes External Secrets
Operator examples. That repository is reference material only; it is not
cloned, vendored, or added as a Git submodule.

## Current Project Boundary

The backend uses `OPENAI_API_KEY` for the AI Agent flow. The key must remain
server-side:

- Local FastAPI and LightSpeed processes read it from `backend/.env`.
- `backend/.env` is ignored by Git and must never be committed.
- The React client does not receive or store the key.
- Kubernetes receives the value through a Secret or an Infisical-backed secret
  synchronization workflow.
- MCP tools receive only the capability needed to play the game; they do not
  expose arbitrary secret access.

See [`backend/README.md`](../../README.md) for local setup and
[`backend/deploy/kubernetes`](../../deploy/kubernetes/) for the current
manifest-based deployment.

## Secret Management Principles

- Treat secrets as runtime configuration, never as application source.
- Separate projects and environments such as development, staging, and
  production.
- Use machine identities or workload identity for automation instead of a
  developer's personal token.
- Grant the smallest read scope needed by each service.
- Give secrets an owner, rotation interval, and documented revocation path.
- Do not print secret values in CI output, exceptions, structured logs, or
  diagnostics.
- Scan commits and container layers for accidental credential exposure.
- Prefer short-lived or dynamically generated credentials when the target
  system supports them.

## Local Development

For a quick local run, use the ignored `backend/.env` file:

```dotenv
OPENAI_API_KEY=replace-with-a-local-key
```

Load it only in the server process that needs it. Do not add it to
`frontend/app/.env`, `VITE_*` variables, screenshots, test fixtures, or a
Docker build context.

For team development, Infisical CLI or an approved local integration can
inject environment variables at process start. The local workflow should
still satisfy these rules:

1. Authenticate with a developer or machine identity appropriate to the
   development environment.
2. Select the intended Infisical project and environment explicitly.
3. Start the backend with injected variables rather than writing a tracked
   file.
4. Confirm the variable is present without printing its value.

## Kubernetes Integration

The current take-home deployment creates a Kubernetes Secret directly from an
environment variable. That is acceptable for a controlled demonstration, but
production deployments should use an external secret manager or the Infisical
External Secrets Operator integration.

Preferred production flow:

1. Store `OPENAI_API_KEY` in the production Infisical project and environment.
2. Create a narrowly scoped machine identity or Kubernetes workload identity.
3. Install and manage the External Secrets Operator through the cluster's
   approved platform process.
4. Configure a namespaced SecretStore or ClusterSecretStore with least
   privilege.
5. Define an ExternalSecret that syncs only the required key into the MCP
   namespace.
6. Reference the resulting Kubernetes Secret from the MCP Deployment.
7. Verify synchronization status without exposing secret data.

Keep the External Secrets resources in a separate environment overlay when
the cluster setup is not available locally. Do not put real Infisical tokens,
client secrets, or rendered Secret objects in this repository.

## Rotation And Revocation

Rotation must be safe for the running service:

- Create or obtain the replacement key before revoking the old one.
- Update the Infisical value or synchronized secret.
- Restart or roll the MCP Deployment if the process reads configuration only at
  startup.
- Verify the health endpoint and one authenticated AI-agent request.
- Revoke the previous key after successful verification.
- Record the rotation event without recording the secret value.

If a key is exposed, revoke it immediately, inspect access logs, replace it,
and check Git history, CI artifacts, container layers, and local logs for
copies. Removing a value from the working tree does not remove it from Git
history or external logs.

## CI/CD

CI should receive deployment credentials through the CI platform's protected
secret mechanism or workload identity. Prefer an Infisical machine identity
with a narrowly scoped environment over a long-lived administrator token.

- Do not use pull-request input to select arbitrary Infisical paths.
- Do not echo environment variables or serialize the full process environment.
- Keep secret retrieval in the deployment boundary, not in application tests.
- Use secret scanning before merge and before publishing images.
- Ensure generated manifests contain references, not resolved secret values.
- Audit who can change the secret source and who can deploy the workload.

## Kubernetes Safety Checks

Before deployment, verify:

```powershell
kubectl -n tic-tac-toe get externalsecret
kubectl -n tic-tac-toe describe externalsecret <external-secret-name>
kubectl -n tic-tac-toe get secret lightspeed-mcp-secrets
kubectl -n tic-tac-toe rollout status deployment/tic-tac-toe-mcp
```

Do not use `kubectl get secret ... -o yaml` in shared terminals or CI logs.
Kubernetes Secret data is base64-encoded, not encrypted by that command.

See [`../kubernetes/kubectl.md`](../kubernetes/kubectl.md) for context,
diffing, rollout, and debugging practices.

## Take-Home Scope

For this project, the strongest practical evidence is server-side key loading,
`.env` exclusion, Kubernetes Secret separation, and a clear migration path to
Infisical-backed synchronization. Installing an operator, adding Terraform,
or implementing dynamic secret rotation is intentionally deferred unless a
real cluster is already available and the application remains stable.

## Further Reading

- [Infisical guides](https://github.com/Infisical/infisical-guides)
- [Infisical documentation](https://infisical.com/docs/documentation/getting-started/introduction)
- [Infisical Kubernetes integration](https://infisical.com/docs/integrations/secret-sync/overview)
- [External Secrets Operator documentation](https://external-secrets.io/latest/)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
