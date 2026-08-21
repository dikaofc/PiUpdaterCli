# Skill: CWE Mapping

## Purpose

Maintain the mapping between CWE IDs and the analysis skills that address them, so CVE triage routes to the right skill automatically.

## Trigger Conditions

Use whenever a CVE record carries CWE data or when a weakness family needs a skill path.

## Investigation Method

1. Map each CWE ID (and chain) to the relevant skills: input-validation, injection, auth, session, crypto, storage, business-logic, api, frontend, backend, etc.
2. Use CWE parent/child hierarchy: a child CWE maps to its parent's skills plus child-specific skills.
3. Give each mapping a confidence (explicit CWE in record = authoritative; inferred = inferred).
4. Define default routing when no CWE exists: route by vulnerability type from description keywords (tagged inferred).
5. Keep the mapping in data form so triage can query it.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

A queryable CWE→skill mapping table with sample routing decisions (CVE with CWE-89 routes to sql-injection skill).

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

CWE ignored or treated as a display tag.

## Impact

Triage misses the right analysis path.

## Remediation

Data-driven mapping, hierarchy-aware queries, confidence tags.

## Regression Test

Routing fixtures asserting the skill path per CWE.

## False Positives

CWE-79:XSS in records for stored vs reflected variants - routing table differentiates by context.

## Related Skills

- cwe-family-analysis.md
- cve-cwe-correlation.md
- cve-triage-engine.md

## References

- MITRE CWE
- CWE hierarchy
