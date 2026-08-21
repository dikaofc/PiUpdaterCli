# Skill: XML Security

## Purpose

Audit XML processing for XXE (external entity), billion laughs, schema injection, and XInclude/Schema fetching pitfalls.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: xml, xxe, external entity, billion laughs, xinclude.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find XML parsing points: DOM/SAX/StAX/XMLReader, document builders, SOAP handling, SSO assertion (SAML) parsing.
2. Check parser configuration: external entity resolution, DTD loading, entity expansion disabled?
3. Check XXE sinks: file:// reads, http(s) fetches, data exfiltration in responses, error-based XXE.
4. Test locally with a local XML fixture referencing a harmless local file/URL to observe resolution behavior.
5. Check billion-laughs protection and XInclude/Schema external references.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local parse test showing external entities/DTD are resolved (or resource usage explodes), with the parser instantiation cited.

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

Test file handling with fixtures in a temp sandbox directory (paths, archives, uploads) and a local mock upload endpoint.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Default XML parsers with external entity/DTD processing enabled.

## Impact

Local file disclosure, SSRF via entity URLs, DoS (entity expansion), SAML/XXE auth bypass in identity flows.

## Remediation

Disable DTD/external entities (secure defaults: javax.xml features off, lxml resolve_entities=False), process XML with strict limits.

## Regression Test

Tests parsing XXE fixtures and billion-laughs documents asserting no external resolution and bounded resources.

## Common False Positives

Parsers configured secure (Python defusedxml-equivalents); XML inputs from trusted internal sources only.

## Related Skills

- parser-security.md
- xxe.md
- serialization-security.md
- deserialization-analysis.md

## References

- OWASP XXE Prevention Cheat Sheet
- CWE-611

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
