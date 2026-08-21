# Pattern: Secure Logging

## Problem

Logs must support security operations and debugging without leaking sensitive data,
and without being forgeable or floodable.

## Design

1. **Never log secrets.** Passwords, tokens, cookies, API keys, PII, and full
   payment data are excluded by default; structured logging with field-level
   redaction (`skills/observability/logging-security.md`).
2. **Log security events:** auth success/failure, logout, password change,
   privilege change, authorization denials, sensitive state changes — with
   server-side actor identity and timestamps (`audit-trail-analysis.md`).
3. **Redact at the source,** then verify the rendered log line (loggers with
   serializers can leak via nested objects).
4. **Bounded volume:** cap per-event size; no unbounded growth from attacker-
   controlled input; log injection neutralized (newlines/CRLF not trusted as
   control) (`skills/injection/log-injection.md`).
5. **Integrity & access:** audit logs append-only and access-controlled;
   central aggregation with retention policy.

## Verify

- Log review tests: trigger each security event and assert the rendered line
  contains no sensitive values.
- `../checklists/logging.md`.

## Anti-Patterns

- Logging the raw request body/headers; string-formatting secrets into messages;
  client-claimed actor identity.

## Related

- `../skills/observability/*`
- `../checklists/logging.md`
