# Skill: MIME Confusion

## Purpose

Find MIME confusion: responses served with wrong/missing Content-Type and X-Content-Type-Options allowing content-sniffing and stored XSS.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: mime confusion, content sniffing, content-type.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find dynamic responses serving user content: uploads, rendered files, export endpoints — check the Content-Type emitted.
2. Check X-Content-Type-Options: nosniff on all responses.
3. Identify cases where HTML/JS content is served as text/plain or application/octet-stream (browsers may sniff).
4. Test locally: fetch each endpoint and inspect Content-Type + sniff behavior with a crafted file beginning with HTML.
5. Check upload rendering on same-origin (stored-XSS amplification).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local response where user-controlled content is served with a dangerous or absent Content-Type and no nosniff, with the handler cited.

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

Use a local test app with deliberately vulnerable routes, or browser automation against a sandbox instance you control.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Missing/incorrect Content-Type on user-content responses and missing nosniff header.

## Impact

Stored XSS for upload flows, content spoofing, drive-by download risks.

## Remediation

Set exact Content-Types, add X-Content-Type-Options: nosniff, serve uploads from a separate sandboxed origin with CSP.

## Regression Test

Header-level tests asserting nosniff and correct Content-Type on every user-content endpoint.

## Common False Positives

Modern browsers with nosniff; APIs returning JSON with correct type.

## Related Skills

- file-upload-security.md
- security-headers.md
- stored-xss.md

## References

- OWASP Content-Type sniffing
- CWE-16

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
