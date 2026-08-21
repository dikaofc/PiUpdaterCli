# Skill: API Input Boundaries

## Purpose

Audit where API input stops being "API data" and becomes internal data: proxy/server-side layers, gateway validation, and boundary semantics.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: api input boundaries, gateway, proxy, layer bypass.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map the layers input passes through: gateway → app server → service → DB/client libs.
2. Check which validations exist at each layer and whether an attacker can reach deeper layers directly (bypassing the gateway).
3. Check content-type/encoding normalization across layers (JSON vs form vs raw bodies).
4. Check request smuggling-style boundary crossing between layers (ties to request-smuggling).
5. Verify boundary errors (413, 422) are handled without bypassing auth.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A layer diagram with per-layer validation, plus one direct-call path that reaches deeper layers bypassing validations.

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

Defense layered only at one boundary (e.g., gateway) while services accept unvalidated direct calls.

## Impact

Validation bypass, privilege escalation via internal-only APIs exposed, smuggling.

## Remediation

Validate at every trust boundary, authenticate service-to-service calls, restrict network paths to services.

## Regression Test

Tests calling each layer directly asserting equivalent validation/auth.

## Common False Positives

Deep layers reachable only through internal networks with mTLS; gateway validation duplicated at the app.

## Related Skills

- api-surface-analysis.md
- request-smuggling.md
- middleware-analysis.md
- service-layer-analysis.md

## References

- OWASP API Security Top 10
- CWE-1007

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
