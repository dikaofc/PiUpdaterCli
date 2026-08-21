---
name: csrf-protection
description: Protect against CSRF and clickjacking — SameSite cookies, tokens, double-submit, origin checks, form hardening.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# CSRF Protection

## Reason it exists
CSRF = attacker-forced state change (transfer, password change, admin action) using the victim's cookies. Modern browsers + good flagging largely neutralize it — but only if done right.

## Defense layers (defense-in-depth, pick a sound primary)
1. **SameSite cookies (primary)** — `Set-Cookie: ...; SameSite=Lax` (default in modern browsers; explicit anyway). Strict for truly-session cookies; `None` requires `Secure` and opens CSRF — keep None rare.
2. **CSRF token** (when SameSite insufficient: cross-site subdomains shared-cookie, legacy client):
   - Synchronizer token: server-issued random token in form + session; validate on POST (constant-time compare).
   - Double-submit: cookie + same value in header/form; stateless but weaker (attacker can sometimes set via subdomain).
   - Token per-session (same token okay); rotate on login; never reuse across logout.
3. **Origin/Sec-Fetch-Site check** — reject POSTs whose `Origin`/`Sec-Fetch-Site` is `cross-site` when session expected (`Sec-Fetch-Site` supported in modern; fallback Origin check). Cheap + strong.
4. State-changing = POST/DELETE only; GET never mutates (idempotency side benefit).

## Clickjacking
- `X-Frame-Options: DENY` (or CSP `frame-ancestors 'none'`) on pages where misclick does damage (settings, payments).
- Overlay detection optional; `securityheaders` audit verifies.

## Common failures
- Token absent on JSON APIs (fetch with CSRF token header); forgetting SameSite on old browsers in your support matrix; token stored in localStorage readable by XSS (defense breaks if XSS present — fix XSS anyway).
- Rate-limiting won't fix CSRF — it's a trust-attribution flaw.

## Checklist
- [ ] SameSite=Lax/Strict on session/auth cookies
- [ ] CSRF token verified (constant-time) where SameSite isn't enough
- [ ] GET handlers side-effect-free
- [ ] Origin check on sensitive POSTs
- [ ] frame-ancestors/x-frame DENY on damage pages