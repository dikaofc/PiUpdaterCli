# Skill: Resource Exhaustion

## Purpose

Analyze resource exhaustion: unbounded memory/CPU/threads/connections/file
descriptors driven by attacker-controlled input or volume.

## Scope

- Included: memory, CPU, threads, connections, fds, disk via input.
- Excluded: specific types (cpu/disk/connection skills).
- Layers: runtime.

## Trigger Conditions

- User-controlled size/iteration/concurrency.
- Claims of "bounded" to verify.

## Inputs

- source code
- configs (limits)

## Investigation Method

1. Identify entry points: resource-consuming operations.
2. Identify trust boundaries: input → resources.
3. Track relevant data: resource use drivers.
4. Identify validation: limits.
5. Identify security-sensitive operations: N/A (availability).
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: exhaustion tests.
9. Determine exploitability or correctness impact: DoS.
10. Validate the finding: local load tests.

## Evidence Requirements

- E1: resource use code.
- E2: unbounded path.
- E3: test demonstrating exhaustion.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH (availability).

## Safe Reproduction

- Local load tests with bounded limits and timeouts.

## Root Cause

- Missing limits on input-driven resource use.

## Impact

- DoS, cascading failures.

## Remediation

- Limits (size, concurrency, timeouts); backpressure; pooling.

## Regression Test

- Tests asserting resource bounds under load.

## Common False Positives

- Platform-enforced limits (verify).

## Related Skills

- `cpu-exhaustion.md`
- `memory-leak-analysis.md`
- `connection-leak.md`
- `../api/api-rate-limiting.md`

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

- OWASP DoS Prevention guidance
- CWE-400
