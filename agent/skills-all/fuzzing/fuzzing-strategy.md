# Skill: Fuzzing Strategy

## Purpose

Select and design fuzzing strategies: coverage-guided, grammar-based, API and
protocol fuzzing for parsers, serializers, and endpoints.

## Scope

- Included: strategy selection, target identification, harness needs,
  result triage.
- Excluded: harness details (`fuzz-harness-design.md`).
- Layers: testing/QA.

## Trigger Conditions

- Parser/serializer-heavy code.
- Claims of "fuzz tested" to verify.

## Inputs

- target code
- formats/protocols

## Investigation Method

1. Identify entry points: fuzz targets.
2. Identify trust boundaries: N/A.
3. Track relevant data: input formats.
4. Identify validation: coverage goals.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: existing.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: run fuzz campaigns.

## Evidence Requirements

- E1: target/harness evidence.
- E3: fuzz findings (crashes) with reproducers.

## Confidence

- CONFIRMED with reproducible findings.

## Severity

- N/A (finds feed findings).

## Safe Reproduction

- Local fuzzing in sandboxes with time bounds.

## Root Cause

- N/A.

## Impact

- Discovers parser/memory/logic bugs.

## Remediation

- Fuzz critical parsers in CI; triage findings.

## Regression Test

- Each fuzz finding becomes a regression test.

## Common False Positives

- Fuzzing targets with no harness coverage (unrepresentative).

## Related Skills

- `fuzz-harness-design.md`
- `corpus-generation.md`
- `crash-triage.md`
- `../testing/property-based-testing.md`

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

- OWASP Fuzzing guidance
- libFuzzer/AFL docs
