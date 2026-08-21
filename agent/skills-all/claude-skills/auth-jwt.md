---
name: auth-jwt
description: Implement stateless JWT auth with correct signing, expiry, and revocation.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [auth, jwt, security]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# JWT Authentication

## Objective
Issue and verify JWTs safely without common pitfalls (weak alg, no expiry, leaked secrets).

## Preconditions
- `cap repo` run; auth flow and secret storage reviewed (`cap explore <auth|jwt|login>`).

## Workflow
1. Run `cap explore` for the login/issue and verify middleware.
2. Use asymmetric (RS256) or strong symmetric secrets from a secret store (see secrets-management).
3. Set short `exp` + refresh tokens; pin `iss`/`aud`/`sub` claims.
4. Reject `alg: none` and unexpected algorithms; validate signature and claims strictly.
5. Add revocation via denylist or rotating short-lived access tokens.
6. Record the token policy with `cap memory add`.

## Verification
- [ ] No `alg:none`; algorithm pinned server-side.
- [ ] Short expiry + refresh; claims validated.
- [ ] Secret from store, never hardcoded.
- [ ] Revocation path exists.

## Failure Handling
- If secret leaked, rotate and add rotation support.
- If clock skew rejects tokens, allow small leeway only.

## Output Format
JWT design: algorithm, claims, expiry/refresh, validation rules, and revocation approach.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
