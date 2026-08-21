# Skill: Stack Trace Exposure

## Purpose

Detect stack traces, debug pages, and internal exception details exposed to
clients (HTML/API), leaking code structure, versions, and paths.

## Scope

- Included: unhandled exception pages, stack traces in API errors, framework
  debug pages, source snippets.
- Excluded: sensitive data in errors (`sensitive-error-data.md`).
- Layers: responses.

## Trigger Conditions

- Framework default error pages.
- Claims of "sanitized errors" to verify.

## Inputs

- source code (error handling)
- tests

## Investigation Method

1. Identify entry points: error-generating handlers.
2. Identify trust boundaries: internals → client.
3. Track relevant data: exception → response.
4. Identify validation: sanitized error mapping.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: the subject.
8. Inspect tests: error-response tests.
9. Determine exploitability or correctness impact: leakage.
10. Validate the finding: trigger errors locally.

## Evidence Requirements

- E1: error middleware.
- E3: test showing traceback in responses.

## Confidence

- CONFIRMED with E3; HIGH with E1.

## Severity

- MEDIUM (reconnaissance aid).

## Safe Reproduction

- Local tests forcing exceptions and inspecting responses.

## Root Cause

- Dev-mode error pages in prod; returning exception messages.

## Impact

- Code/path/version disclosure aiding attacks.

## Remediation

- Generic client errors; log full traces server-side; env-gate debug pages.

## Regression Test

- Tests asserting no traceback in client responses.

## Common False Positives

- Framework sanitizing by default (verify version/config).

## Related Skills

- `debug-mode-analysis.md`
- `sensitive-error-data.md`
- `../api/api-error-handling.md`

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected
- [ ] Severity assigned
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed

## References

- OWASP Error Handling Cheat Sheet
- CWE-209 / CWE-215
