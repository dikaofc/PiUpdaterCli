# Skill: CPE Normalization

## Purpose

Normalize CPE 2.3 (WNF) strings and CPE-based affected-version data from NVD configurations.

## Trigger Conditions

Activate when reviewing cpe, cpe 2.3, wfn.

## Investigation Method

1. Parse CPE 2.3 WNF fields: part, vendor, product, version, update, edition, language, sw_edition, target_sw, target_hw, other.
2. Normalize vendor/product casing and aliases consistently (lowercased canonical keys with alias table).
3. Extract version ranges from NVD configurations: versionStartIncluding/Excluding, versionEndIncluding/Excluding, and match criteria (targetSw, targetHw).
4. Map CPE vendor/product to known vendor keys (see vendor-correlation) without hardcoding exclusivity.
5. Store structured, not just raw strings (schemas/cpe.schema.json) to enable matching.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

CPE records parsed into structured form with version-endpoint ranges and a sample match verification.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

CPE raw-string matching fails on aliases, wildcards, and range endpoints.

## Impact

Wrong product/version applicability from string-substring heuristics.

## Remediation

Structured WNF, canonical keys with aliases, range endpoints as first-class fields.

## Regression Test

CPE parse/match tests including wildcard and range cases.

## False Positives

CPEs with wildcard version (*) meaning unknown — match on product with version verified separately.

## Related Skills

- cve-cpe-matching.md
- cve-version-matching.md
- version-normalization.md

## References

- CPE 2.3 specification
- NVD configuration schema
