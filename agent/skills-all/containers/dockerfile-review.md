# Skill: Dockerfile Review

## Purpose

Review Dockerfiles for security anti-patterns: ADD-from-URL, RUN curl-pipe, secrets in ARG/ENV, and unordered layers.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: dockerfile, add url, arg env secret, layer caching.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Read every Dockerfile: base, packages, ADD/COPY sources, RUN commands.
2. Check ADD-from-URL and curl-pipe RUNs (untrusted fetches).
3. Check secrets in ARG/ENV (present in image history).
4. Check COPY of whole directories (secrets, .git, node_modules overrides).
5. Check layer caching ordering (COPY everything first defeats cache + increases attack window).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A Dockerfile review with specific unsafe lines cited (ADD URL, ARG secret, curl-pipe).

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

Convenience patterns that fetch at build time or store secrets in image config.

## Impact

Build-time supply-chain compromise; secrets extractable from image.

## Remediation

Pin base images, use COPY from build contexts, Docker BuildKit secrets (--mount=type=secret), no curl-pipe.

## Regression Test

CI lint (hadolint) failing on unsafe directives.

## Common False Positives

Fetches from official/vetted endpoints with hash verification.

## Related Skills

- container-security.md
- postinstall-script-analysis.md
- software-supply-chain.md

## References

- Docker best practices
- hadolint
- CWE-494

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
