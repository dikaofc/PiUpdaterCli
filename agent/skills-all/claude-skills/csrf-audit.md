---
name: csrf-audit
description: Audit state-changing endpoints for CSRF protection — tokens, SameSite cookies, double-submit cookies.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for index, explore, search, show, and verification steps.
metadata:
  category: security
  tags: [csrf, same-site, cookies, state-changing]
---

# CSRF A
<!-- built by @dikaacode (telegram) -->
udit

## Objective
Find every state-changing endpoint (POST/PUT/PATCH/DELETE, and any GET that mutates
state) and verify it is protected against cross-site request forgery through a
server-verified CSRF token, `SameSite` cookie semantics, or an equivalent double-
submit mechanism. Every gap is classified confirmed / probable / possible /
false-positive and closed with the smallest compatible fix.

## Preconditions
- Routing table and cookie/session setup are identifiable; repository indexed
  (`cap index --refresh`).
- Auth cookie/session names and login state are known via `cap explore`.

## Workflow
1. Run `cap status` and `cap index --refresh`; enumerate routes with `cap explore` of the router and `cap search` for `app\.(post|put|patch|delete)|router\.(post|put|patch|delete)|@Post|@Put|@Delete|Mutations?` patterns.
2. Map cookies: `cap show` the cookie/session configuration; record `HttpOnly`, `Secure`, `SameSite` (`None`/`Lax`/`Strict`/unset) on the auth cookie. `SameSite=None` or absent → cookie-based CSRF is possible; `SameSite=Lax/Strict` downgrades but does not eliminate risk for same-site subdomain attacks.
3. Check token presence per state-changing endpoint: `cap search` for `csrf|xsrf|csrfMiddleware|csrf-protection|double.submit|X-CSRF-Token` middleware and per-request token verification (compare against a server-stored/session-bound value — not just echoing the cookie, and not a static constant).
4. For every endpoint without protection, `cap show` its handler and trace: is it authenticated? Does it change state (write, delete, update, transfer, settings)? Can an attacker force a cross-site request (form POST, `fetch` with `credentials`, img/JSONP)? Verify content-type protection (`application/json` requirement) is actually enforced, which alone is not CSRF defense.
5. Classify: **confirmed** — authenticated state-changing endpoint with no protection and a demonstrable cross-site forge path; **probable** — endpoint mutates state, protection absent, path not fully exercised; **possible** — protection pattern weak (static token, cookie-echo only); **false-positive** — real server-verified token or `SameSite=Strict` with same-origin enforcement and no cross-site reachability.
6. Fix minimally: add a per-session CSRF token (crypto-random, server-verified, bound to the session) sent as a header/custom field and rejected on mismatch (constant-time compare); or ensure same-site cookie semantics via `SameSite=Strict` + origin check when a token cannot be added. Never accept the cookie value alone as the double-submit secret without verification of equality at the server.
7. Re-verify each patched handler with `cap show`; run `cap lint`, `cap typecheck`, and targeted tests via `cap test`; finish with `cap verify`, confirm scope with `cap diff`, and record conventions with `cap memory add`.

## Verification
- [ ] Every state-changing endpoint enumerated and checked; GET-with-side-effects flagged.
- [ ] Cookie flags (SameSite/HttpOnly/Secure) recorded for the auth cookie.
- [ ] Any token mechanism verified to be crypto-random, server-verified, and session-bound.
- [ ] Every finding classified with the forge path or the guard shown.
- [ ] Applied fixes pass `cap lint`, `cap typecheck`, `cap test`, `cap verify`.
- [ ] `cap diff` shows only the intended changes.

## Failure Handling
- If the server uses a stateless (JWT-in-cookie) architecture: `SameSite` + origin/referer check is the fallback; document that token-issuing endpoints still need CSRF care, and escalate if origin checks are unreliable.
- If a fix would break legitimate cross-site consumers: require changing those consumers to use tokens or a CORS-allowlisted API, never disable the protection.
- If verification cannot distinguish a real token from a static one: classify as possible and inspect token generation with `cap show` before deciding.
- If an endpoint is unauthenticated: CSRF risk is limited to unauthenticated actions; still flag state change without protection as LOW.

## Output Format
Report: endpoint inventory (method, path, auth required, protection present), cookie
config summary, findings table (file, line, endpoint, classification, severity,
forge path or guard, fix), fixes applied, and verification results.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap show`, `cap explore`, `cap test`, `cap verify`, `cap diff`, `cap memory add`.
- docs/review-engine.md §5 classification rules.