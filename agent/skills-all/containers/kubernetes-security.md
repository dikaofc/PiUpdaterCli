# Skill: Kubernetes Security

## Purpose

Audit Kubernetes: RBAC, admission control, network policies, secrets, and pod security standards.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: kubernetes, k8s, rbac, network policy, pod security.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Review RBAC: service account permissions, cluster-admin usage, token exposure.
2. Check admission control: PSP/PSS applied, deny-esc rules, validating webhooks.
3. Check network policies: default-deny between namespaces?
4. Check secrets: stored in etcd encrypted, accessed via mounted volumes not env dumping.
5. Check the control plane: kubeconfig exposure, etcd accessibility.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- RBAC bindings, PSS labels, network policies, and secret config cited; dangerous cluster-admin bindings are findings.

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

Default permissive RBAC/no network policies/PSS not applied.

## Impact

Lateral movement within the cluster, secret theft, cluster compromise.

## Remediation

Least-privilege service accounts (automountServiceAccountToken=false when not needed), enforce PSS, default-deny netpols, etcd encryption.

## Regression Test

CI policy (kube-bench, OPA) asserting RBAC/PSS/netpol expectations.

## Common False Positives

Single-node dev clusters outside prod; namespaces with explicit allow rules.

## Related Skills

- container-security.md
- cloud-iam-analysis.md
- network-exposure.md

## References

- CIS Kubernetes Benchmark
- OWASP K8s Cheat Sheet
- Kubernetes hardening guide

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
