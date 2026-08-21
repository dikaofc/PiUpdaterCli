---
name: webhooks
description: Design reliable webhook systems — signing, retries, replay, delivery at-least-once, consumer guidance.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Webhooks

## Model
Provider publishes events (JSON, stable schema, `event_type` + `event_id` + `timestamp` + payload versioned); consumer registers URL + subscribes to types. Payload must be backwards-compatible (additive only) — version bump for breaks.

## Security (must)
- Sign every delivery: `HMAC-SHA256` of raw body with per-endpoint secret; header `X-Signature: sha256=...`; consumer verifies before processing (timing-safe compare).
- Replay protection: `X-Hook-Id` (event id) header — consumer dedupes by id (at-least-once delivery guarantees duplicates).
- Never put secrets/tokens in payload; secrets sent out-of-band at registration.
- Auth for webhook registration endpoints (who can register → must be authenticated + verify ownership with a challenge (GET returns random token, POST echoes it) — prevents hijacking.

## Delivery
- Filtering: consumer subscribes by type; delivery batched (up to N events) or individual — document; HTTPS only.
- Retry schedule e.g. 5 attempts: 1m/5m/30m/2h/6h; then discard or dead-letter with alert. Backoff + jitter; respect `Retry-After` from consumer.
- Timeouts: consumer must respond fast (≤10s) — big work belongs in the consumer's queue, not the request handler.
- Failure surfaces: dashboard/UI listing recent deliveries (status, latency, last error) as consumer-support, webhook debugger.

## Consumer guidance (deliver as docs)
- Verify signature before parse; dedupe by id; process idempotently (already-event exists → 2xx no-op).
- Respond 2xx quickly (ack); 4xx/5xx → provider retries per schedule.
- Store raw payload + delivery metadata for audit.

## Checklist
- [ ] HMAC signatures + verification path
- [ ] Replay/dedupe by event id
- [ ] Retry schedule + dead-letter + alerting
- [ ] Registration requires auth + ownership verification
- [ ] Payload versioning strategy documented