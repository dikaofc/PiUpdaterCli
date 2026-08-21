# Skill: Artifact Security

## Purpose

Analyze artifact security: artifact integrity, provenance, storage
permissions, and distribution of build outputs.

## Scope

- Included: artifact signing, integrity, registry permissions, retention.
- Excluded: source supply chain (`../supply-chain/*`).
- Layers: build outputs.

## Trigger Conditions

- Release pipelines.
- Claims of "signed artifacts" to verify.

## Inputs

- release configs
- registry/storage configs

## Investigation Method

1. Identify entry points: artifact creation/storage.
2. Identify trust boundaries: build → consumers.
3. Track relevant data: artifact chain.
4. Identify validation: signing/integrity.
5. Identify security-sensitive operations: distribution.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: tampering.
10. Validate the finding: config review.

## Evidence Requirements

- E1: artifact configs.
- E2: integrity/signing gap.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM–HIGH for unsigned distributed artifacts.

## Safe Reproduction

- Local artifact verification dry-runs.

## Root Cause

- Unsigned artifacts; open registries.

## Impact

- Tampered artifact distribution.

## Remediation

- Sign artifacts; verify on install; private registries; retention policy.

## Regression Test

- CI signing/verification gates.

## Common False Positives

- Internally verified artifacts (verify).

## Related Skills

- `../supply-chain/package-provenance.md`
- `deployment-security.md`
- `../dependencies/package-integrity.md`

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
- CWE-494
