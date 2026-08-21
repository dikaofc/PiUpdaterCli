# Skill: Runtime Instrumentation

## Purpose

Use runtime instrumentation (tracing, logging, profilers, debuggers) on local
instances to observe behavior and confirm findings.

## Scope

- Included: tracing, targeted logging, profiling, debugger inspection.
- Excluded: production instrumentation without authorization.
- Layers: runtime.

## Trigger Conditions

- Hard-to-observe behaviors.
- Performance findings.

## Inputs

- local instance
- instrumentation tools

## Investigation Method

1. Identify entry points: target operations.
2. Identify trust boundaries: local only.
3. Track relevant data: instrumented events.
4. Identify validation: observation points.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: evidence.
10. Validate the finding: repeat instrumentation.

## Evidence Requirements

- E3: instrumented observations.

## Confidence

- HIGH with E3.

## Severity

- N/A.

## Safe Reproduction

- Local instrumentation; never production.

## Root Cause

- Supports root-cause work.

## Impact

- Deep evidence.

## Remediation

- Per finding.

## Regression Test

- Per finding.

## Common False Positives

- Instrumentation altering behavior (verify with uninstrumented runs).

## Related Skills

- `dynamic-behavior-analysis.md`
- `../observability/monitoring-coverage.md`
- `../context/runtime-model.md`

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

- Profiling/tracing docs (per stack)
