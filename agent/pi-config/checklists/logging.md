# Checklist: Logging

Verification checklist for logging and audit trails.

## Data Protection

- [ ] No passwords, tokens, cookies, API keys, or PII in logs
  (`logging-security.md`)
- [ ] Query parameters and headers redacted where sensitive
- [ ] Log redaction tested (structured logs checked, not only grepped)

## Coverage

- [ ] Authentication events logged: login success/failure, logout, lockouts,
  password changes, privilege changes (`audit-trail-analysis.md`)
- [ ] Authorization denials logged
- [ ] State-changing operations logged with actor, action, object
- [ ] Error paths logged with enough context to debug

## Integrity

- [ ] Logs cannot be trivially forged/altered by the application user
  (`audit-trail-analysis.md`)
- [ ] Audit events include timestamps and actor identity (server-side, not
  client-claimed)
- [ ] Log retention and access control defined

## Operations

- [ ] Log volume bounded (no log flooding from attacker-controlled input)
  (`log-injection.md`, `disk-exhaustion.md`)
- [ ] Logs shipped to central store; monitoring/alerts on security events
  (`monitoring-coverage.md`, `alerting-correctness.md`)

## Related

- `../skills/observability/logging-security.md`
- `../checklists/error-handling.md`
