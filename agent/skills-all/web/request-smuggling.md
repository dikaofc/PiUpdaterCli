# Skill: HTTP Request Smuggling

## Purpose

Find request smuggling: front-end/back-end parsing discrepancies (Content-Length vs Transfer-Encoding) allowing request prefixing/desync.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: request smuggling, desync, CL-TE, TE-CL.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Identify front-end/back-end pairs (proxy/CDN/WAF before the app server) and their HTTP parser libraries.
2. Check how the app handles conflicting CL/TE headers and unusual framing (chunked sizes, whitespace variants).
3. Test locally: build a dual-stack harness (one parser in front, another behind) and send crafted CL-TE/TE-CL requests, observing desync with benign markers.
4. Check keep-alive timeout handling for queue-based smuggling (head-of-line).
5. Assess impact channels: cache poisoning, request capture, WAF bypass.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local dual-parser demonstration of desynchronization where a subsequent request is corrupted/prefixed, with both parsers identified.

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

HTTP front ends and back ends disagree on message framing, and the app does not reject ambiguous requests.

## Impact

Poisoned responses, request capture (account takeover), WAF bypass, cache poisoning.

## Remediation

Single HTTP parser at the edge (normalize requests), reject CL+TE conflicts, disable keep-alive between mismatched layers, or use HTTP/2 end-to-end.

## Regression Test

A test suite sending CL-TE/TE-CL/obfuscated variants to the proxy chain, asserting rejection or consistent framing.

## Common False Positives

Single-layer architectures with no conflicting parsers; frameworks rejecting malformed framing; HTTP/2-only deployments.

## Related Skills

- http-smuggling.md
- cache-poisoning.md
- reverse-proxy-analysis.md
- security-headers.md

## References

- PortSwigger Request Smuggling research
- CWE-444

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
