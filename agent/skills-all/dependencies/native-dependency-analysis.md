# Skill: Native Dependency Analysis

## Purpose

Analyze native dependencies: C/C++ libraries, system packages, OS-level
dependencies, and their versions/reachability.

## Scope

- Included: system packages, shared libraries, image base layers, native
  modules (FFI), version pinning.
- Excluded: language-package advisories (`dependency-audit.md`).
- Layers: OS/container level.

## Trigger Conditions

- Dockerfiles/OS packages.
- FFI/native modules.
- Claims of "dependency audit complete" that exclude native.

## Inputs

- Dockerfiles/OS configs
- native manifests
- runtime images

## Investigation Method

1. Identify entry points: image/OS dependency lists.
2. Identify trust boundaries: N/A.
3. Track relevant data: native versions.
4. Identify validation: pinned/patched.
5. Identify security-sensitive operations: native sinks (parsers, crypto).
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: reachability.
10. Validate the finding: version/reachability check.

## Evidence Requirements

- E1: image/OS evidence.
- E2: usage/reachability for flagged natives.

## Confidence

- HIGH with E2; MEDIUM with E1.

## Severity

- Per reachability; image CVEs often MEDIUM unless reachable.

## Safe Reproduction

- Local image scan (trivy-style) and usage tracing.

## Root Cause

- Base images unpinned; OS packages unpatched.

## Impact

- Reachable native vulnerabilities (libc, openssl, parsers).

## Remediation

- Pin base images; patch cadence; scan images; minimal images.

## Regression Test

- Image-scan CI gates.

## Common False Positives

- Vulnerable natives unreachable from app input.

## Related Skills

- `dependency-audit.md`
- `../containers/docker-security.md`
- `../containers/image-security.md`

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected
- [ ] Severity assigned
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed

## References

- OS package trackers, NVD
- Docker/trivy docs
