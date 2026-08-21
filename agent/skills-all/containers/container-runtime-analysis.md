# Skill: Container Runtime Analysis

## Purpose

Audit the container runtime configuration: seccomp, apparmor, SELinux, and namespace isolation.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: container runtime, seccomp, apparmor, namespace.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find runtime config: docker daemon settings, containerd, cri-o, k8s runtimeClass.
2. Check seccomp/apparmor profiles applied (not default permissive).
3. Check namespace isolation: hostPID/hostNetwork/hostIPC usage.
4. Check cgroup device access and mounts (host paths read-write).
5. Check runtime-level defaulting: are profiles the default for all pods?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Runtime config/pod securityContext cited with profile and host-namespace usage.

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

Default permissive runtimes without profile enforcement.

## Impact

Weak isolation → escape/denial affecting neighbors.

## Remediation

Default seccomp (docker/default or custom), apparmor profiles, no host namespaces, restricted device access.

## Regression Test

CI policy checking pod securityContext for profiles and host namespaces.

## Common False Positives

Purposeful host-namespace workloads (daemonsets) properly isolated.

## Related Skills

- container-security.md
- kubernetes-security.md
- sandbox-escape-analysis.md

## References

- CIS Docker/K8s benchmarks
- seccomp/apparmor docs

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
