# Skill: DOM Sink Analysis

## Purpose

Analyze dangerous DOM sinks in client code: innerHTML, document.write, eval,
location assignment, postMessage handling — where untrusted data executes or
navigates.

## Scope

- Included: sink inventory, source→sink flows, sink misuse.
- Excluded: XSS classification (`../web/dom-xss.md`).
- Layers: frontend.

## Trigger Conditions

- Dangerous DOM APIs with variable data.
- New client features.

## Inputs

- frontend code

## Investigation Method

1. Identify entry points: client sources.
2. Identify trust boundaries: data → DOM.
3. Track relevant data: source → sink.
4. Identify validation: sanitization.
5. Identify security-sensitive operations: DOM writes.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: sink tests.
9. Determine exploitability or correctness impact: execution.
10. Validate the finding: local sink tests.

## Evidence Requirements

- E1: sink code.
- E2: controllable source → sink.
- E3: test demonstrating execution/navigation.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH depending on sink and data.

## Safe Reproduction

- Local headless tests with crafted inputs.

## Root Cause

- Using dangerous APIs with untrusted data.

## Impact

- XSS, open redirect, data theft.

## Remediation

- Safe DOM APIs; validation; framework escaping.

## Regression Test

- Sink tests asserting safe behavior.

## Common False Positives

- Sinks with fixed trusted values.

## Related Skills

- `../web/dom-xss.md`
- `unsafe-rendering.md`
- `../web/xss-analysis.md`

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

- OWASP DOM-based XSS Prevention Cheat Sheet
- CWE-79
