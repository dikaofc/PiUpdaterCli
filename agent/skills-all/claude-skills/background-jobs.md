---
name: background-jobs
description: Offload slow work to workers with scheduling, retry, and observability.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [jobs, workers, async]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Background Jobs & Workers

## Objective
Move heavy/async work off the request path with reliable scheduling and visibility.

## Preconditions
- `cap repo` run; job framework or cron reviewed (`cap explore <job|worker|cron|queue>`).

## Workflow
1. Run `cap explore` for the work that blocks requests or runs periodically.
2. Pick a worker/queue model (see message-queue) or scheduler for crons.
3. Make jobs idempotent and resumable; persist state for long jobs.
4. Add retry with backoff and a timeout; alert on stuck/failed jobs.
5. Emit progress + result via events or status store; avoid polling.
6. Record job catalog with `cap memory add`.

## Verification
- [ ] Slow work off request path.
- [ ] Jobs idempotent + resumable.
- [ ] Retry/timeout + alerting set.
- [ ] Progress observable.

## Failure Handling
- If job duplicates on retry, dedupe by job id.
- If cron drifts, use a leader-elected scheduler.

## Output Format
Worker design: job catalog, scheduling, retry/timeout, and observability.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
