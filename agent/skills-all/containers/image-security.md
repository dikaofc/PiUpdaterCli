# Skill: Image Security

## Purpose

Analyze container image security: base image vulnerabilities, secrets in
layers, signed images, and minimality.

## Scope

- Included: image scanning, layer secrets, image signing, base pinning,
  minimal images.
- Excluded: runtime config (`docker-security.md`).
- Layers: images.

## Trigger Conditions

- Image builds/releases.
- Claims of "clean images" to verify.

## Inputs

- Dockerfiles
- image registries
- scan reports

## Investigation Method

1. Identify entry points: image sources.
2. Identify trust boundaries: registry → runtime.
3. Track relevant data: image layers.
4. Identify validation: scanning/signing.
5. Identify security-sensitive operations: image execution.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: vuln execution.
10. Validate the finding: image review/scan.

## Evidence Requirements

- E1: Dockerfile/image evidence.
- E2: vulnerability/secret presence.

## Confidence

- HIGH with scan evidence; MEDIUM with E1.

## Severity

- Per reachability of image vulnerabilities.

## Safe Reproduction

- Local image scans (trivy-style) and layer inspection.

## Root Cause

- Unpinned bases; unverified images.

## Impact

- Known-vulnerability execution, malicious layers.

## Remediation

- Pin minimal bases; scan in CI; sign images; no secrets in layers.

## Regression Test

- CI image scan gates.

## Common False Positives

- Scanned images with accepted deviations (document).

## Related Skills

- `docker-security.md`
- `../dependencies/native-dependency-analysis.md`
- `../supply-chain/package-provenance.md`

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

- Docker/registry security docs
- Trivy/Grype docs
