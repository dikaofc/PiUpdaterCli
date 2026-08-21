# Skill: Algorithmic Complexity

## Purpose

Analyze algorithmic complexity: superlinear algorithms driven by input size
(O(n²), N+1 queries, repeated scans) causing performance issues and DoS.

## Scope

- Included: complexity analysis, N+1, repeated work, input-size scaling.
- Excluded: CPU-specific issues (`cpu-exhaustion.md`).
- Layers: runtime.

## Trigger Conditions

- Nested loops over input.
- N+1 query patterns.
- Large input handling.

## Inputs

- source code
- profiling data

## Investigation Method

1. Identify entry points: input-driven algorithms.
2. Identify trust boundaries: input size.
3. Track relevant data: cost scaling.
4. Identify validation: complexity bounds.
5. Identify security-sensitive operations: N/A (availability).
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: scaling tests.
9. Determine exploitability or correctness impact: slowdown.
10. Validate the finding: scaling measurements.

## Evidence Requirements

- E1: algorithm code.
- E2: superlinear path.
- E3: test demonstrating scaling.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local scaling tests with increasing input sizes.

## Root Cause

- Nested loops; N+1 queries; repeated scans.

## Impact

- Slowdowns, request timeouts, DoS.

## Remediation

- Efficient algorithms; query batching; indexes; input caps.

## Regression Test

- Scaling tests asserting acceptable growth.

## Common False Positives

- Inputs bounded elsewhere (verify).

## Related Skills

- `cpu-exhaustion.md`
- `../database/query-safety.md`
- `../api/api-pagination.md`

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

- Complexity analysis references
- CWE-400
