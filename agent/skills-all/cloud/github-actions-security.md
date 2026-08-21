# Skill: GitHub Actions Security

## Purpose

Analyze GitHub Actions security: untrusted input in workflows, script
injection, action pinning, permissions, and secret exposure.

## Scope

- Included: `pull_request_target` risks, expression injection, action
  references (pins/commits), GITHUB_TOKEN permissions, secrets in jobs.
- Excluded: general CI (`ci-security.md`).
- Layers: GitHub CI.

## Trigger Conditions

- Workflow changes.
- Claims of "secure workflows" to verify.

## Inputs

- .github/workflows/*
- action references

## Investigation Method

1. Identify entry points: job triggers.
2. Identify trust boundaries: PR context.
3. Track relevant data: context/inputs.
4. Identify validation: input sanitization in run steps.
5. Identify security-sensitive operations: token/secrets use.
6. Inspect authorization: token permissions.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: injection.
10. Validate the finding: workflow review.

## Evidence Requirements

- E1: workflow configs.
- E2: injection/permission gap.

## Confidence

- CONFIRMED with E2.

## Severity

- HIGH for pull_request_target secret exposure.

## Safe Reproduction

- Local workflow review.

## Root Cause

- Untrusted context in scripts; unpinned actions; broad tokens.

## Impact

- Repo/secret compromise.

## Remediation

- Pin actions to SHAs; least-privilege tokens; sanitize context input;
  avoid pull_request_target with secrets.

## Regression Test

- Workflow config assertions.

## Common False Positives

- Workflows with safe context handling (verify).

## Related Skills

- `ci-security.md`
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

- GitHub Actions security hardening guide
- CWE-94 / CWE-829
