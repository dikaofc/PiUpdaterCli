# Pattern: Secure Error Handling

## Problem

Error handling must not leak internals, bypass security checks, or leave the
system in an unsafe state on failure.

## Design

1. **Generic client-facing errors.** Client gets a safe, generic message with an
   error id; full details go to server logs (`skills/errors/stack-trace-exposure.md`,
   `sensitive-error-data.md`).
2. **Central error boundary.** One place converts exceptions to responses; no
   framework stack traces reach clients (`error-boundary-analysis.md`).
3. **Fail closed.** On validation/authorization/verification failure, deny and log;
   never fall through to an insecure default (`fallback-security.md`).
4. **State consistency.** Multi-step operations roll back or are idempotent on
   failure; no partial state (`exception-analysis.md`).
5. **Resilience:** timeouts on external calls; bounded retries with backoff; no
   retry storms (`timeout-analysis.md`, `retry-analysis.md`).
6. **No sensitive data in errors:** tokens, internal URLs, DB schema, or PII in
   error payloads.

## Verify

- Exception-injection tests per error path; assert safe response shape, no
  leakage, and consistent state.

## Anti-Patterns

- Catching and returning `exc` strings; fallback that grants access on failure;
  swallowing exceptions without logging; infinite retry loops.

## Related

- `../skills/errors/*`
- `../checklists/error-handling.md`
