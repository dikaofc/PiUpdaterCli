# Skill: XPath Injection

## Purpose

Find XPath/XQuery injection: user input built into XPath expressions or XQuery, allowing predicate bypass or data extraction.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: xpath injection, xquery, xml query.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find XPath/XQuery evaluation: XPathEvaluator, libxml xpath, Saxon, XQuery engines, XML databases with string-built queries.
2. Trace user input into expression strings.
3. Test locally with a benign probe (element existence / count queries) on an XML fixture.
4. Check whether results are used in security decisions (login predicates over XML documents).
5. Verify error messages leak document structure.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test where a crafted predicate changes the result set of an XPath query fed by user input.

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

Use local databases (SQLite/Postgres test instance), local shell wrappers, or mock sinks. Verify behavior changes with benign probes; never against live third-party systems.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

String-concatenated XPath queries instead of parameterized/variable-bound queries.

## Impact

Data extraction from XML stores, authentication bypass.

## Remediation

Use query variables/parameters instead of string concatenation; avoid XPath where a structured API suffices; treat XML as untrusted data.

## Regression Test

Tests injecting expression fragments into each XPath-bound field, asserting variable binding.

## Common False Positives

Engines with parameter binding in use; input that never reaches the expression (validated patterns first).

## Related Skills

- xml-security.md
- sql-injection.md
- authentication-flow-analysis.md

## References

- OWASP XPATH Injection
- CWE-643 (improper neutralization of data within XPath expressions)

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
