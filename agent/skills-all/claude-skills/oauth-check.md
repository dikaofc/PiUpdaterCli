---
name: oauth-check
description: Audit OAuth2 and OIDC flows — redirect_uri validation, PKCE, state parameter, and scope enforcement.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for index, explore, search, show, and verification steps.
metadata:
  category: security
  tags: [oauth2, oidc, pkce, authn]
---

# OAuth2 / OIDC C
<!-- built by @dikaacode (telegram) -->
heck

## Objective
Audit every OAuth2/OIDC flow in the codebase — authorization-code flow, implicit
flow, client-credentials, token exchange, and the callback handler — for the four
pillars: `redirect_uri` validation, PKCE, the `state` parameter, and scope
enforcement. Each gap is classified confirmed / probable / possible / false-positive
with the attack it enables, and fixed with a minimal, safe patch.

## Preconditions
- IDP/client configuration is in the repo (OAuth client setup, auth route handlers)
  and indexed (`cap index --refresh`).
- The flow entry points (login link, callback URL) are identifiable via `cap explore`.

## Workflow
1. Run `cap status` and `cap index --refresh`; locate the flow with `cap search` for `oauth|openid|authorize|callback|codeVerifier|nonce|redirectUri|redirect_uri|scope|grant_type|token_endpoint|jwks` and `cap explore <auth-handler>`.
2. **redirect_uri**: `cap show` registration and callback code. Verified: exact match against a registered allow-list (scheme, host, path — no prefix matching, no wildcards). Unverified/exact-URI-missing = code-redirect/code-leak vector; classify accordingly.
3. **state**: search for `state` generation (crypto-random, `crypto.randomBytes`/`randomUUID`) and callback verification. Missing state = CSRF on login (login CSRF, session-fixation); sloppy verification (string compare without constant-time) = probable.
4. **PKCE**: check the authorization request carries `code_challenge` (`S256` preferred over `plain`) and the token request verifies `code_verifier`. Native/mobile apps must use PKCE per OAuth 2.1 — missing it with a client secret embedded in the bundle is confirmed exposure.
5. **scope**: verify the requested scope is a curated allow-list, the returned token's scope is checked before authorization decisions, and scopes are not taken verbatim from the client. Overflow/under-scope grants are authz findings.
6. Token handling: verify tokens are not logged, are sent over TLS (`https:` enforced), access tokens are short-lived, refresh tokens rotate, and JWT signatures are validated against the IDP JWKS (algorithm confusion: reject `none` and `alg` downgrade from RS to HS — classify confirmed if the verifier trusts attacker-chosen `alg`/`kid`).
7. Classify every gap (confirmed / probable / possible / false-positive per docs/review-engine.md) and fix minimally: strict registered-URI compare, crypto-random `state` + constant-time verify, `S256` PKCE where applicable, scope allow-list. Then `cap lint`, `cap typecheck`, `cap test`, `cap verify`, `cap diff` scope check, and `cap memory add` for IDP-specific conventions.

## Verification
- [ ] All four pillars checked with evidence (redirect_uri allow-list, state verify, PKCE params, scope enforcement).
- [ ] Token endpoint/JWKS validation reviewed (signature, alg confusion, `none` rejected).
- [ ] Every finding classified; confirmed ones name the concrete attack.
- [ ] No token value logged; TLS enforced on every OAuth request in code.
- [ ] Applied fixes pass `cap lint`, `cap typecheck`, `cap test`, `cap verify`.
- [ ] `cap diff` shows only intended changes.

## Failure Handling
- If the IDP's exact matching rules are unknown: classify redirect_uri behavior as probable and require reading the IDP docs before claiming safety.
- If PKCE is impossible on a legacy flow: escalate with the migration plan; do not silently disable it.
- If scope semantics are unclear: verify against the provider's documented scopes before judging.
- If tokens appear in logs: confirmed MEDIUM/HIGH finding — fix logging first.

## Output Format
Report: flow map (entry, callback, token exchange), pillar-by-pillar verdict table
(file, line, check, classification, severity, attack enabled, fix), fixes applied,
remaining findings, and verification results.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap show`, `cap explore`, `cap test`, `cap verify`, `cap diff`, `cap memory add`.
- docs/review-engine.md §5 classification rules.