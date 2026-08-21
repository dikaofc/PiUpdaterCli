# Skill: Dead Code Analysis

## Purpose

Analyze dead code: unreachable/unused code, unused parameters, and leftover
debug paths that can hide vulnerabilities or expose stale functionality.

## Scope

- Included: unreachable functions, unused imports, legacy endpoints, dormant
  debug code.
- Excluded: reachability of entry points (`../reconnaissance/entrypoint-discovery.md`).
- Layers: source.

## Trigger Conditions

- Large legacy codebases.
- Unused functions/endpoints.

## Inputs

- source code
- coverage data

## Investigation Method

1. Identify entry points: usage references.
2. Identify trust boundaries: N/A.
3. Track relevant data: references.
4. Identify validation: reachability.
5. Identify security-sensitive operations: stale code.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: stale surface.
10. Validate the finding: confirm no references.

## Evidence Requirements

- E1: code + reference search.
- E2: no reachable references.

## Confidence

- CONFIRMED with reference verification.

## Severity

- LOW typically; higher if stale code is reachable via hidden paths.

## Safe Reproduction

- Static reference analysis.

## Root Cause

- N/A.

## Impact

- Hidden attack surface, confusion.

## Remediation

- Remove dead code; document kept code.

## Regression Test

- Coverage/reference checks.

## Common False Positives

- Code reached via reflection/dynamic calls (check).

## Related Skills

- `call-graph-analysis.md`
- `../reconnaissance/entrypoint-discovery.md`
- `../errors/debug-mode-analysis.md`

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

- Code analysis references
- CWE-561
