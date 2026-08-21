# Bug: <title>

## Classification

- **Type:** <Correctness | Reliability | Performance | Concurrency | Error handling | ...>
- **Severity:** <CRITICAL | HIGH | MEDIUM | LOW | INFORMATIONAL>
- **Confidence:** <CONFIRMED | HIGH | MEDIUM | LOW | FALSE POSITIVE>
- **Evidence level:** <E0–E5>

## Affected Component

<component / file / function>

## Expected Behavior

<what should happen per spec/intent>

## Actual Behavior

<what happens; the observable deviation>

## Root Cause

<the underlying defect>

## Evidence

<failing test, log, trace, minimal repro output>

## Data Flow / Sequence

<the execution path or state sequence leading to the bug>

## Impact

<user-visible consequences: data corruption, wrong results, outage, financial>

## Reproduction

<safe minimal reproduction steps>

## Why It Happens

<mechanism>

## Remediation

<minimal fix>

## Regression Test

<test proving fix + normal behavior>

## Related Components

<similar patterns elsewhere>

## False Positive Considerations

<why this is a real bug, not intended behavior or environment artifact>

---

## Notes

- Distinguish intended behavior (documented) from bugs — check docs/comments/spec
  before filing.
- Reliability and performance bugs are valid findings; availability is impact.
