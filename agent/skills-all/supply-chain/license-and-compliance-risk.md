# Skill: License and Compliance Risk

## Purpose

Analyze license/compliance risk in the dependency set: incompatible licenses,
missing attribution, and export/legal constraints — non-security but
release-blocking risk.

## Scope

- Included: license inventory, compatibility, copyleft implications,
  attribution.
- Excluded: security advisories (`dependencies/*`).
- Layers: dependency compliance.

## Trigger Conditions

- Release readiness with third-party code.
- Claims of "license-clean" to verify.

## Inputs

- manifests/lockfiles
- license metadata

## Investigation Method

1. Identify entry points: dependency set.
2. Identify trust boundaries: N/A.
3. Track relevant data: license metadata.
4. Identify validation: policy compliance.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: legal risk.
10. Validate the finding: license inventory review.

## Evidence Requirements

- E1: license metadata.
- E2: policy conflict.

## Confidence

- HIGH with E2; MEDIUM with E1.

## Severity

- INFORMATIONAL–MEDIUM (release blocking, not security).

## Safe Reproduction

- Local license scanning.

## Root Cause

- No license policy/scanning.

## Impact

- Legal/compliance issues at release.

## Remediation

- License policy; automated scanning; attribution.

## Regression Test

- CI license checks.

## Common False Positives

- Compatible licenses (verify against policy).

## Related Skills

- `../dependencies/dependency-audit.md`
- `../workflows/release-readiness.md`

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

- SPDX license list
- OWASP Dependency-Check license analysis
