---
name: oauth2
description: Integrate OAuth2/OIDC flows (auth code + PKCE) for delegated login.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [oauth, oidc, auth]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# OAuth 2.0 / OIDC

## Objective
Connect a secure delegated-auth flow with correct redirect, state, and token handling.

## Preconditions
- `cap repo` run; existing auth and client config reviewed (`cap explore <oauth|callback|provider>`).

## Workflow
1. Run `cap explore` for the login callback and session handling.
2. Use authorization code + PKCE for public clients; server-side for confidential.
3. Validate `state`/`nonce` to prevent CSRF; verify ID token signature and claims.
4. Store tokens securely (httpOnly cookie/session); never expose refresh in JS.
5. Handle token refresh and provider errors gracefully with retry.
6. Record the flow and scopes with `cap memory add`.

## Verification
- [ ] PKCE + state/nonce validated.
- [ ] ID token signature+claims checked.
- [ ] Refresh token not JS-exposed.
- [ ] Errors handled, no infinite redirect.

## Failure Handling
- If redirect loop, check callback URL allowlist.
- If token replay, bind state to session.

## Output Format
OAuth design: flow, PKCE/state, token storage, scopes, and error handling.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
