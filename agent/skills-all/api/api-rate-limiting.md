# Skill: API Rate Limiting

## Purpose

Audit rate limiting: presence, correctness, bypass (rotating keys/IP spoofing), and resource-impacting endpoints without limits.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: rate limit, throttling, brute force, quota.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Identify sensitive endpoints needing limits: login, OTP, password reset, uploads, search, payments, webhooks.
2. Check the rate-limit implementation: in-memory vs distributed, keyed by what (user/IP/token), window correctness (fixed/sliding).
3. Test locally: burst N requests and observe enforcement (and whether the limit is bypassable by rotating keys, spoofing X-Forwarded-For, or case variants).
4. Check limits for resource-heavy endpoints (search, exports, report generation, webhook retries).
5. Verify rate-limit headers/errors are consistent and enforcement happens before processing.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local burst test showing enforcement (or its absence/bypass) on each sensitive endpoint, with the limiter config cited.

Minimum bar: **static evidence (E1)** to open a line of inquiry; **behavioral evidence (E3)** or better for a confirmed report. See `context/evidence-model.md`.

## Confidence

Use one of:

- **CONFIRMED** — behavior reproduced and root cause validated (E3+).
- **HIGH CONFIDENCE** — strong static + data-flow evidence, controlled verification pending.
- **MEDIUM CONFIDENCE** — plausible path but some assumptions remain unverified.
- **LOW CONFIDENCE** — theoretical risk; requires validation.
- **FALSE POSITIVE** — disproven or mitigated after analysis.

Confidence is independent of severity (see `context/confidence-model.md`).

## Severity

Assess severity from actual **impact + exploitability + required privileges + interaction + affected scope + data sensitivity** (see `context/severity-model.md`). Do not automatically label this class CRITICAL. A finding must earn its severity from evidence.

Typical range for this skill: LOW–HIGH depending on reachability and data sensitivity.

## Safe Reproduction

Use a local API with seeded mock data and a scratch test user/tenant; assert with integration tests, not against production.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Rate limiting missing on sensitive endpoints, keyed by spoofable attributes, or enforced after expensive work.

## Impact

Credential stuffing, OTP bombing, resource exhaustion, cost abuse.

## Remediation

Distributed limits keyed by server-verified identity + IP, applied before processing, with exponential backoff and monitoring.

## Regression Test

Automated burst tests asserting rejection at the configured threshold and no bypass via common spoofing.

## Common False Positives

Limits enforced by a gateway/API management layer not visible in the app code; deliberately rate-limited public APIs with documented tiers.

## Related Skills

- credential-stuffing-defense.md
- bruteforce-defense.md
- quota-bypass-analysis.md
- resource-limit-analysis.md

## References

- OWASP API Security Top 10 (API4)
- CWE-770

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected (E1–E5 level recorded)
- [ ] Severity assigned (impact-based)
- [ ] Confidence assigned (separate from severity)
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed
