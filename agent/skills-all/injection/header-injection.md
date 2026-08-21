# Skill: Header Injection

## Purpose

Find HTTP header injection: user input that can introduce CRLF or control characters into response headers, enabling response splitting and header poisoning.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: header injection, crlf, response splitting.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find response-header setters that receive user input: setHeader/addHeader, HttpResponse.Headers, Set-Cookie values, Location/redirect targets, Content-Disposition filenames.
2. Trace user input into header values (query, body, filenames, URLs).
3. Check whether CR/LF (and %0d%0a) are stripped/rejected before setting the header.
4. Test locally with a raw HTTP client observing the exact bytes returned for a payload containing \r\n.
5. Check indirect paths: redirect URLs, cache-related headers, custom headers echoed from requests.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local raw-HTTP test showing CRLF bytes from user input survive into a response header, with the header-setting line cited.

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

Missing CR/LF sanitization on header values (frameworks usually block it, custom code often does not).

## Impact

Response splitting, cache poisoning, XSS via injected headers (with proxies), session manipulation.

## Remediation

Reject/strip CR, LF, and header-name separators in all header inputs; validate redirect targets against allowlists.

## Regression Test

Tests sending \r\n-padded values to every header-setting point, asserting rejection/encoding.

## Common False Positives

Frameworks (Express, ASP.NET, Servlet API, Go net/http) that already reject CRLF in header values.

## Related Skills

- crlf-injection.md
- response-splitting.md
- open-redirect.md
- http-smuggling.md

## References

- OWASP HTTP Response Splitting
- CWE-113 (improper neutralization of CRLF sequences in HTTP headers)

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
