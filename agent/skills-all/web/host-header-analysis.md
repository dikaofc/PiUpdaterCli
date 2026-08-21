# Skill: Host Header Analysis

## Purpose

Check Host header handling: host poisoning, cache poisoning, password-reset link injection, and routing bypasses driven by the Host header.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: host header, host poisoning, absolute url generation.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find where Host is used: link generation, redirects, password-reset URLs, CSRF token domains, virtual-host routing, cache keys.
2. Trace whether the app trusts the Host header (and X-Forwarded-Host) without allowlisting.
3. Test locally with an arbitrary Host header and observe generated links/redirects.
4. Check cache keying: is the poisoned response cached and served to others?
5. Verify password-reset flows embed the attacker-supplied host into reset links.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test where a crafted Host produces links/redirects to attacker-controlled origins (or a cache side effect), with the generation code cited.

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

App-generated URLs built from the Host header without a configured allowlist of domains.

## Impact

Cache poisoning, password-reset poisoning (account takeover), routing bypass, mail link injection.

## Remediation

Use a configured canonical host for URL generation; validate Host against an allowlist; reject unexpected hosts; key caches by safe attributes.

## Regression Test

Tests asserting link generation uses the canonical host regardless of the request Host.

## Common False Positives

Gateways rewriting Host to canonical values; app using relative URLs everywhere.

## Related Skills

- web-cache-poisoning.md
- password-reset.md
- reverse-proxy-analysis.md

## References

- PortSwigger Host Header Attacks
- CWE-644

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
