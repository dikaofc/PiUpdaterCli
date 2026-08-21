# Skill: Trust Boundary Discovery

## Purpose

Identify every place where data crosses from a lower to a higher trust domain (browser->API, tenant A->B, user->admin, container->host, CI->deploy).

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: trust boundary, trust levels, privilege domains.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Enumerate trust domains in the system (anonymous, authenticated user, tenant, admin, service, host, cloud account).
2. For each domain transition, find the enforcement point: auth middleware, tenant resolver, IAM policy, session check.
3. Verify each enforcement point is server-side and cannot be bypassed by direct calls (e.g., calling an internal API without the frontend).
4. Look for cross-boundary data structures (objects carrying tenant/role fields from client input) and whether they are re-derived server-side.
5. Map delegation: service-to-service auth, tokens passed along, webhook authenticity (signature validation).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A trust boundary diagram with enforcement points cited by file/line. Each boundary marked enforced-by-code or enforcement-gap.

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

N/A — model skill; lets later findings point at the exact missing enforcement.

## Impact

Missing enforcement at trust boundaries is the root pattern behind most authorization bugs.

## Remediation

Enforce at boundaries, re-derive trust attributes server-side, never accept them from the client.

## Regression Test

Integration tests asserting denial across each boundary (tenant B cannot read tenant A data).

## Common False Positives

Assuming a UI check is the protection; missing identity-propagation checks in service-to-service calls.

## Related Skills

- trust-boundaries.md
- access-control-analysis.md
- server-side-authorization.md

## References

- OWASP Threat Modeling
- CWE-668 (exposure of resource to wrong sphere)

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
