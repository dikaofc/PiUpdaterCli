# Skill: Package Provenance

## Purpose

Analyze package provenance: origin, publisher, attestation, and
reproducibility of packages and artifacts.

## Scope

- Included: provenance metadata, publisher verification, attestations,
  reproducibility.
- Excluded: integrity hashes (`../dependencies/package-integrity.md`).
- Layers: supply chain.

## Trigger Conditions

- Third-party artifacts without provenance.
- Claims of "trusted sources" to verify.

## Inputs

- registry metadata
- SBOM/attestation files
- CI configs

## Investigation Method

1. Identify entry points: artifact sources.
2. Identify trust boundaries: publisher trust.
3. Track relevant data: provenance chain.
4. Identify validation: attestation verification.
5. Identify security-sensitive operations: artifact use.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: spoofing.
10. Validate the finding: verify provenance claims.

## Evidence Requirements

- E1: provenance/attestation evidence.
- E2: gap in verification.

## Confidence

- HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on trust level required.

## Safe Reproduction

- Local verification of attestations (cosign-style dry runs).

## Root Cause

- No provenance; unverified publishers.

## Impact

- Impersonated packages, malicious artifacts.

## Remediation

- Verify provenance/attestations; pin publishers; SBOM in CI.

## Regression Test

- CI provenance verification gates.

## Common False Positives

- Internal artifacts with verified provenance (verify).

## Related Skills

- `supply-chain-risk.md`
- `../dependencies/package-integrity.md`
- `../cloud/artifact-security.md`

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

- SLSA / Sigstore docs
- NIST SP 800-161
