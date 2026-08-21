---
name: oauth-oidc
description: Integrate OAuth 2.0 / OpenID Connect — authorization code flow, PKCE, token handling, scopes, provider specifics.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# OAuth 2.0 / OIDC

## Flow choice (2026 baseline)
- **Authorization Code + PKCE** — the only flow for web SPAs and native apps (S256 challenge; code never exposed to JS in risky ways; `state` param as CSRF guard, random per request).
- Implicit flow: obsolete — tokens in URL fragment are a leak/storage trap.
- Client credentials: only server-to-server (service accounts) — no user consent.
- Device flow: for smart TVs/CLI; don't fake it for web.

## Implementing provider
- Register client: `redirect_uri` exact match (never open `*`), scopes minimal (request least privilege; don't ask `email`+`profile` if only sub+name needed).
- **Validate ID token**: signature (JWKS fetch, cache), issuer (`iss`), audience (`aud` = your client id), `azp` when multi, `exp` with clock skew ±30s; `nonce` echo against stored value (replay guard).
- Userinfo/labels: fetch after token+verify; store OIDC `sub` as stable user id (do not key by email — email renames).

## Token handling
- Access ~15 min, refresh 7-30d rotatable; refresh rotation: on rotation detect reuse (theft → revoke family).
- Server keeps refresh **server-side** (web) or secure keychain (native) — never in JS storage (`secure-session-storage`).
- Scopes: honor least-privilege; prefix `read:`, `write:`; consent scope review UI honest (prompt user with real reasons).

## Provider caveats (common trips)
- GitHub: app-level token scopes; GH OAuth `user:email` scope needed for email. type `oauth` for GitHub App.
- Google: audience = Google OAuth client; `openid` scope required for id_token; verify `hd` (hosted domain) if org-restricted.
- Multiple providers: normalize to internal user + provider-account map; same email ≠ verify identity (email not proof).

## Centralize
- Single auth lib/layer (`next-auth`/`Auth0`/your SDK), not hand-rolled tokens per route; logging: OAuth failures, new-login events.

## Checklist
- [ ] Auth Code + PKCE; no implicit flow
- [ ] ID token fully validated (sig/iss/aud/exp/nonce)
- [ ] Refresh alone server-side/secure storage, rotated
- [ ] Redirect_uri exact; scopes minimal
- [ ] Provider-specific quirks mapped (hd, aud, email-vs-sub)