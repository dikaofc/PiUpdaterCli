# Skill: Orchestration Secrets

## Purpose

Audit secrets in orchestration: env vars vs mounted secret files, base64-only k8s secrets, and secret mutation safety.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: orchestration secrets, k8s secrets, env var secret, secret mount.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find where secrets are injected: env vars, mounted files, configmaps, docker secrets.
2. Check k8s secrets: base64 obfuscation only — is etcd encrypted, RBAC on secret access?
3. Check env-var secrets: visible via env dump, process listing, and logs.
4. Check configmap-vs-secret confusion: sensitive data in plaintext configmaps.
5. Check rotation: can secrets be rotated without full pod restarts?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Injection paths cited (env vs mount, secret type); plaintext secret-in-configmap is a finding.

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

Analyze local Dockerfiles/images in an isolated runtime with read-only mounts; never attack production infrastructure.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Convenience env-var/configmap injection without encryption/RBAC discipline.

## Impact

Secret theft from a single read (configmap get, env dump).

## Remediation

Mounted secret files + KMS-backed secrets, etcd encryption, RBAC restricted, secret stores (Vault/ExternalSecrets) for rotation.

## Regression Test

IaC checks asserting secrets not in configmaps and etcd encryption enabled.

## Common False Positives

Non-secret config legitimately in configmaps; KMS-managed secrets.

## Related Skills

- kubernetes-security.md
- secret-management.md
- environment-secret-analysis.md

## References

- Kubernetes secrets docs
- OWASP K8s Cheat Sheet
- CWE-315 (cleartext storage)

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
