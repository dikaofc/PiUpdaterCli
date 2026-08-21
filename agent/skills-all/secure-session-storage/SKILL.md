---
name: secure-session-storage
description: Store and handle session data securely — cookies vs storage decisions, XSS-resistance, client-side encryption, logout/invalidation.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Secure Session Storage

## Decision matrix (web client)
- **Access token / session cookie**: **HttpOnly cookie** (`Secure`, `SameSite=Lax`) — immune to XSS reading JS; the web default. `Refresh token` = `HttpOnly+SameSite=Strict + Path=/` separate cookie; or memory + refresh cookie (`api-frontend`).
- **Don't put access tokens in localStorage/sessionStorage** — XSS reads it freely; even with CSP you're one sink away from exfil (see `xss-protection`).
- Mobile: secure-element-backed storage (Keychain/Keystore) not plain SQLite/shared prefs; JS-native hybrid: use native keychain via bridge.

## Session model
- Opaque random session id (≥ 128 bits) server-side stored (Redis/DB), server-invalidatable; JWT only stateless-access + refresh (`authentication-session`).
- Idle timeout (15-30 min for sensitive), absolute timeout (24h-7d), sliding renewal; concurrent-device policy (sessions list UI, revoke individually = security feature).
- Logout must revoke: server-side delete (sessions store) + `Max-Age=0` cookie clear + refresh rotation (if refresh = pair rotation on reuse).

## Client-side secrets (edge cases)
- If you must persist (remember-device token) — encrypt with a key you control server-side via derivation (no hardcoded keys in client), verify tamper (HMAC/signature) before trust.
- PIN/bio: native keystore only; store key in Keystore, ciphertext in app storage — never plaintext credentials.

## Leak/compromise response
- On any suspicion (phishing, device loss, breach): immediate global/session-group revoke button; password reset flow forces re-auth; audit logs of session creation/rotation.

## Checklist
- [ ] HttpOnly+Secure+SameSite cookies; nothing sensitive in localStorage
- [ ] Server-side sessions or rota-able refresh
- [ ] Idle/absolute expiry configured
- [ ] Logout revokes server-side
- [ ] Client-stored secrets encrypted + integrity-checked