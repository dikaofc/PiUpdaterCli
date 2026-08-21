# Skill: Cloud Secret Analysis

## Purpose

Analyze cloud secret exposure: secrets in cloud resources (function envs,
container envs, config maps, storage), IAM-visible secrets, and secret manager
usage.

## Scope

- Included: env/config secrets in cloud resources, secret manager adoption,
  access control on secret stores.
- Excluded: local secret handling (`../secrets/*`).
- Layers: cloud.

## Trigger Conditions

- Cloud configs with env secrets.
- Claims of "secret manager" to verify.

## Inputs

- cloud configs/infra-as-code

## Investigation Method

1. Identify entry points: resource env/config.
2. Identify trust boundaries: resource access.
3. Track relevant data: secret values.
4. Identify validation: secret manager usage.
5. Identify security-sensitive operations: secret access.
6. Inspect authorization: secret store access.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: exposure.
10. Validate the finding: config review.

## Evidence Requirements

- E1: cloud configs.
- E2: exposed secret.

## Confidence

- CONFIRMED with E2.

## Severity

- HIGH for exposed secrets.

## Safe Reproduction

- Local config review; no real secret retrieval.

## Root Cause

- Env-var secrets in resource configs; no secret manager.

## Impact

- Credential theft via cloud access.

## Remediation

- Secret manager references; scoped access; rotation.

## Regression Test

- Config assertions on secret sourcing.

## Common False Positives

- Placeholder values (verify).

## Related Skills

- `../secrets/secret-management.md`
- `cloud-iam-analysis.md`
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

- Cloud provider secrets docs
- CWE-522
