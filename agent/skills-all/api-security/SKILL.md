---
name: api-security
description: Secure APIs — authn/authz on every endpoint, input limits, rate limiting, IDOR, SSRF, error handling, versioning security.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# API Security

## Access control
- Authn: every route needs an identity (`Bearer`/cookie/session) unless explicitly public (`/healthz`, `/public`); public routes have no hidden data.
- Authz: permission + ownership per object (`authorization-rbac`) — route-level auth is not sufficient (IDOR).
- Object access pattern query: `WHERE id = ? AND owner_id = ?` — never `WHERE id` alone trusting the caller.

## Input & abuse
- Validation: schema + limits (`api-validation`) — body size, array length, string sizes.
- Rate limiting per user+IP on hot/expensive endpoints (`rate-limiting`); auth endpoints stricter.
- SSRF: URL inputs (parse, fetch target) — scheme+hostname allowlist + resolve-then-check (`api-validation`).
- Serialization: never unsafe `pickle`/`JSON.parse` of attacker objects; contentType sniff on uploads (`file-upload`).

## Transport & headers
- TLS only; security headers at gateway (`web-security-headers`); CORS scoped.
- Tokens: short-lived, revocable, scope-limited (`authentication-session`); never in URLs/logs.

## Information leaks
- Error responses: generic message + stable code, no stack traces, no SQL fragments, no internal paths in debug mode (turned off in prod). Distinguish 401 vs 404 carefully (account enumeration leak) — consistent envelope.
- Logs: log ids, not secrets/sensitive fields (`monitoring-observability` redaction); correlation ids.

## Versioning & endpoints
- Deprecate old API versions (`Deprecation`/`sunset`), remove insecure legacy routes; principal/`v1` breaking → new version not silent mutation.
- Off-by-default: new features behind opt-in until a scan; `api/security` review before exposing anything new.

## Verification (top 3 automated)
- **IDOR tests** (switch userId owning resource, expect 403/404).
- **Authz matrix** scripted (public/authenticated/admin access per route × method).
- **Fuzz** input params (nullable, giant strings, arrays) — crash/5xx = fail; OWASP ZAP/`ffuf` optional.

## Checklist
- [ ] Every route authn+authz (no IDOR)
- [ ] Input limits + rate limits enforced
- [ ] SSRF-blocked URL validation
- [ ] No secret/sensitive data in errors/logs
- [ ] Automated authz+IDOR tests in CI