# Skill: CWE Family Analysis

## Purpose

Analyze CVEs grouped into the 29 tracked CWE families: recognize the family, know the pattern, and route to the family skill.

## Trigger Conditions

Activate when reviewing cwe family, 29 families, weakness taxonomy.

## Investigation Method

1. Track the 29 CWE families with their canonical CWE IDs and primary skills:
2. 1 CWE-20 Improper Input Validation; 2 CWE-22 Path Traversal; 3 CWE-77/78 Command Injection; 4 CWE-79 Cross-Site Scripting; 5 CWE-89 SQL Injection; 6 CWE-91 XML Injection; 7 CWE-93/94 Code Injection; 8 CWE-95 Expression Language Injection; 9 CWE-98 File Inclusion; 10 CWE-113 CRLF/Header Injection; 11 CWE-116 Encoding/Canonicalization; 12 CWE-119/120 Buffer Overflow; 13 CWE-125 Out-of-bounds Read; 14 CWE-287 Authentication; 15 CWE-306 Missing Authentication; 16 CWE-307 Brute-Force; 17 CWE-311/319 cryptography/cleartext; 18 CWE-352 CSRF; 19 CWE-400/770 Resource Exhaustion; 20 CWE-416 Use-After-Free; 21 CWE-434 Unrestricted Upload; 22 CWE-444 HTTP Smuggling; 23 CWE-502 Deserialization; 24 CWE-601 Open Redirect; 25 CWE-611 XXE; 26 CWE-639/284 IDOR/BOLA; 27 CWE-798 Hardcoded Credentials; 28 CWE-862/863 Broken Access Control; 29 CWE-918 SSRF.
3. For each CVE, classify into its family with the CWE + description evidence.
4. Summarize per-family statistics across the project for systemic-risk reporting.
5. Keep the family table stable and documented (extension permitted with rationale).

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Family-classified CVE set with a per-family summary table.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Weakness type treated as a single tag instead of a family.

## Impact

Cross-CVE pattern blindness (e.g., many input-validation CVEs in one dependency cluster).

## Remediation

Canonical family taxonomy, classification with evidence, per-family reports.

## Regression Test

Family-classification fixtures per family id.

## False Positives

Chained CWEs classified under the wrong parent (e.g., CWE-79:CWE-80) - preserve the chain order.

## Related Skills

- cwe-mapping.md
- cve-cwe-correlation.md
- cve-triage-engine.md

## References

- CWE Top 25
- MITRE CWE list
