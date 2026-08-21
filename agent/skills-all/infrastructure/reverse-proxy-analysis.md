# Skill: Reverse Proxy Analysis

## Purpose

Analyze reverse proxy configuration: routing rules, header handling, path
normalization, and control preservation (auth, rate limits) at the edge.

## Scope

- Included: route rules, header stripping, path normalization, smuggling
  surface, edge auth.
- Excluded: app-layer issues.
- Layers: edge/proxy.

## Trigger Conditions

- Proxy config changes.
- Claims of "edge-protected" to verify.

## Inputs

- proxy configs (nginx, LB, gateway)
- tests

## Investigation Method

1. Identify entry points: proxy routes.
2. Identify trust boundaries: edge → backend.
3. Track relevant data: request transformations.
4. Identify validation: normalization/rules.
5. Identify security-sensitive operations: backend exposure.
6. Inspect authorization: edge controls.
7. Inspect error handling: N/A.
8. Inspect tests: rule tests.
9. Determine exploitability or correctness impact: bypass.
10. Validate the finding: local proxy tests with crafted requests.

## Evidence Requirements

- E1: proxy config.
- E2: rule gap.
- E3: test demonstrating bypass (local proxy).

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local proxy fixture with crafted requests; never against production.

## Root Cause

- Broad route rules; unnormalized paths; stripped security headers.

## Impact

- Edge-control bypass, smuggling, exposure.

## Remediation

- Tight rules; path normalization; preserve auth headers; reject ambiguous
  requests.

## Regression Test

- Proxy-rule tests asserting expected routing/auth.

## Common False Positives

- Rules verified working (document).

## Related Skills

- `../web/request-smuggling.md`
- `network-exposure.md`
- `port-exposure.md`

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

- nginx/LB security guides
- CWE-444
