# Skill: Port Exposure

## Purpose

Analyze exposed ports: which ports are open to which networks, and whether
unnecessary or sensitive ports (DB, admin, debug) are reachable.

## Scope

- Included: port inventory, bind addresses, firewall rules, public exposure.
- Excluded: broader network topology (`network-exposure.md`).
- Layers: network.

## Trigger Conditions

- Deployment changes; new services.
- Claims of "closed ports" to verify.

## Inputs

- infra configs
- server configs

## Investigation Method

1. Identify entry points: open ports.
2. Identify trust boundaries: bind vs public.
3. Track relevant data: N/A.
4. Identify validation: exposure rules.
5. Identify security-sensitive operations: sensitive ports.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: exposure.
10. Validate the finding: config review + local port checks.

## Evidence Requirements

- E1: port/bind configs.
- E2: exposed sensitive port.

## Confidence

- CONFIRMED with E2.

## Severity

- HIGH for exposed DB/admin/debug; LOW otherwise.

## Safe Reproduction

- Config review; port checks on auditor-controlled instances only.

## Root Cause

- Default binds (0.0.0.0); permissive firewalls.

## Impact

- Direct access to sensitive services.

## Remediation

- Bind internal interfaces; firewall least-access; disable unused services.

## Regression Test

- Config assertions on port bindings.

## Common False Positives

- Ports firewalled upstream (verify rules).

## Related Skills

- `network-exposure.md`
- `service-configuration.md`
- `../cloud/cloud-storage-security.md`

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

- Cloud/OS firewall docs
- CWE-200
