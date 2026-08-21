# Checklist: Error Handling

Verification checklist for error handling.

## Leakage

- [ ] No stack traces, exception internals, or framework internals to clients
  (`stack-trace-exposure.md`)
- [ ] DB/query errors do not expose schema or data (`database-error-leakage.md`)
- [ ] Error responses use generic messages for security-sensitive failures
  (auth, payment) (`sensitive-error-data.md`)
- [ ] No sensitive data in error payloads (tokens, ids, internal URLs)

## Behavior

- [ ] Error paths do not bypass authorization or state checks
  (`error-boundary-analysis.md`, `fallback-security.md`)
- [ ] Partial failures handled: no corrupt state on exception
  (`exception-analysis.md`)
- [ ] Fallbacks are secure (no insecure default on failure)
  (`fallback-security.md`)

## Resilience

- [ ] External calls have timeouts (`timeout-analysis.md`)
- [ ] Retries safe and bounded; no retry storms (`retry-analysis.md`)
- [ ] Error paths tested (exception injection tests)
- [ ] Error monitoring alerts configured

## Related

- `../skills/errors/*`
- `../checklists/logging.md`
