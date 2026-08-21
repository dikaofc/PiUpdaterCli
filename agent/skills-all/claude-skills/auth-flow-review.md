---
name: auth-flow-review
description: Review authentication and authorization flows — session handling, token expiry, password policy, brute-force protection.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for index, explore, search, show, and verification steps.
metadata:
  category: security
  tags: [authentication, authorization, sessions, tokens]
---

# Auth Flow R
<!-- built by @dikaacode (telegram) -->
eview

## Objective
Review the complete authentication and authorization flow — login, session/token
lifecycle, password handling, and brute-force defenses — and verify that every
protected entry point enforces authn and authz server-side. Each weakness is
classified confirmed / probable / possible / false-positive with file:line evidence
and a remediation recommendation; findings are fixed only when a safe, minimal patch
is available.

## Preconditions
- Auth-related code is identifiable in the repo (middleware, guards, JWT/session
  utilities, user endpoints) and indexed (`cap index --refresh`).
- A list of protected endpoints/routes is derivable via `cap explore`.

## Workflow
1. Run `cap status` and `cap index --refresh`; locate auth modules with `cap explore <auth-symbol>` and `cap search` for `login|signin|signup|register|logout|session|jwt|passport|guard` patterns.
2. Map the flow: `cap show` the login route, password hashing (require bcrypt/argon2/scrypt — reject MD5/SHA1/sha256-without-salt), session store (server-side store vs. client-only JWT), and cookie flags (`HttpOnly`, `Secure`, `SameSite`).
3. Check token expiry: search for `expiresIn|exp`, `maxAge`, `ttl`; verify expiry is bounded (default <= 24h for access tokens is a reasonable ceiling), tokens are validated on every request (signature, expiry, revocation check), and refresh tokens rotate with reuse detection.
4. Check session/account enumeration and brute-force protection: `cap search` for rate limiting (`rateLimit|limiter|throttle`), lockout, constant-time comparison (`timingSafeEqual|crypto\.timingSafeEqual`), and generic error messages (do not reveal "user not found" vs. "wrong password" — classify as MEDIUM if differentiated).
5. Check authorization: for each protected route found via `cap explore`, verify a middleware/guard runs server-side and enforces role/ownership on the resource — not just hidden client-side UI — and that `req.user`/identity is never taken from a client-supplied field.
6. Classify each finding: **confirmed** — flow verified against code (e.g., token checked with `==` vs `timingSafeEqual`, no expiry check, session cookie without `HttpOnly`); **probable** — strong pattern, flow not fully exercised; **possible** — pattern present, impact unclear; **false-positive** — guarded or mitigated elsewhere. Only confirmed/probable may be HIGH (docs/review-engine.md).
7. Apply minimal fixes where safe (expiry check use `<=` not `<`, add `HttpOnly`/`Secure`, add rate limiting config, constant-time comparison) — never invent a new auth framework; verify with `cap lint`, `cap typecheck`, `cap test`, then `cap verify`; confirm scope with `cap diff`; store durable conventions with `cap memory add`.

## Verification
- [ ] Password hashing algorithm verified; plaintext or weak-hash storage flagged.
- [ ] Token/session expiry verified with a comparison (`<=` vs `<`) check.
- [ ] Cookie flags verified on all auth cookies.
- [ ] Brute-force protections (rate limit/lockout/timing-safe compare) present or flagged.
- [ ] Every protected route has server-side authn + authz evidence or a finding.
- [ ] Every finding classified; `cap lint`, `cap typecheck`, `cap test`, `cap verify` pass for applied fixes.

## Failure Handling
- If a flow path cannot be fully traced: classify probable/possible, never confirmed.
- If a fix would break sessions: prefer a compatibility-preserving change (e.g., additive flag) and document the migration.
- If rate limiting exists only in frontend code: flag as client-side-only, not a defense.
- If the auth framework is unknown: identify it via `cap explore` before judging any behavior.

## Output Format
Report: flow map (entry points, session/token lifecycle, storage), findings table
(file, line, area, classification, severity, evidence, fix), fixes applied, remaining
risk, and verification results.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap explore`, `cap search`, `cap show`, `cap test`, `cap verify`, `cap diff`, `cap memory add`.
- docs/review-engine.md §5 classification rules.