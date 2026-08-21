# Skill: Lockfile Analysis

## Purpose

Analyze lockfiles: manifest-lockfile consistency, pinned integrity, committed
lockfiles, and resolution drift.

## Scope

- Included: lockfile presence/commit, consistency with manifest, integrity
  hashes, resolution changes.
- Excluded: known-vulnerability lookup (`dependency-audit.md`).
- Layers: dependency management.

## Trigger Conditions

- Missing/uncommitted lockfiles.
- Claims of "reproducible builds" to verify.

## Inputs

- manifests/lockfiles
- CI configs

## Investigation Method

1. Identify entry points: dependency install paths.
2. Identify trust boundaries: N/A.
3. Track relevant data: resolved versions.
4. Identify validation: lockfile correctness.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: drift.
10. Validate the finding: compare manifest vs lockfile.

## Evidence Requirements

- E1: manifest/lockfile evidence.
- E2: drift/pinning gap.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM for missing/unsynced lockfiles (reproducibility); LOW for hygiene.

## Safe Reproduction

- Local lockfile inspection; install dry-run.

## Root Cause

- Lockfiles ignored; manual dependency changes.

## Impact

- Non-reproducible builds, unexpected vulnerable versions.

## Remediation

- Commit lockfiles; pin with integrity; CI lockfile-consistency checks.

## Regression Test

- CI checks asserting lockfile sync.

## Common False Positives

- Projects with verified reproducible resolution (still recommend lockfiles).

## Related Skills

- `dependency-audit.md`
- `package-integrity.md`
- `../supply-chain/supply-chain-risk.md`

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

- Package manager lockfile docs
- OWASP Dependency Management
