# Skill: API Error Handling

## Purpose

Audit API error responses for information disclosure (stack traces, internal paths, SQL details) and inconsistent security behavior on errors.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: api error, error disclosure, stack trace.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Trigger error paths on each endpoint (invalid input, missing resources, auth failures, server exceptions) and inspect response bodies.
2. Check for stack traces, SQL/query details, internal paths, dependency versions, debug flags in responses.
3. Check error consistency: does an auth error leak whether the user exists (enumeration)?
4. Check error-based detection: are errors distinguishable in ways that enable oracles (padding, injection, guessing)?
5. Verify error responses in production use generic messages with details logged server-side.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Response bodies from local error-path tests revealing internal details or inconsistent security semantics.

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

Debug-enabled error handlers in production, or error messages built from internal exception text.

## Impact

Information disclosure aiding further attacks (SQLi confirmation, path discovery, account enumeration).

## Remediation

Generic external errors with IDs, structured server-side logging of details, debug mode disabled in prod.

## Regression Test

Tests asserting error responses contain no internal details and are consistent across error classes.

## Common False Positives

Dev-only environments; error texts that reveal nothing security-relevant.

## Related Skills

- sensitive-error-data.md
- stack-trace-exposure.md
- error-boundary-analysis.md
- api-data-exposure.md

## References

- OWASP API Security Top 10 (API10)
- CWE-209 (information exposure through error message)

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
