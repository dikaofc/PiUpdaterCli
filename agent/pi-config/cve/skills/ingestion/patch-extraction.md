# Skill: Patch Extraction

## Purpose

Identify and extract the patch (commit/diff) that fixes a CVE, with enough context for patch analysis.

## Trigger Conditions

Activate when reviewing patch, commit, diff.

## Investigation Method

1. Resolve patch refs from reference-extraction into concrete commits (repo, sha, branch) or diff files.
2. Fetch the commit diff from the authoritative repo (when reachable and licensed) into the local cache.
3. Record: repository, commit sha, parent sha, changed files, and the CVE IDs claimed to be fixed.
4. Do not apply or copy patches blindly; patch content is for analysis (root cause, reachability) only.
5. If a patch cannot be verified, record UNKNOWN rather than guessing.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Cached patch records with repository/sha integrity and changed-file lists; unresolved refs clearly marked.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Patch references unverified or treated as authoritative without the actual diff.

## Impact

Fix analysis on wrong commits or missed backport opportunities.

## Remediation

Verified commit metadata, cached diffs, per-CVE fix links in cve-fix.

## Regression Test

Tests verifying commit fetch integrity and cache idempotency.

## False Positives

Commits that touch unrelated files — patch extraction focuses on the CVE-fixing changeset (verify with fix-commit metadata if available).

## Related Skills

- reference-extraction.md
- cve-patch-analysis.md
- cve-fixed-version.md

## References

- git docs
- GitHub commit API
