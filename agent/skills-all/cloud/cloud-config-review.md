# Skill: Cloud Config Review

## Purpose

Audit cloud service configuration: identity, storage, networking, encryption, and monitoring defaults.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: cloud config, aws, gcp, azure, security group, encryption.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory cloud services: compute, storage, DB, IAM roles, networking, serverless.
2. Check storage: public buckets, encryption, versioning, lifecycle.
3. Check compute: SSH key handling, instance metadata protections (IMDSv2), patch posture.
4. Check network: security groups/NACLs, VPC isolation, egress control.
5. Check monitoring: CloudTrail/Stackdriver/Azure activity logs enabled + alerting.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A cloud inventory with risky defaults cited (public bucket, broad SG, metadata exposure) from IaC/console review.

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

Use cloud provider policy simulators and read-only IAM policy evaluation on your own account only.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Provider defaults or convenience choices (public, broader-than-needed, unencrypted).

## Impact

Data breach via exposed storage, instance takeover via metadata, lateral movement.

## Remediation

Enforce encryption/least exposure defaults via policy-as-code, enable logging, restrict egress, IMDSv2.

## Regression Test

IaC policy gates (checkov/tfsec) failing on risky resources.

## Common False Positives

Intentional public assets (CDN/static); dev accounts isolated from prod.

## Related Skills

- cloud-iam-analysis.md
- network-exposure.md
- cloud-storage-security.md
- cloud-metadata-analysis.md

## References

- CIS AWS/GCP/Azure Benchmarks
- CWE-668

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
