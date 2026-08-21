# Skill: Container Image Analysis

## Purpose

Analyze container images for vulnerabilities, secrets, and unnecessary bloat (layers with credentials).

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: container image, image scan, layers, secret in image.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Scan images: vulnerability scans (Trivy/commercial), secret scanners on layers.
2. Check multi-stage hygiene: build tooling left in final image, caches, .git, keys.
3. Check base image maintenance: outdated base layers with known CVEs.
4. Check layer history: secrets baked in an early layer then "removed" (still extractable).
5. Check image signing/verification at deploy.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A scan report (image, CVEs by severity, secrets) from a local scan tool with specific hits cited.

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

Fat images built without multi-stage scoping or secret hygiene.

## Impact

Known-CVE exploitation in the runtime; credential extraction from layers.

## Remediation

Multi-stage builds, minimal final stage, scan in CI with gates, no secrets in build args that persist, sign images.

## Regression Test

CI failing on critical CVEs/secrets in images.

## Common False Positives

Scans baseline-accepted CVEs with documented risk assessment.

## Related Skills

- container-security.md
- hardcoded-secret-detection.md
- software-supply-chain.md

## References

- CIS Docker Benchmark
- Trivy docs
- CWE-312

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
