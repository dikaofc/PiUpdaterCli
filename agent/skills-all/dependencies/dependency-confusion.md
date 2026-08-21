# Skill: Dependency Confusion

## Purpose

Analyze dependency-confusion risk: internal package names resolvable from
public registries, enabling malicious package takeover in CI/builds.

## Scope

- Included: internal package naming vs public registry, scoping config,
  registry resolution order, package squatting.
- Excluded: general supply chain (`../supply-chain/supply-chain-risk.md`).
- Layers: dependency resolution.

## Trigger Conditions

- Internal packages with public-registry-matching names.
- Claims of "registry pinned" to verify.

## Inputs

- manifests/configs (registry config)
- package names

## Investigation Method

1. Identify entry points: install paths.
2. Identify trust boundaries: public registry.
3. Track relevant data: name resolution.
4. Identify validation: scope pinning.
5. Identify security-sensitive operations: install execution.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: takeover.
10. Validate the finding: verify resolution config and name availability.

## Evidence Requirements

- E1: manifest/registry config.
- E2: name resolves (or could resolve) to public registry.

## Confidence

- HIGH with E2; MEDIUM with E1.

## Severity

- HIGH when internal names are public-available and resolution not pinned.

## Safe Reproduction

- Local registry-config review; dry-run resolution checks.

## Root Cause

- Unscoped internal names; no registry pinning.

## Impact

- Malicious code execution in build/runtime.

## Remediation

- Scope internal packages; pin registries per scope; verify resolution.

## Regression Test

- CI checks asserting registry scoping.

## Common False Positives

- Internal names that cannot collide (unique prefixes) — verify.

## Related Skills

- `package-integrity.md`
- `../supply-chain/supply-chain-risk.md`
- `../cloud/ci-security.md`

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

- OWASP Dependency Confusion guidance
- npm/other registry scoping docs
- CWE-427
