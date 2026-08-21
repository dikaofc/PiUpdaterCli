---
name: security-basics
description: Apply foundational web security — OWASP Top 10, threat modeling, security headers, input/output handling.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Security Basics

## Threat model first
- Trust boundary map: where does untrusted input enter? (URLs, forms, headers, webhooks, files, APIs, DB externally-sourced). Every path gets validation + authz.
- Asset list: PII, credentials, payment data, source, infra — each gets protection tier.

## OWASP Top 10 (2021) inverted = code review list
1. **Broken Access Control** — check authz per route (`authorization-rbac`).
2. **Crypto Failures** — TLS everywhere, Argon2/bcrypt for secrets, no cleartext storage (`authentication-session`).
3. **Injection** — SQL (parameterize, `sql.md`), NoSQL ($ in filters), command (no shell interpolation), LDAP — validate/strict-whitelist.
4. **Insecure Design** — threat model, limits, rate-limits, privilege least.
5. **Security Misconfiguration** — defaults unchanged, verbose errors, missing headers.
6. **Vulnerable Components** — audit deps monthly (`npm audit`/pip-audit/vuln scan in `ci-cd-pipelines`).
7. **Authn failures** — session/JWT rules (`authentication-session`).
8. **Integrity failures** — supply chain (signatures, frozen is in), deserialization.
9. **Logging/monitoring failures** — which events logged (auth fail, perm change) + alert (`monitoring-observability`).
10. **SSRF** — URL allowlist + destination IP re-check (`api-validation`) .

## Security headers (baseline)
- `Content-Security-Policy` (default-src 'self'; fix through iterations, not copy-paste-all) — the big win.
- `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`, `X-Frame-Options: DENY` (or CSP frame-ancestors), `Permissions-Policy` limits, `Strict-Transport-Security`.
- Never trust `Origin` alone (`CSRF`).

## Output handling
- Escape on context: HTML(`&lt;`), attr, JS, CSS, URL each have encoders — a framework's auto-escaping ≠ universal (React escapes text, not `dangerouslySetInnerHTML`/`innerHTML`).

## Review cadence
- Security review on auth/chat/payment/every-handle-input PRs; code review checklist slips; dependabot merge within SLA (7d critical).

## Checklist
- [ ] Input validated at every trust boundary
- [ ] Authz on each route/object (no IDOR)
- [ ] Injection impossible (parameterized, no eval)
- [ ] Headers + CSP set
- [ ] Deps audited; secrets never in code/logs