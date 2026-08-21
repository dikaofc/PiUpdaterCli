# Skill: Client-Side Templating

## Purpose

Audit client-side template engines and interpolation for XSS via unsafe rendering modes.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: templating, dangerouslysetinnerhtml, v-html, interpolation.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find template usage: React JSX/interpolation, Vue mustaches/v-html, Angular interpolation/bypassSecurityTrust*, Handlebars {{{ }}}.
2. Check escape defaults: are interpolations escaped, and are opt-out APIs used?
3. Check auto-escape bypasses: v-html, dangerouslySetInnerHTML, SafePipe, Handlebars triple-stache.
4. Check server-rendered HTML embedded into templates (hydration mismatches).
5. Test locally: payloads through interpolation vs opt-out APIs.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Template code cited with opt-out-use findings and a local rendering test of a payload.

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

Inspect bundles locally; run browser automation against a local build. Never exfiltrate data.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Framework escape defaults bypassed via opt-out APIs fed with user data.

## Impact

Reflected/stored XSS in the client render path.

## Remediation

Default escaping everywhere, no user data in opt-out APIs without sanitization, prefer framework-sanctioned safe patterns.

## Regression Test

Rendering tests asserting payloads stay inert in interpolations.

## Common False Positives

Opt-out APIs used with server-escaped/static content only.

## Related Skills

- dom-based-xss.md
- xss-analysis.md
- mvc-security.md

## References

- React/Vue/Angular XSS docs
- CWE-79

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
