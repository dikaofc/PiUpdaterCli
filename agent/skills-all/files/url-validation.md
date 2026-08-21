# Skill: URL Validation

## Purpose

Audit URL validation logic: schemes, hosts, ports, and canonicalization flaws that allow malicious URLs past filters into fetch, redirect, or link sinks.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: url validation, url parsing, scheme allowlist.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find URL parsers/validators used at boundaries (URL, urlparse, new URL, URI, regex-based).
2. Check scheme handling: allow only http(s)? What about file, ftp, gopher, dict, javascript:?
3. Check host validation: TLD suffix checks (attacker.com.trusted.com), IP literals, decimal/octal/hex IPs (2130706433, 0x7f000001), IPv6, encodings, backslashes.
4. Test locally a battery of encoded/alternative-form URLs through the exact validator.
5. Verify validators run on the final resolved value (post-redirect, post-DNS).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing a forbidden-form URL passes the validator (or a legit form is mishandled) with the parsing code cited.

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

Regex/heuristic URL parsing instead of standards-compliant parsing plus post-resolution validation.

## Impact

SSRF, open redirect, XSS via javascript: URLs, protocol smuggling.

## Remediation

Use standard parsers, enforce scheme+host allowlists post-DNS, reject credentials in URLs, validate the final resolved destination.

## Regression Test

Table-driven tests covering IP forms, encodings, backslashes, ports, userinfo, and unicode hosts.

## Common False Positives

Validators applied to values that only feed non-network sinks; upstream normalization removing hostile forms.

## Related Skills

- ssrf-analysis.md
- canonicalization.md
- open-redirect.md
- encoding-validation.md

## References

- OWASP SSRF Prevention
- CWE-20
- WHATWG URL Standard

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
