# Skill: Outdated Dependency Analysis

## Purpose

Analyze outdated dependencies: version age, unmaintained/deprecated
packages, upgrade risk, and whether outdatedness creates risk.

## Scope

- Included: outdatedness assessment, maintenance status, upgrade path,
  regression risk.
- Excluded: known-vulnerability lookup (`dependency-audit.md`).
- Layers: dependency management.

## Trigger Conditions

- Long-stale dependencies.
- Unmaintained packages in use.

## Inputs

- manifests/lockfiles
- registry metadata

## Investigation Method

1. Identify entry points: dependency set.
2. Identify trust boundaries: N/A.
3. Track relevant data: version age.
4. Identify validation: maintenance status.
5. Identify security-sensitive operations: dependency use.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: risk.
10. Validate the finding: assess reachability and maintenance.

## Evidence Requirements

- E1: manifest entries.
- E2: maintenance/age evidence.

## Confidence

- HIGH with E2; MEDIUM with E1.

## Severity

- LOW/INFORMATIONAL unless tied to reachable issues.

## Safe Reproduction

- Local metadata review.

## Root Cause

- No upgrade cadence.

## Impact

- Accumulated risk, unpatched bugs.

## Remediation

- Upgrade cadence; replace unmaintained packages; automated update checks.

## Regression Test

- Upgrade + regression tests for changed behavior.

## Common False Positives

- Outdated but stable and safe (document).

## Related Skills

- `dependency-audit.md`
- `../supply-chain/supply-chain-risk.md`
- `../testing/regression-testing.md`

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

- Package registry metadata
- OSV.dev
