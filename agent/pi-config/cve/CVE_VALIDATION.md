# CVE_VALIDATION.md

Validation gates that protect the pipeline from corrupt data, invented
values, and false positives. Every gate is evidence-based and reversible.

## 1. Schema validation

Every record (cve, cpe, cvss, advisory, package) validates against
`schemas/*.json` at ingestion and at any enrichment step
(`cve-data-validation`).

- CVE ID syntax: `CVE-YYYY-NNNNN` (supports 1999 → future; year field is
  informational, the sequential part is unbounded).
- Dates: ISO-8601; `datePublished <= dateUpdated`.
- Vectors: validated against the CVSS version enumeration
  (`cvss-v3-vector-validation`, `cvss-v4-vector-validation`).
- CWE ids: canonical 4-digit, resolvable in the CWE hierarchy.

## 2. Cross-field consistency

`cve-data-consistency-check` catches:

- fixed version inside an affected interval (data error; both sources kept);
- inverted/empty affected intervals;
- REJECTED/RESERVED records carrying metrics or exploitation flags;
- referential breakage (aliases, related ids, package keys);
- stale timestamps (records not updated for N periods).

## 3. CVSS validation

- Parse + validate vector components per version.
- Recompute the score from the vector; flag discrepancies with published
  values (`cve-vector-conflict-detection`).
- Keep all (version, source, vector, score) pairs; select canonical by
  source priority; explain metric-level conflicts between sources.
- Cross-version comparison uses qualitative bands only
  (`cve-cvss-score-normalization`).

## 4. Evidence and confidence

- Verdicts carry evidence levels (E0–E5) and confidence
  (`reachability-evidence-model`, `cve-confidence-model`).
- A verdict without its required evidence auto-downgrades to `UNKNOWN`.
- Tool output is evidence only when the tool inspected the right artifact —
  verify, don't assume.

## 5. Knowledge gap tracking

`cve-knowledge-gap-analysis` measures per-dimension coverage: missing
descriptions, missing ranges, missing CWE, missing vectors, undefined
exploitation status, missing patch data. Gaps are prioritized and filled;
coverage statements in reports come from this data — no overclaiming.

## 6. The false-positive engine

`cve-false-positive-engine` runs an evidence-gated filter stack:

1. duplicate/alias collapse;
2. product/component mismatch;
3. version out-of-range;
4. platform/architecture mismatch;
5. feature/config/flag disabled;
6. not-deployed (dev/optional);
7. vulnerable functionality not present;
8. code path not imported/called;
9. verified mitigation closes the path.

Rules:

- Each filter requires evidence; no evidence → filter does not apply.
- Every FP verdict is recorded with the filter used and the evidence.
- FPs are reversible and reviewable — never auto-deleted.
- KEV-flagged items get a dedicated mismatch filter
  (`cve-kev-false-positive-filter`).
- Missing evidence yields `UNKNOWN`, never "clean".

## Validation artifacts

- Per-stage validation reports (records validated, violations by class,
  disposition).
- Consistency reports (violation counts + samples).
- Gap reports (coverage by dimension).
- FP run reports (candidates reduced by filter, verdicts + evidence).

All artifacts are inputs to the final report's coverage statement
(`cve-audit-report-generation`).
