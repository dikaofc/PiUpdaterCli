---
name: web-security-headers
description: Configure web security headers correctly — CSP, HSTS, X-Frame-Options, CORS, Referrer-Policy, sandbox. Use when hardening a web app or fixing browser warnings.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Web Security Headers

## Core set (deliver at edge/gateway)
- **CSP**: `default-src 'self'`; then relax per resource with explicit sources. Shape: `script-src 'self'` (add 'unsafe-inline' only after measuring; blocklist patterns lose). Use `report-to`/`report-uri` violation reporting during rollout — iterate to clean, then enforce. Frame: `frame-ancestors 'self'`.
- **HSTS**: `Strict-Transport-Security: max-age=63072000; includeSubDomains` (preload when committed) — enforce over HTTPS only.
- **X-Content-Type-Options: nosniff** — blocks MIME sniffing.
- **X-Frame-Options: DENY** — legacy when CSP frame-ancestors absent.
- **Referrer-Policy: strict-origin-when-cross-origin** — no leaks to other origins.
- **Permissions-Policy**: disable what you don't use (`geolocation=(), camera=(), microphone=(), payment=()` ).
- **Cross-Origin-Opener-Policy: same-origin** (+CORP `same-origin`) — Spectre-era hardening; verify no legitimate cross-origin embeds break.

## CORS (the one most misconfigured)
- Only where needed: API for browsers. `Access-Control-Allow-Origin` = specific origin list (never `*` with credentials), `Access-Control-Allow-Credentials: true` only with explicit origin echo; `Vary: Origin` (CDN caching correctness).
- Preflight: `Access-Control-Allow-Methods/Headers` minimal; make preflight cheap; don't allow `Authorization` exposure unnecessarily (`Expose-Headers` only what clients read).
- CSRF is separate from CORS — SameSite cookies + token for state-changing (see `csrf-protection`).

## Where set
- Gateway/CDN/infra-config (covers all responses) > app framework middleware; set once, audit once.

## Verification
- `curl -sI https://host` check headers; `securityheaders.com`/Lighthouse audit; wedged regressions = CSP changes break lazy-loaded scripts — test in staging with full feature set.

## Checklist
- [ ] CSP set + violation reports monitored
- [ ] HSTS (with subdomains) on
- [ ] CORS scoped; `*`+credentials never
- [ ] Permissions-Policy minimal
- [ ] Headers audited via curl + scanner