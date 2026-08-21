---
name: authentication-session
description: Implement authentication — password hashing, sessions/JWT, refresh flows, MFA, password reset, remember-me. Use when adding or auditing login systems.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Authentication

## Password storage
- Argon2id (OWASP choice) — params tuned (m=19MiB+ per ID, t≥2, p=1); bcrypt (cost ≥12) acceptable legacy; scrypt/sha* never for new. Salt built-in. Verify with constant-time compare (library does).
- Rate-limit login attempts (per account + per IP), lockout with exponential backoff; CAPTCHA after N failures; log anomalies (unusual geo/device); notify on password change.

## Sessions vs JWT
- Sessions: server-side store (Redis/DB table), random opaque token cookie (`HttpOnly`, `Secure`, `SameSite=Lax/Strict`, `Path=/`), revocable per-account. Default choice for web.
- JWT: stateless, for cross-service (API/gateway) — short-lived access (≤15 min) + rotating refresh token (storage-side, revocable); refresh on reuse detection (theft signal). Never put PII beyond `sub`, `exp`, scopes.
- Logout: revoke refresh + clear cookie; server-side session deletion for sessions.
- Token storage on client: cookie (web) or secure storage (mobile); never localStorage for access tokens when XSS residue possible.

## MFA & recovery
- TOTP (RFC 6238) or WebAuthn/passkeys preferred over SMS (SIM swap). Enforce for admin.
- Reset: email token single-use, 15 min expiry; invalidate all sessions after; notify user. Don't reveal account existence ("email sent if exists").

## Remember me
- Separate cookie (`remember=1`) extends refresh/session lifetime (30d), re-auth for sensitive ops; differentiators: device binding (signature), activity check.

## Audit checklist
- [ ] Argon2id/bcrypt≥12, no unhashed anything
- [ ] Login rate-limited; lockout works
- [ ] Cookie flags HttpOnly+Secure+SameSite
- [ ] JWT short-lived + revocable refresh
- [ ] MFA optional/required, reset single-use
- [ ] No account enumeration in errors