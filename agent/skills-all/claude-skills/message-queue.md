---
name: message-queue
description: Use queues/brokers correctly — ack semantics, retries, and dead-letter.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [queue, messaging, async]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Message Queue Usage

## Objective
Process work asynchronously with reliable delivery and safe failure handling.

## Preconditions
- `cap repo` run; broker and consumer code reviewed (`cap explore <queue|consumer|broker>`).

## Workflow
1. Run `cap explore` for producers and consumers and their ack logic.
2. Ack only after successful processing; use manual ack to avoid lost messages.
3. Add bounded retries with backoff; send poison messages to a dead-letter queue.
4. Make handlers idempotent (see event-driven) for at-least-once safety.
5. Set prefetch/concurrency limits to control throughput and memory.
6. Record queue/topology with `cap memory add`.

## Verification
- [ ] Ack after processing (no early ack).
- [ ] Retries bounded + DLQ present.
- [ ] Handlers idempotent.
- [ ] Concurrency/prefetch tuned.

## Failure Handling
- If messages duplicate, dedupe by id.
- If DLQ grows, alert and inspect.

## Output Format
Queue design: topology, ack policy, retry/DLQ, idempotency, and tuning.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
