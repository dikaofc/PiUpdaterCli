---
name: structured-logging
description: Emit structured, low-noise logs with consistent fields and levels.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [logging, observability]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Structured Logging

## Objective
Replace ad-hoc prints with leveled, queryable logs that aid production debugging without flooding.

## Preconditions
- `cap repo` run; existing logger and log calls found (`cap search <logger|console.log|log>`).

## Workflow
1. Run `cap search` for current logging to find inconsistency (console.log vs logger).
2. Adopt one structured logger emitting JSON with `level`, `ts`, `service`, `trace_id`.
3. Define level policy: debug in dev, info for lifecycle, warn/error for anomalies; never log secrets.
4. Add `trace_id`/`request_id` propagation at boundaries (see observability).
5. Remove noisy debug logs from hot paths; keep them behind a debug flag.
6. Record the log schema with `cap memory add`.

## Verification
- [ ] One logger, structured output, no raw console.log in app code.
- [ ] No secrets/PII in log fields.
- [ ] Levels used per policy.
- [ ] Hot-path logs gated behind debug.

## Failure Handling
- If logger unavailable, wrap console with a minimal leveled JSON shim.
- If logs flood, sample or rate-limit high-volume events.

## Output Format
Logging spec: logger choice, field schema, level policy, and the diff that removed noisy logs.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
