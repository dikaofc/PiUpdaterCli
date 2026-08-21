---
name: error-handling
description: Design error types, boundaries, and recovery so failures degrade gracefully.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [errors, resilience]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Resilient Error Handling

## Objective
Make errors explicit, typed, and handled at the right boundary without swallowing or leaking.

## Preconditions
- `cap repo` run; current error patterns reviewed (`cap search <throw|catch|reject|error>`).

## Workflow
1. Run `cap explore` for the call stack boundaries (handlers, workers, clients).
2. Define a small set of typed errors with codes; map which are retryable vs fatal.
3. Catch at boundaries only; let domain errors bubble with context, not raw stack.
4. Add retry with backoff + jitter for transient failures; cap attempts and fail safe.
5. Return safe error responses to clients; log the full error internally with correlation id.
6. Record the error taxonomy with `cap memory add`.

## Verification
- [ ] No empty catch blocks or swallowed errors.
- [ ] Retries bounded with backoff + jitter.
- [ ] Client errors contain no stack/secret.
- [ ] Fatal vs retryable classified.

## Failure Handling
- If a catch hides the cause, rethrow with context.
- If retries amplify load, add circuit breaking.

## Output Format
Error design: typed taxonomy, boundary policy, retry/circuit rules, and the response shape.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
