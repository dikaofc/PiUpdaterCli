# Skill: CRLF Injection

## Purpose

Audit CR/LF injection into requests and responses (headers, logs, cache keys, emails) beyond pure header injection.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: crlf, carriage return, line feed, injection via newline.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find every sink consuming user input as line-structured data: response headers, Set-Cookie, logs, cache keys, email headers, HTTP client request construction.
2. Trace unvalidated newline-capable input (also %0d%0a, unicode newlines U+0085/U+2028) into those sinks.
3. Test locally per sink with raw byte inspection.
4. Check email-flow headers (To/Cc/Subject) for header injection enabling spam from the app identity.
5. Verify frameworks that strip CRLF (most) vs custom code that does not.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A raw-byte local test showing CR/LF from user input survives into a line-structured sink with the sink line cited.

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

Custom construction of line-structured data from unvalidated input.

## Impact

Header poisoning, log forgery, email header injection, cache-key anomalies.

## Remediation

Strip/deny CR, LF, and control characters at all boundaries; use framework header APIs; encode email headers.

## Regression Test

Tests feeding \r\n, %0d%0a, unicode newlines to every sink asserting neutralization.

## Common False Positives

Framework-level rejection of CRLF in header APIs; newlines that cannot reach the sink.

## Related Skills

- header-injection.md
- response-splitting.md
- log-injection.md
- request-smuggling.md

## References

- OWASP CRLF Injection
- CWE-93

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
