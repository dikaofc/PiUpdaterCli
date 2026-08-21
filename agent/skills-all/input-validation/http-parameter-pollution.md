# Skill: HTTP Parameter Pollution

## Purpose

Find cases where duplicate or conflicting parameters are interpreted differently by different layers, causing validation bypass or logic confusion.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: HPP, duplicate parameters, parameter confusion.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Identify parameter-parsing layers: proxy/gateway, framework, WAF rules, backend parsers, and how each handles duplicate keys (last-wins, first-wins, array).
2. Check validation vs use: does validation read one occurrence and the business logic another?
3. Test duplicates: ?id=1&id=2, arrays in form vs JSON, semicolon separators, unicode/encoded duplicates, case-variant keys.
4. Look for WAF bypass patterns where the WAF sees a safe value and the app sees the hostile one.
5. Verify server-side decision reconciles all occurrences.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A request where two layers disagree on the effective value, producing a security-relevant difference, with both parse behaviors cited.

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

Build local fixtures with a test HTTP server or CLI harness that feeds controlled payloads (valid, boundary, malformed) and assert behavior in unit tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Layers parsing parameters differently with no canonical reconciliation at the app boundary.

## Impact

Auth bypass, rule bypass (WAF), validation bypass, business-logic corruption (e.g., two amounts).

## Remediation

Reject duplicate parameters or define one canonical parsing behavior; normalize before validation.

## Regression Test

Tests with duplicate/conflicting parameters asserting a single canonical value reaches business logic.

## Common False Positives

Middlewares that already reject duplicates; parameters unused by logic despite differing parses.

## Related Skills

- type-confusion.md
- parameter-tampering.md
- canonicalization.md
- server-side-authorization.md

## References

- OWASP HPP Testing Guide
- CWE-472
- PortSwigger "HTTP Parameter Pollution" research

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
