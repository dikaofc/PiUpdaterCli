---
name: rest-best-practices
description: Apply REST hygiene — status codes, idempotency, HATEOAS-lite, and content negotiation.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [rest, api, hygiene]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# REST Best Practices

## Objective
Make existing HTTP endpoints predictable and correct per REST conventions.

## Preconditions
- `cap repo` run; route handlers reviewed (`cap explore <route|controller>`).

## Workflow
1. Run `cap explore` for handlers and classify current code/status usage.
2. Return correct codes: 2xx success, 4xx client, 5xx server; avoid 200-with-error bodies.
3. Make unsafe writes idempotent via `Idempotency-Key` where retries matter.
4. Use proper methods (GET safe, POST/PUT/PATCH/DELETE) and content negotiation (Accept).
5. Version via path/header and document deprecated routes with sunset headers.
6. Record conventions with `cap memory add`.

## Verification
- [ ] Status codes match outcome.
- [ ] Retriable writes carry idempotency key.
- [ ] Methods semantically correct.
- [ ] Deprecations documented.

## Failure Handling
- If legacy clients depend on 200-errors, dual-emit during a transition window.
- If method mismatch, add redirect/alias.

## Output Format
REST hygiene report: code/method/idempotency fixes and the deprecation plan.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
