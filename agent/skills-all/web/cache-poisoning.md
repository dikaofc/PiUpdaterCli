# Skill: Web Cache Poisoning

## Purpose

Analyze cache keying vs reflection to find cache poisoning: unkeyed inputs reflected into cached responses served to other users.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: cache poisoning, unkeyed input, cache key.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map the caching layers (CDN, reverse proxy, app cache) and their cache keys (method+path+some headers).
2. Find inputs not in the cache key that affect the response: specific headers (X-Forwarded-Host, X-Forwarded-Proto), query params, cookies.
3. Test locally with two requests differing only in the unkeyed input; if the second response is served for the first request, poisoning exists.
4. Check poisoned outputs with security impact: stored scripts, redirects, Set-Cookie, hosted content.
5. Assess whether the poison persists (TTL, shared cache).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local cache experiment where a response influenced by an unkeyed input is served to a request that should not include it, with the cache config cited.

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

Cache keys omitting inputs that change the response; apps incorporating request headers into responses.

## Impact

Mass XSS or content spoofing served from cache to all users.

## Remediation

Key caches on everything affecting the response; never reflect request headers; use Vary correctly; validate Host/Proto at the app.

## Regression Test

Cache-behavior tests asserting unkeyed inputs cannot alter cached responses.

## Common False Positives

Caches with correct Vary; unkeyed inputs that do not change the cached bytes; private/person-specific responses never cached.

## Related Skills

- cache-analysis.md
- host-header-analysis.md
- request-smuggling.md
- caching-correctness.md

## References

- PortSwigger Web Cache Poisoning research
- CWE-1287

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
