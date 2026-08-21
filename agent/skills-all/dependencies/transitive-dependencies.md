# Skill: Transitive Dependencies

## Purpose

Analyze transitive dependencies: which packages pull vulnerable/incompatible
transitives, version resolution conflicts, and duplicate versions.

## Scope

- Included: tree resolution, version conflicts, hoisting semantics, transitive
  reachability.
- Excluded: lockfile integrity (`lockfile-analysis.md`).
- Layers: dependency graph.

## Trigger Conditions

- Vulnerable transitive packages.
- Version conflicts/duplicates.

## Inputs

- lockfiles
- dependency trees (npm ls / go mod graph etc.)

## Investigation Method

1. Identify entry points: top-level deps.
2. Identify trust boundaries: N/A.
3. Track relevant data: transitive resolution.
4. Identify validation: pinned versions.
5. Identify security-sensitive operations: transitive usage.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: reachability.
10. Validate the finding: trace who imports the transitive.

## Evidence Requirements

- E1: lockfile/tree entries.
- E2: import path for flagged transitives.

## Confidence

- HIGH with E2; MEDIUM with E1.

## Severity

- Per reachability ladder.

## Safe Reproduction

- Local dependency-tree inspection.

## Root Cause

- Unconstrained ranges; duplicate versions.

## Impact

- Hidden vulnerable code, behavior inconsistencies.

## Remediation

- Constrain versions; deduplicate; upgrade top-level where possible.

## Regression Test

- Lockfile/tree assertions + upgrade tests.

## Common False Positives

- Transitives present but unused by app code.

## Related Skills

- `dependency-audit.md`
- `lockfile-analysis.md`
- `../static-analysis/call-graph-analysis.md`

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

- Package manager docs (npm, pip, go, cargo...)
- OSV.dev
