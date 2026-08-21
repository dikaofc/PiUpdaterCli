# Skill: Service Configuration

## Purpose

Analyze service configuration hardening: debug/admin endpoints, banner
disclosure, default accounts, and per-service security settings.

## Scope

- Included: admin/debug endpoints, default credentials, banners, service
  hardening flags.
- Excluded: app code issues.
- Layers: service deployment.

## Trigger Conditions

- Service deployments with default configs.
- Claims of "hardened services" to verify.

## Inputs

- service configs
- tests

## Investigation Method

1. Identify entry points: service endpoints.
2. Identify trust boundaries: N/A.
3. Track relevant data: N/A.
4. Identify validation: hardening flags.
5. Identify security-sensitive operations: admin functions.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: config tests.
9. Determine exploitability or correctness impact: exposure.
10. Validate the finding: config review.

## Evidence Requirements

- E1: service config.
- E2: hardening gap.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM typically; HIGH for default admin creds.

## Safe Reproduction

- Local config review.

## Root Cause

- Default configs; unhardened services.

## Impact

- Admin exposure, reconnaissance.

## Remediation

- Disable debug/admin; change defaults; hardening baselines.

## Regression Test

- Config assertions on hardening flags.

## Common False Positives

- Features required by design (document).

## Related Skills

- `configuration-security.md`
- `port-exposure.md`
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

- Vendor hardening guides
- CWE-1188
