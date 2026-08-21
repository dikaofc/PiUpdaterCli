# Skill: Endpoint Discovery

## Purpose

Enumerate HTTP/API endpoints and their methods, parameters, content types, and auth requirements from code and OpenAPI specs.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: endpoint, api surface, openapi, routes.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Parse OpenAPI/Swagger specs; cross-check every declared route against actual handlers.
2. Enumerate framework routes including middleware-applied prefixes, version prefixes, and health/debug routes.
3. For each endpoint record: method, params (body/query/path), content types, auth middleware applied, rate limiting, response shapes.
4. Find undocumented endpoints: handlers not in any spec, dynamically added routes (wildcards, catch-all), debug/admin routes.
5. Note duplicate routes (same path, different methods) and route-ordering issues (wildcard shadowing).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Endpoint table with file refs. Claim "endpoint X lacks auth" only after tracing the middleware chain from the router, not from the route file alone.

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

Use only repositories/projects you own or have written authorization to inspect. Run discovery against local clones and localhost services; never against third-party systems.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

N/A — discovery; feeds api skills.

## Impact

Undocumented or wildcard endpoints are frequent sources of access-control failures.

## Remediation

Generate docs/specs from code; gate debug routes behind env flags and network restrictions.

## Regression Test

CI test that diffs registered routes vs spec and fails on undocumented or unauthenticated new routes.

## Common False Positives

Ignoring auth middleware applied at a global level; treating stale specs as truth.

## Related Skills

- api-surface-analysis.md
- backend-entrypoint-analysis.md
- middleware-analysis.md

## References

- OWASP API Security Top 10 API1 (broken object level auth)
- CWE-1007

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
