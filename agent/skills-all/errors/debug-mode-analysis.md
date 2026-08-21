# Skill: Debug Mode Analysis

## Purpose

Detect debug/verbose modes enabled in production: debug flags, verbose
logging, dev error pages, profilers, and test routes exposing internals.

## Scope

- Included: debug flags, framework dev-mode responses, verbose error pages,
  admin/debug endpoints, source maps in prod.
- Excluded: stack-trace leakage generally (`stack-trace-exposure.md`).
- Layers: config + responses.

## Trigger Conditions

- Debug flags in config.
- Dev error pages returning internals.
- Claims of "production build" to verify.

## Inputs

- source code/config
- tests

## Investigation Method

1. Identify entry points: debug routes/pages.
2. Identify trust boundaries: N/A.
3. Track relevant data: debug output.
4. Identify validation: env-based gating.
5. Identify security-sensitive operations: internal disclosure.
6. Inspect authorization: N/A.
7. Inspect error handling: dev vs prod behavior.
8. Inspect tests: production-mode tests.
9. Determine exploitability or correctness impact: exposure.
10. Validate the finding: local production-mode config tests.

## Evidence Requirements

- E1: debug config/code.
- E3: test showing debug output in production-mode config.

## Confidence

- CONFIRMED with E3; HIGH with E1.

## Severity

- MEDIUM–HIGH depending on what debug exposes.

## Safe Reproduction

- Local tests running with production-like config.

## Root Cause

- Debug defaults; env gating inverted.

## Impact

- Internal data/source disclosure, easier exploitation.

## Remediation

- Environment-gated debug; verify prod build/config; remove debug endpoints.

## Regression Test

- Tests asserting debug disabled under production config.

## Common False Positives

- Debug flags only in dev configs (verify prod config).

## Related Skills

- `stack-trace-exposure.md`
- `../infrastructure/configuration-security.md`
- `sensitive-error-data.md`

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
- CWE-489 / CWE-215
