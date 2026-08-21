# Skill: Data Flow Discovery

## Purpose

Trace the journey of important data (requests, user identity, money, secrets, PII) from source to sink across the codebase.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: data flow, taint, source, sink, propagation.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Pick a high-value data set (auth headers, user input, money, PII) and define its sources.
2. Trace transformations through parsers, serializers, DB layers, and middleware, noting where encoding/validation occurs.
3. Identify sinks: queries, shell, filesystem, rendering, network calls, crypto, logs.
4. For each hop, check whether trust level changes and whether validation/sanitization exists or is skipped.
5. Produce the flow as SOURCE -> TRANSFORMATION -> VALIDATION -> AUTHORIZATION -> SINK with file refs.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- At least one full data-flow trace with per-hop file refs and validation status; flows with gaps become leads for injection/authorization skills.

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

N/A — model skill; output feeds taint/data-flow and xss/sqli/ssrf skills.

## Impact

Untraced flows hide injection, access-control, and data-exposure bugs.

## Remediation

Validate at boundaries with explicit injection points; document flows in design docs.

## Regression Test

A test asserting a newly added transformation cannot bypass an existing validation layer.

## Common False Positives

Assuming a sink is safe because the framework usually escapes it, without checking the actual call site.

## Related Skills

- data-flow-analysis.md
- trust-boundaries.md
- taint-analysis.md

## References

- OWASP Data Flow Diagrams guidance
- CWE-1357 (reliance on unreliable source)

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
