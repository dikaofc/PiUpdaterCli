---
name: background-jobs
description: Design background job systems — queues, workers, retries, idempotency, delivery guarantees, monitoring.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Background Jobs

## When
- Emails, notifications, webhooks, report generation, media processing, LLM calls, scheduled syncs. Anything whose latency > request budget or that may fail and should retry.

## Queue choice
- Managed: Redis-backed (BullMQ/Resque compatible), SQS/SNS (AWS), CloudTasks (GCP), Celery (Python). Self-host only when ops team exists.
- If no infra: in-process scheduler (cron + locks) acceptable for tiny apps — but jobs lost on restart; document tradeoff.

## Job contract
- Payload: ids/references, not full data blobs (avoid stale copies; refetch at run time). Include `job_type` + idempotency key.
- Worker: `process(job)` pure — read, do, write. Idempotent by design: second run must be safe (unique constraint on output, skip-if-exists).
- Retries: exponential backoff + jitter; max attempts (3-5 typical) then dead-letter queue + alert. Retry on transient errors only — permanent failures (invalid payload, 4xx) fail fast.

## Delivery semantics
- At-least-once: every job type handles duplicate runs. Exactly-once needs idempotency store (dedupe by key in DB).
- Ordering: single queue (FIFO) per priority class; delays/`schedule_at` for "in 1h".
- Concurrency: worker pool sized to downstream limits (SMTP rate, API quotas); per-job timeout + kill on hang.

## Failure handling
- Job-level: record error + attempt count; poison messages visible.
- Alerts: failed->deadletter threshold, queue depth growth, worker down.
- Observability: job name, id, latency percentiles, retry counts emitted; tracing correlation with request that enqueued.

## Checklist
- [ ] Payload minimal (ids+keys)
- [ ] Idempotent workers, dedupe key
- [ ] Backoff + max attempts + DLQ
- [ ] Timeouts + concurrency caps
- [ ] Dead-letter alerting
- [ ] Graceful shutdown drains