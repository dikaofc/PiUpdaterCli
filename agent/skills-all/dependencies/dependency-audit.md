# Skill: Dependency Audit

## Purpose

Audit dependencies against known vulnerabilities with reachability analysis:
installed, included, used, reachable, unmitigated — before rating.

## Scope

- Included: advisory cross-referencing, reachability ladder, version pinning,
  patch assessment.
- Excluded: supply-chain provenance (`../supply-chain/supply-chain-risk.md`).
- Layers: dependency management.

## Trigger Conditions

- Any dependency change/audit.
- Claims of "no vulnerabilities" to verify.

## Inputs

- manifests/lockfiles
- advisory sources (OSV, GitHub Advisory, vendor)
- source (usage)

## Investigation Method

1. Identify entry points: dependency set.
2. Identify trust boundaries: N/A.
3. Track relevant data: vulnerable package usage.
4. Identify validation: advisory match.
5. Identify security-sensitive operations: vulnerable sinks.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: reachability.
10. Validate the finding: run the reachability ladder.

## Evidence Requirements

- E1: manifest/lockfile + advisory.
- E2: usage path for reachable advisories.
- E3: behavioral confirmation for HIGH claims.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- Per reachability: reachable+exploitable → real severity; else LOW/INFO.

## Safe Reproduction

- Local advisory lookups and usage tracing; no network exploitation.

## Root Cause

- Version pinned in vulnerable range; missing upgrades.

## Impact

- Depends on reachable vulnerability class.

## Remediation

- Minimal version upgrade; verify behavior with regression tests.

## Regression Test

- Upgrade + contract tests for the affected behavior.

## Common False Positives

- Advisory applies to unused/unreachable code (verify per
  `../context/dependency-model.md`).

## Related Skills

- `../context/dependency-model.md`
- `transitive-dependencies.md`
- `outdated-dependency-analysis.md`
- `../workflows/dependency-audit.md`

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

- OSV.dev, GitHub Advisory Database
- NVD
