# Skill: Deserialization Security

## Purpose

Audit deserialization: unsafe formats (Java native, pickle, PHP unserialize, Marshal) processing untrusted data.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: deserialization, pickle, php unserialize, java deserialize, yaml.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find deserialization points: request bodies, queue messages, caches read from files, client round-trips.
2. Identify formats: native (Java serialization, pickle, unserialize, Marshal, BinaryFormatter) vs safe data formats (JSON/Protobuf).
3. Check data source: attacker-controllable content reaching these parsers?
4. Check gadget availability: affected libraries present in the classpath/stack.
5. Check alternates: is deserialization needed, or JSON/typed parsing sufficient?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A deserialization call site with a data-source trace and a proof (staged gadget or documented CVE) — no live exploit.

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

Trace code paths locally with debuggers/tests and mock services; reproduce with unit/integration tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Untrusted data passed to polymorphic/unsafe deserializers.

## Impact

RCE (gadget chains), object injection, logic abuse.

## Remediation

Use data-only formats, allowlist classes (ObjectInputStream filter, pickle disallowlist), never deserialize client round-tripped objects.

## Regression Test

Tests asserting unsafe formats are rejected from untrusted inputs.

## Common False Positives

Deserialization of self-generated internal data with integrity (HMAC) and no attacker influence.

## Related Skills

- deserialization-analysis.md
- serialization-security.md
- object-injection.md

## References

- OWASP Deserialization Cheat Sheet
- CWE-502

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
