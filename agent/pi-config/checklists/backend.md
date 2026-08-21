# Checklist: Backend

Verification checklist for server-side code.

## Entry Points

- [ ] Every handler validates input at the boundary
  (`backend-entrypoint-analysis.md`)
- [ ] Middleware ordering correct (auth before authorization before logic)
  (`middleware-analysis.md`)
- [ ] Controllers thin; logic in service layer with authorization
  (`controller-analysis.md`, `service-layer-analysis.md`)
- [ ] Repository/data access layer enforces row/tenant filtering
  (`repository-layer-analysis.md`)

## Sinks

- [ ] No string-built queries (parameterized/ORM only) (`query-safety.md`)
- [ ] No shell composition with untrusted input (`command-injection.md`)
- [ ] File paths canonicalized; no traversal (`path-traversal.md`)
- [ ] No unsafe deserialization of untrusted data (`deserialization-analysis.md`)
- [ ] SSRF prevented on outbound requests (`ssrf-analysis.md`)

## Background & Async

- [ ] Workers/queues validate message content and re-check authorization
  (`worker-security.md`, `queue-security.md`)
- [ ] Background jobs idempotent; retries safe (`retry-analysis.md`,
  `duplicate-operation.md`)
- [ ] Scheduled jobs use least-privilege credentials

## Errors & Logs

- [ ] No stack traces to clients (`stack-trace-exposure.md`)
- [ ] No sensitive data in logs (`logging-security.md`)
- [ ] Timeouts on all external calls (`timeout-analysis.md`)

## Related

- `../skills/backend/*`
- `../checklists/error-handling.md`, `../checklists/logging.md`
