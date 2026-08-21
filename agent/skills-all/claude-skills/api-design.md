---
name: api-design
description: Design coherent HTTP/JSON APIs — resources, errors, pagination, and versioning before coding.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: architecture
  tags: [api, rest, design]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# API Design

## Objective
Produce an API contract that is consistent, predictable, and evolvable, grounded in the existing codebase conventions found via the index.

## Preconditions
- Repository indexed (`cap index --refresh`).
- `cap repo` run to know language/framework and any existing route modules.

## Workflow
1. Run `cap repo` and `cap explore <router|routes|controller>` to find existing endpoint patterns.
2. Enumerate resources from domain types (`cap explore <entity>`) and map them to nouns, not verbs.
3. Define standard response envelopes, error shape, and status-code policy; reuse the project's existing error module if present.
4. Specify pagination, filtering, and sorting conventions (cursor vs offset) consistent with existing list endpoints.
5. Decide versioning strategy (path, header, or media-type) and document breaking-change policy.
6. Record the contract with `cap memory add` so later implement/refactor steps stay aligned.

## Verification
- [ ] Endpoints follow one consistent URL/verb/error convention.
- [ ] Pagination and error shapes match existing code.
- [ ] No verb-in-URL or inconsistent casing introduced.
- [ ] Versioning decision recorded and non-breaking.

## Failure Handling
- If two conventions already coexist, pick the dominant one (most endpoints) and note the deviation.
- If domain unclear, read entity definitions and tests before designing; never invent resources.

## Output Format
API contract: resource table (verb, path, success/failure codes), error envelope, pagination rule, versioning policy, and deviations from existing code.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
