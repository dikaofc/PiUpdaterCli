# Skill: Environment Analysis

## Purpose

Analyze environment separation: dev/staging/prod isolation, configuration
drift, and environment-specific security weaknesses.

## Scope

- Included: environment configs, drift, prod-only controls, shared resources.
- Excluded: general config (`configuration-security.md`).
- Layers: deployment.

## Trigger Conditions

- Multi-environment deployments.
- Claims of "prod hardened" to verify.

## Inputs

- env configs
- deployment manifests

## Investigation Method

1. Identify entry points: environment definitions.
2. Identify trust boundaries: env separation.
3. Track relevant data: config drift.
4. Identify validation: prod-specific hardening.
5. Identify security-sensitive operations: prod resources.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: drift.
10. Validate the finding: compare environment configs.

## Evidence Requirements

- E1: environment configs.
- E2: drift/weakness.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM (drift weakening prod).

## Safe Reproduction

- Local config comparison.

## Root Cause

- Copy-paste configs; missing environment gates.

## Impact

- Prod runs weakened controls.

## Remediation

- Environment-specific configs; drift detection; gates on prod.

## Regression Test

- Config assertions per environment.

## Common False Positives

- Intended differences (verify).

## Related Skills

- `configuration-security.md`
- `../errors/debug-mode-analysis.md`
- `../secrets/environment-secret-analysis.md`

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

- 12-factor app / env config guidance
- NIST SP 800-128
