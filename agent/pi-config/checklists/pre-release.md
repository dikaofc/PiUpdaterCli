# Checklist: Pre-Release

Gate checklist for any release. Every item must pass or be explicitly waived with
owner sign-off.

## Security

- [ ] No open CRITICAL/HIGH findings without fix or accepted waiver
- [ ] Authentication and authorization re-verified on all changed endpoints
- [ ] New/changed dependencies audited with reachability analysis
  (`../workflows/dependency-audit.md`)
- [ ] No secrets in code, config, logs, or artifacts (`../checklists/secrets.md`)
- [ ] Debug/verbose mode disabled in production configuration
- [ ] Security headers and CSP verified (`../skills/web/security-headers.md`)
- [ ] Error paths do not leak stack traces or internals
- [ ] File upload/parsing paths validated (size, type, path)
- [ ] Rate limiting on authentication and sensitive endpoints

## Correctness

- [ ] Full test suite green (unit + integration + e2e)
- [ ] Regression tests exist for every confirmed bug since last release
- [ ] State transitions and business rules covered by tests
- [ ] Concurrency-sensitive paths reviewed (races, idempotency, duplicates)
- [ ] Boundary cases tested (empty, max size, malformed, concurrent)

## Data

- [ ] Database migrations reviewed and reversible (or backed up)
- [ ] Backup/restore verified for this release's data changes
- [ ] PII/payment data handling unchanged or re-reviewed

## Operations

- [ ] Configuration audit passed (`../workflows/configuration-audit.md`)
- [ ] Performance gate: no new unbounded work; load-tested changed paths
- [ ] Logging correct: no sensitive data; audit events present
- [ ] Monitoring/alerting covers new components and failure modes
- [ ] Rollback plan documented

## Process

- [ ] Change inventory complete and reviewed
- [ ] Waivers documented with owner sign-off and expiry
- [ ] Residual risk statement written for the release

## Related

- `../workflows/release-readiness.md`
- `../QUALITY_STANDARD.md`
