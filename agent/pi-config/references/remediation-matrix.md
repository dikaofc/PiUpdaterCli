# Reference: Remediation Matrix

Maps defect classes to canonical remediation approaches. Detailed guidance lives in
the referenced skills and patterns.

| Defect class | Remediation | Pattern/Skill |
|---|---|---|
| SQL/NoSQL injection | parameterization, ORM bindings, allow-list identifiers | `patterns/secure-database.md`, `sql-injection.md` |
| Command injection | argv-based exec, no shell strings, input allow-list | `command-injection.md` |
| XSS | context-aware output encoding, CSP, sanitization | `xss-analysis.md`, `content-security-policy.md` |
| CSRF | per-session CSRF tokens, SameSite cookies, origin checks | `csrf-analysis.md`, `csrf-token-management.md` |
| SSRF | egress allow-list, URL/IP validation, no creds on redirect | `ssrf-analysis.md`, `url-validation.md` |
| Path traversal | canonicalize + containment, server-side names | `path-traversal.md` |
| Upload abuse | size/type validation, storage outside webroot, safe serving | `file-upload-security.md` |
| IDOR/BOLA | server-side ownership checks per operation | `bola-analysis.md`, `resource-ownership.md` |
| BFLA | function-level authorization on every privileged op | `bfla-analysis.md` |
| Weak passwords | strong KDF (Argon2id/scrypt/bcrypt), policy, MFA | `password-storage.md`, `password-policy.md` |
| Session fixation | regenerate session id on auth | `session-fixation.md` |
| JWT misuse | algorithm allow-list, expiry/audience/issuer validation | `jwt-analysis.md` |
| Hardcoded secrets | secret manager, rotate, scan CI | `hardcoded-secret-detection.md`, `secret-management.md` |
| Weak crypto | modern algorithms, correct modes/IVs, key mgmt | `cryptographic-usage.md`, `key-management.md` |
| Race conditions | atomic ops, unique constraints, locking discipline | `race-condition.md`, `atomicity-analysis.md` |
| Business-logic dup/replay | idempotency keys, state machines, server-side rules | `duplicate-operation.md`, `state-transition-analysis.md` |
| Error leakage | generic client errors, sanitized logs | `stack-trace-exposure.md`, `sensitive-error-data.md` |
| Resource exhaustion | limits, pooling, backpressure, timeouts | `resource-exhaustion.md` |
| Vulnerable dependency | minimal upgrade + regression tests | `dependency-audit.md`, `regression-testing.md` |
| Insecure config | validated config, hardened defaults, env separation | `configuration-security.md` |

## Remediation Principles

1. Fix root cause, not symptom.
2. Prefer the least invasive change that eliminates the defect class.
3. Add the regression test before considering the fix complete.
4. Re-check adjacent paths using the same pattern after the fix
   (`../METHODOLOGY.md` fixing mode).

## Related

- `../patterns/*`
- `../skills/*` (per-row references)
