# Skill: Network Exposure

## Purpose

Analyze network exposure: which services are reachable from where, open ports,
admin interfaces, and network segmentation.

## Scope

- Included: listener config, firewall/security groups, service reachability,
  exposure of admin/DB/cache ports.
- Excluded: app-level issues (other skills).
- Layers: network/infra.

## Trigger Conditions

- Deployment/network changes.
- Claims of "not exposed" to verify.

## Inputs

- infra configs (firewall, LB, k8s, cloud)
- server configs

## Investigation Method

1. Identify entry points: listeners/ports.
2. Identify trust boundaries: network segments.
3. Track relevant data: N/A.
4. Identify validation: exposure rules.
5. Identify security-sensitive operations: sensitive services.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: exposure.
10. Validate the finding: review configs; local network tests.

## Evidence Requirements

- E1: network configs.
- E2: exposure gap.

## Confidence

- CONFIRMED with E2; MEDIUM with E1.

## Severity

- HIGH for exposed sensitive services; MEDIUM otherwise.

## Safe Reproduction

- Local/cloud config review; port checks against auditor-controlled instances.

## Root Cause

- Default-open policies; missing segmentation.

## Impact

- Direct attack surface on sensitive services.

## Remediation

- Least-exposure policies; segmentation; VPN/bastions for admin.

## Regression Test

- Config assertions on exposure rules.

## Common False Positives

- Listeners bound to internal interfaces only (verify).

## Related Skills

- `port-exposure.md`
- `reverse-proxy-analysis.md`
- `../cloud/cloud-iam-analysis.md`

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

- Cloud provider network docs
- OWASP Infrastructure guidance
- CWE-200
