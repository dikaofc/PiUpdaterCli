# Skill: Supply Chain Risk

## Purpose

Analyze end-to-end supply-chain risk: where artifacts come from, how they are
fetched, verified, and deployed — dependencies, build, registry, and CI
provenance.

## Scope

- Included: provenance, registry trust, build fetching, artifact
  verification, vendor integrity.
- Excluded: single-package advisories (`dependencies/*`).
- Layers: build + distribution.

## Trigger Conditions

- CI fetching from public sources.
- Claims of "verified supply chain" to verify.

## Inputs

- CI/CD configs
- registry configs
- manifests

## Investigation Method

1. Identify entry points: artifact acquisition paths.
2. Identify trust boundaries: external → build → deploy.
3. Track relevant data: artifact chain.
4. Identify validation: provenance/verification.
5. Identify security-sensitive operations: build execution.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: tamper path.
10. Validate the finding: trace the artifact chain.

## Evidence Requirements

- E1: acquisition configs.
- E2: verification gap.

## Confidence

- HIGH with E2; MEDIUM with E1.

## Severity

- HIGH for unverified external artifact execution; MEDIUM otherwise.

## Safe Reproduction

- Local pipeline review; dry-run resolution.

## Root Cause

- Unverified fetches; no provenance; permissive registries.

## Impact

- Malicious dependency injection at scale.

## Remediation

- Pinned verified artifacts; SBOM; provenance attestation; least-privilege CI.

## Regression Test

- CI assertions on artifact verification.

## Common False Positives

- Fully internal verified pipelines (verify).

## Related Skills

- `../dependencies/package-integrity.md`
- `../cloud/ci-security.md`
- `../cloud/artifact-security.md`
- `package-provenance.md`

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

- SLSA framework
- NIST SP 800-161 (Supply Chain)
