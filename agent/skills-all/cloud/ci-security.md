# Skill: CI Security

## Purpose

Analyze CI pipeline security: secrets handling, script injection, privilege
scope, artifact tampering, and supply-chain risk in CI.

## Scope

- Included: secret injection, PR-triggered jobs, third-party actions,
  checkout code execution, permissions.
- Excluded: deployment (`deployment-security.md`).
- Layers: CI.

## Trigger Conditions

- CI config changes.
- Claims of "secure CI" to verify.

## Inputs

- CI configs (GitHub Actions, GitLab, Jenkins...)
- runner configs

## Investigation Method

1. Identify entry points: job triggers.
2. Identify trust boundaries: PR code → CI.
3. Track relevant data: secrets/artifacts.
4. Identify validation: secret scoping.
5. Identify security-sensitive operations: privileged jobs.
6. Inspect authorization: permission scope.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: compromise.
10. Validate the finding: config review.

## Evidence Requirements

- E1: CI configs.
- E2: injection/secret/permission gap.

## Confidence

- CONFIRMED with E2.

## Severity

- HIGH for PR-triggered secret-exposing jobs.

## Safe Reproduction

- Local config review.

## Root Cause

- Broad permissions; secrets in PR jobs; untrusted third-party actions.

## Impact

- Secret theft, supply-chain compromise via CI.

## Remediation

- Least-privilege tokens; no secrets on PR triggers; pin actions;
  environment-gated approvals.

## Regression Test

- CI config assertions.

## Common False Positives

- Jobs properly gated (verify).

## Related Skills

- `github-actions-security.md`
- `pipeline-permission-analysis.md`
- `../supply-chain/supply-chain-risk.md`

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

- GitHub Actions / CI security docs
- CWE-829 / CWE-94
