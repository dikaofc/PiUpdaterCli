# Skill: Template Injection

## Purpose

Find server-side template injection (SSTI): user input evaluated inside template expressions of Jinja, Twig, FreeMarker, Velocity, ERB, Handlebars (server), Thymeleaf.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: template injection, SSTI, jinja, twig.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find template rendering sinks that include dynamic strings: render_template_string, Twig createTemplate, FreeMarker string templates, Spring view names from input.
2. Trace user input into template expressions or template names.
3. Determine the template engine and its sandbox posture.
4. Test locally with a benign expression (e.g., a simple arithmetic output) proving evaluation of injected syntax.
5. Check whether user input also controls template file selection (path -> template injection by file).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local behavioral test showing a benign template expression is evaluated from user input, with the render call cited. Never probe live systems with SSTI payloads.

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

Template content or expressions composed from unvalidated input, or template files picked by untrusted path.

## Impact

Remote code execution (many engines expose object manipulation), application takeover.

## Remediation

Never interpolate user input into templates as code; pass data as context values only; sandbox engines that must evaluate user templates.

## Regression Test

Tests placing {{ }} / ${ } snippets in inputs, asserting they render as literal text.

## Common False Positives

Client-side template engines (Vue/Handlebars in browser) reported as SSTI; engines that auto-escape expressions; input escaped before interpolation.

## Related Skills

- code-injection.md
- expression-injection.md
- xss-analysis.md
- unsafe-rendering.md

## References

- PortSwigger SSTI research
- OWASP SSTI
- CWE-1336 (improper neutralization of special elements used in a template engine)

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
