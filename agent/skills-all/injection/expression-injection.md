# Skill: Expression Injection

## Purpose

Find injection into expression evaluators: SPEL, OGNL, MVEL, jq, math expressions, regex evaluation, condition parsers, rule engines.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: expression injection, spel, ognl, mvel, rule engine.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find expression evaluation sinks: SpEL/OGNL evaluation from strings, math evaluators, jq filters, regex constructed from templates, business-rule engines (Drools, Easy Rules) with dynamic input.
2. Trace user input into expression strings or rule definitions.
3. Check engine capability: can the expression access classes, files, or invoke methods?
4. Test locally with a benign arithmetic expression proving evaluation of user syntax.
5. Check versions: older SpEL/OGNL versions allow property/method escalation.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local behavioral test proving user-controlled expression inputs are evaluated, with the eval call cited and engine version noted.

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

Dynamic expression parsing of untrusted strings without a capability/sandbox model.

## Impact

Remote code execution, property access, data exfiltration through reflection.

## Remediation

Avoid evaluating user expressions; parse with strict grammars; run rule engines in sandboxes; upgrade engines and limit method access.

## Regression Test

Tests feeding expression metacharacters as data, asserting literal evaluation.

## Common False Positives

Expressions built only from server-side constants; engines configured with security managers blocking escape.

## Related Skills

- code-injection.md
- template-injection.md
- java-injection-pitfalls.md

## References

- CVE-2022-22963/22965 (SpEL via Spring)
- CWE-917 (improper neutralization in expression language)

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
