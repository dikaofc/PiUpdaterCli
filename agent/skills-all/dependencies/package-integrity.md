# Skill: Package Integrity

## Purpose

Analyze package integrity: integrity hashes, signature verification, checksum
pinning, and protection against tampered packages.

## Scope

- Included: lockfile hashes, registry signatures, SBOM, checksum verification,
  vendored code integrity.
- Excluded: advisory lookup (`dependency-audit.md`).
- Layers: dependency supply.

## Trigger Conditions

- Installs without integrity verification.
- Claims of "verified packages" to verify.

## Inputs

- lockfiles/configs
- CI configs

## Investigation Method

1. Identify entry points: install paths.
2. Identify trust boundaries: registry → code.
3. Track relevant data: artifact verification.
4. Identify validation: hash/signature checks.
5. Identify security-sensitive operations: install execution.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: tamper risk.
10. Validate the finding: verify lockfile hashes/config.

## Evidence Requirements

- E1: install config/lockfile.
- E2: missing integrity verification.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM (supply-chain hardening); HIGH with demonstrated tamper path.

## Safe Reproduction

- Local config review.

## Root Cause

- No hash pinning; missing signatures.

## Impact

- Tampered package execution.

## Remediation

- Pin integrity hashes; verify signatures; SBOM; vendor with hashes.

## Regression Test

- CI checks asserting hash-verified installs.

## Common False Positives

- Registries with built-in integrity (verify config).

## Related Skills

- `lockfile-analysis.md`
- `../supply-chain/package-provenance.md`
- `dependency-confusion.md`

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

- npm/pip/go integrity docs
- OWASP Supply Chain guidance
- CWE-494
