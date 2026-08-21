# Checklist: Secrets

Verification checklist for secret handling.

## Discovery

- [ ] No hardcoded secrets in source (`hardcoded-secret-detection.md`)
- [ ] No committed `.env` / key files / configs with real secrets
- [ ] Secret patterns scanned in repo history (past commits too)
- [ ] No secrets in examples, tests, docs, or comments

## Handling

- [ ] Secrets injected at runtime from a secret manager, not config files
  (`secret-management.md`)
- [ ] No secret defaults in code; missing secret fails fast
  (`environment-secret-analysis.md`)
- [ ] Keys rotated on a schedule and on exposure (`key-management.md`)
- [ ] Least privilege for each credential; scoped keys

## Logs & Artifacts

- [ ] No secrets in logs, error messages, or stack traces
  (`logging-security.md`)
- [ ] No secrets in build artifacts, images, or CI caches
  (`cloud-secret-analysis.md`, `ci-security.md`)

## Related

- `../skills/secrets/*`
- `../workflows/configuration-audit.md`
