---
name: api-consistency
description: Audit API consistency — naming, status codes, error shape, and versioning — across one service or a set of endpoints.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: review
  tags: [api, consistency, contract, http]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# API Consistency Audit

## Objective
Find inconsistencies across an API surface: naming conventions (paths, resources,
fields), HTTP status code usage, error response shape, and versioning strategy.
Deliver a consistency matrix (endpoint × convention) with confirmed violations,
each backed by file:line evidence, and a prioritized fix list that does not break
released consumers.

## Preconditions
- Repository is indexed (`cap index --refresh`); the API entry points are known or
  discoverable via `cap explore`.
- A definition of "consistent" is agreed before the audit: the conventions doc, if
  any, or the dominant pattern in the codebase (majority wins).

## Workflow
1. Run `cap status` and `cap repo` to confirm the project type and detect the framework (express/fastify/etc.).
2. Find all route/endpoint declarations: `cap explore "route|router|endpoint"` and `cap search "app\.(get|post|put|patch|delete)"`.
3. Build the endpoint inventory: for each route, `cap show <file> [--lines a-b]` to capture path, method, handler, and status codes returned.
4. Check the error shape: `cap search "res\.status\(|throw.*Error"` — note the JSON body shape (`code`, `message`, `error` vs flat) for each error path.
5. Check versioning: `cap search "v[0-9]+"` in route paths and compare with any `cap explore "version"` hits; note mixed or missing versions.
6. Check naming: compare resource names, casing (camelCase vs snake_case in JSON bodies), and pluralization across endpoints.
7. Score each endpoint against the agreed conventions: CONSISTENT, MINOR DEVIATION, VIOLATION, or UNKNOWN (no precedent).
8. Run `cap risk --json` to see how much of the surface is live; prioritize violations on live/released paths.
9. If the user approves fixes, patch the violations that cannot break consumers (naming-only, non-contract): plan with `cap plan`, apply, then `cap verify` + `cap test`. Contract-breaking fixes (error shape, status codes) are reported only, never applied silently.
10. `cap memory add` the agreed conventions so future endpoints match.

## Verification
- [ ] Endpoint inventory covers every route found by the greps (none dropped).
- [ ] Every VIOLATION has file:line evidence from `cap show`.
- [ ] Contract-breaking fixes were reported, not applied.
- [ ] Applied fixes pass `cap verify` and `cap test`.
- [ ] `cap diff` shows only intended consistency changes.

## Failure Handling
- If no convention doc exists and patterns conflict: declare majority-as-convention in the report; do not invent a new style and treat the rest as violations.
- If a fix touches a released consumer contract: stop and report — changing error shape or status codes requires a versioning decision (`cap plan` for a v2 route).
- If `cap verify` fails after a naming fix: `cap rollback --task <id>`; naming fixes must be behavior-neutral.

## Output Format
- Consistency matrix: endpoint | method | naming | status codes | error shape | versioning | verdict.
- Violation list sorted by priority: severity, evidence (file:line), impact on consumers.
- Applied fixes vs reported-only fixes.
- Verification results (`cap verify`, `cap test`, `cap risk`).
- Recorded conventions.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap explore`, `cap search`, `cap show`, `cap risk`, `cap plan`.
- CONTRACT.md §4 Review severity levels for violation grading.