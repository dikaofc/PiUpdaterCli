# Checklist: Reliability

Verification checklist for reliability and availability.

## Failure Behavior

- [ ] Failures fail closed (secure defaults on error) (`fallback-security.md`)
- [ ] Crash loops impossible; supervisors/restarts configured
- [ ] State consistent after crashes/restarts (transactions, queues)
  (`transaction-integrity.md`)

## Concurrency

- [ ] Duplicate requests safe (idempotency) (`duplicate-operation.md`,
  `duplicate-request-analysis.md`)
- [ ] Race conditions reviewed on shared state (`race-condition.md`)
- [ ] Distributed locking correct where used (`lock-analysis.md`)

## Retries & Timeouts

- [ ] Retries bounded with backoff; no amplification
  (`retry-analysis.md`)
- [ ] Timeouts on all external calls (`timeout-analysis.md`)
- [ ] Queue consumers handle poison messages (`queue-security.md`)

## Availability

- [ ] No single unbounded resource consumer (`resource-exhaustion.md`)
- [ ] Degradation behavior defined (graceful degradation, not full outage)
- [ ] Monitoring covers availability (`monitoring-coverage.md`)

## Related

- `../skills/reliability` concerns in `../skills/errors/*` and
  `../skills/performance/*`
- `../checklists/performance.md`
