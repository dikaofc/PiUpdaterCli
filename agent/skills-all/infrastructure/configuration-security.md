# Skill: Configuration Security

## Purpose

Analyze configuration security: insecure defaults, dangerous flags, secret
handling in config, validation at load, and environment drift.

## Scope

- Included: defaults, flags, secret sourcing, validation, drift.
- Excluded: runtime behaviors (`../errors/debug-mode-analysis.md`).
- Layers: configuration.

## Trigger Conditions

- Config changes under review.
- Claims of "secure defaults" to verify.

## Inputs

- config files/templates
- code (config loading)

## Investigation Method

1. Identify entry points: config consumers.
2. Identify trust boundaries: N/A.
3. Track relevant data: config values → behavior.
4. Identify validation: load-time validation.
5. Identify security-sensitive operations: security-affecting flags.
6. Inspect authorization: N/A.
7. Inspect error handling: fail-fast on invalid config.
8. Inspect tests: config tests.
9. Determine exploitability or correctness impact: insecure defaults.
10. Validate the finding: inspect loading and values.

## Evidence Requirements

- E1: config + loading code.
- E2: insecure default/flag.

## Confidence

- CONFIRMED with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on the setting.

## Safe Reproduction

- Local config-load tests.

## Root Cause

- Permissive defaults; no validation; secrets in config.

## Impact

- Security controls disabled; exposure.

## Remediation

- Secure defaults; validate at load; secrets via secret manager; drift checks.

## Regression Test

- Config tests asserting hardened defaults and fail-fast.

## Common False Positives

- Configs for other environments (verify scope).

## Related Skills

- `environment-analysis.md`
- `../secrets/secret-management.md`
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

- OWASP Configuration guidance
- NIST SP 800-128
