# Skill: Deserialization Analysis

## Purpose

Find unsafe deserialization of attack-controlled data in formats supporting gadget chains (pickle, Java, PHP, YAML, Ruby, .NET) leading to RCE or SQLi.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: deserialization, gadget chain, pickle, java deserialization rce.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find deserialization sinks: pickle.loads, ObjectInputStream.readObject, unserialize, YAML.load (unsafe), Marshal.load, BinaryFormatter, JSON with type resolution (Jackson polymorphic).
2. Trace whether attack-controlled bytes/strings (files, cookies, params, upstream data) reach those sinks.
3. Check version and known gadget availability in reachable dependencies.
4. For JSON-based polymorphism: check allowlists of allowed classes (Jackson default typing).
5. Test locally ONLY with safe harnesses: parse a payload with a controlled class to confirm class instantiation is possible; never chain real gadgets against live systems.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A data-flow trace plus a local test confirming the sink performs unsafe object construction from attack-shaped data (e.g., arbitrary class instantiation), with library versions cited.

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

Deserializing untrusted data in a format/language whose object model exposes gadget chains, without allowlists.

## Impact

Remote code execution, SQL injection (via gadgets), DoS.

## Remediation

Never deserialize untrusted data; use safe formats (JSON with strict schemas); allowlist classes for polymorphic deserializers; keep gadget libraries patched.

## Regression Test

Tests asserting untrusted inputs are rejected at deserialization boundaries and allowlisted classes only construct expected types.

## Common False Positives

Deserialization of trusted internal data only (no boundary crossing); Jackson with explicit allowed types; safely configured YAML loaders.

## Related Skills

- serialization-security.md
- parser-security.md
- code-injection.md
- json-security.md

## References

- OWASP Deserialization Cheat Sheet
- CWE-502
- ysoserial research (for understanding only)

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
