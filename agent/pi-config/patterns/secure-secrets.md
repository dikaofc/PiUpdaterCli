# Pattern: Secure Secrets

## Problem

Secrets must never appear in source, configs, logs, or artifacts; must be scoped,
rotatable, and injected at runtime.

## Design

1. **Central secret manager.** Store API keys, DB credentials, signing keys in a
   secret manager (Vault, cloud secret manager, etc.); inject at runtime
   (`skills/secrets/secret-management.md`).
2. **No secrets in code.** Zero hardcoded secrets; scan source AND history
   (`hardcoded-secret-detection.md`).
3. **No secret defaults.** Missing secret fails fast; empty env value is an error
   (`environment-secret-analysis.md`).
4. **Scoped credentials.** Per-service, per-environment credentials with least
   privilege; separate keys per concern (`key-management.md`).
5. **Rotation.** Scheduled rotation; immediate rotation on exposure; versioned
   secrets.
6. **Never in logs/artifacts/CI caches.** Redact in logs; exclude from build
   artifacts and container images (`cloud-secret-analysis.md`, `ci-security.md`).

## Verify

- Secret-scanning in CI (source + artifacts); tests asserting no secret value
  appears in rendered logs; exposure response runbook.

## Anti-Patterns

- `.env` committed; secrets as default values; client-side secrets; keys in
  container image layers; secrets in build logs.

## Related

- `../skills/secrets/*`
- `../checklists/secrets.md`
