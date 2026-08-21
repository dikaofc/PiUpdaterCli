# Skill: CPU Exhaustion

## Purpose

Analyze CPU exhaustion: expensive operations driven by input (regex
backtracking, O(n²) loops, crypto work, sync work in async paths) causing DoS.

## Scope

- Included: algorithmic cost drivers, ReDoS, unbounded iterations,
  computation per request.
- Excluded: memory/disk (other skills).
- Layers: runtime.

## Trigger Conditions

- User-controlled iteration/computation.
- Regex on user input.
- Claims of "fast path" to verify.

## Inputs

- source code
- profiling data

## Investigation Method

1. Identify entry points: computation-heavy operations.
2. Identify trust boundaries: input → cost.
3. Track relevant data: cost drivers.
4. Identify validation: bounds.
5. Identify security-sensitive operations: N/A (availability).
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: cost tests.
9. Determine exploitability or correctness impact: DoS.
10. Validate the finding: timing tests.

## Evidence Requirements

- E1: cost-driving code.
- E2: unbounded cost.
- E3: test demonstrating superlinear time.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local timing tests with crafted worst-case inputs (bounded timeouts).

## Root Cause

- ReDoS, O(n²) loops, unbounded input-driven work.

## Impact

- CPU DoS, service slowdown.

## Remediation

- Bounded loops; safe regex; input limits; caching; async isolation.

## Regression Test

- Timing tests asserting acceptable cost.

## Common False Positives

- Costs bounded by input size limits (verify).

## Related Skills

- `algorithmic-complexity.md`
- `infinite-loop-analysis.md`
- `resource-exhaustion.md`

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

- OWASP Regular Expression DoS
- CWE-400 / CWE-1333
