---
name: sdk-design
description: Build client SDKs with typed clients, retries, and clear errors.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [sdk, api-design, developer-experience]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# SDK Design

## Objective
Wrap an API in an SDK that is typed, forgiving, and pleasant to consume.

## Preconditions
- `cap repo` run; target API/contract known (`cap explore <api|openapi|client>`).

## Workflow
1. Run `cap explore` for the API surface to wrap and any existing client.
2. Generate/define typed request/response models; one method per endpoint.
3. Centralize base URL, auth, and retry/timeout (see error-handling, rate-limiting).
4. Return typed errors with codes; never throw raw transport errors to callers.
5. Add pagination/cursor helpers and streaming where the API supports it.
6. Record the SDK surface with `cap memory add`.

## Verification
- [ ] All endpoints covered with typed models.
- [ ] Auth/retry/timeout centralized.
- [ ] Errors typed.
- [ ] Pagination/streaming helpers present.

## Failure Handling
- If API unstable, version the SDK independently.
- If platform missing types, ship a typed shim.

## Output Format
SDK design: client methods, models, shared config, error model, and helpers.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
