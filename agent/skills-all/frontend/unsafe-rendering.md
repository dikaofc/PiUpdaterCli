# Skill: Unsafe Rendering

## Purpose

Analyze unsafe rendering: bypassing framework autoescaping (dangerouslySetInnerHTML,
v-html, innerHTML, raw, html_safe), unsafe rich-content rendering, and
template misuse.

## Scope

- Included: escaping bypasses, rich-text rendering, markup from storage.
- Excluded: DOM sink enumeration (`dom-sink-analysis.md`).
- Layers: frontend rendering.

## Trigger Conditions

- Autoescape-bypass APIs with variable data.
- Rich-text editors rendered raw.

## Inputs

- frontend code

## Investigation Method

1. Identify entry points: render calls.
2. Identify trust boundaries: data → DOM.
3. Track relevant data: rendered values.
4. Identify validation: sanitization/escaping.
5. Identify security-sensitive operations: DOM insertion.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: render tests.
9. Determine exploitability or correctness impact: XSS.
10. Validate the finding: local render tests.

## Evidence Requirements

- E1: render code.
- E2: untrusted data path.
- E3: test demonstrating unescaped rendering.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local render tests with payloads (headless).

## Root Cause

- Bypassing autoescape; raw rich-text rendering.

## Impact

- Stored/reflected XSS.

## Remediation

- Framework escaping; sanitize rich content with allow-listed libraries;
  CSP.

## Regression Test

- Render tests asserting escaping.

## Common False Positives

- Rendered data validated to safe sets.

## Related Skills

- `../web/stored-xss.md`
- `../web/xss-analysis.md`
- `dom-sink-analysis.md`

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected
- [ ] Severity assigned
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed

## References

- OWASP XSS Prevention Cheat Sheet
- CWE-79
