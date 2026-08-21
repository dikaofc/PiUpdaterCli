# Skill: Serialization Security

## Purpose

Audit serialization of trusted objects to formats exposed to attackers: trust boundaries, integrity protection, and field tampering via signed/encoded blobs.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: serialization, pickle, marshal, php serialize, integrity.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find serialization usage: JSON.stringify, pickle, Marshal, PHP serialize, Java Serializable, YAML dumps, protobuf — who sees the bytes?
2. Check whether serialized blobs are exposed to clients (cookies, params, storage) with or without integrity protection (HMAC/signature).
3. If integrity-protected: check secret strength, key reuse, and whether the secret is client-accessible.
4. Trace the deserialization side: are fields trusted that should be re-derived?
5. Test locally: a signed blob with a tampered field must fail verification (positive security test).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A field in a client-visible serialized blob that the server trusts without integrity verification, or a signing weakness, with both serialize/deserialize lines cited.

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

Exposing serialized state to clients without a strong, server-side-only integrity mechanism.

## Impact

State tampering (price/role), deserialization RCE (where dangerous formats deserialize attacker data).

## Remediation

Keep serialized state server-side; for client-held state use server-verified signatures/HMAC; avoid deserializing untrusted data in unsafe formats (pickle/Java).

## Regression Test

Tests tampering every field of client-held blobs asserting signature failure and server-default rejection.

## Common False Positives

Blobs never exposed to clients; signatures verified with strong keys; JSON-as-data (not deserialization) without trust issues.

## Related Skills

- deserialization-analysis.md
- token-generation.md
- cookie-security.md
- jwt-analysis.md

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
