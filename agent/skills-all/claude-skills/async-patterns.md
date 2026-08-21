---
name: async-patterns
description: Write correct async code — cancellation, backpressure, and unhandled-rejection safety.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [async, promises, events]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Async Patterns

## Objective
Avoid callback hell, leaks, and unhandled rejections with explicit async control flow.

## Preconditions
- `cap repo` run; async style (promises, async/await, Rx) identified via `cap explore`.

## Workflow
1. Run `cap search` for unhandled promises, missing awaits, and fire-and-forget calls.
2. Await or explicitly fork every promise; attach a top-level rejection handler.
3. Add cancellation (AbortController/signal) to long-running and outbound calls.
4. Apply backpressure/batching for streams and queues to avoid memory growth.
5. Replace polling with events/webhooks where the system supports it.
6. Record the async rules with `cap memory add`.

## Verification
- [ ] No floating promises (all awaited or handled).
- [ ] Long calls cancellable.
- [ ] Streams have backpressure.
- [ ] No unhandledRejection at shutdown.

## Failure Handling
- If a promise is intentionally backgrounded, name it and catch it.
- If backpressure unsupported, cap buffer and shed load.

## Output Format
Async audit: fixed floating promises, cancellation points, backpressure, and handler additions.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
