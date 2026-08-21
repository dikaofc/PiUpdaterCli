# Source: NVD (NIST)

**Priority: #3** for enrichment: CVSS, CWE, CPE configurations, references.

## When to use

- Obtaining the CVSS vector/score (v2/v3/v4) for a CVE.
- Obtaining the CWE mapping (weaknesses array).
- Obtaining CPE configurations (affected product/platform ranges) for
  applicability analysis.
- Obtaining reference lists with tags (Patch, Vendor Advisory, Exploit,
  Third Party Advisory, ...).

## What to extract

- `id`, `published`, `lastModified`, `status`.
- `descriptions` (enrichment source for text).
- `metrics` (`cvssMetricV2`, `cvssMetricV30`, `cvssMetricV31`,
  `cvssMetricV40`) — keep per-version records.
- `weaknesses` (CWE ids, optionally chained).
- `configurations` → structured CPE nodes with version start/end endpoints.
- `references` with tags.

## How to use

- CVSS/CWE/CPE enrich the canonical record with provenance; identity and
  affected-version authority remain CVE.org/vendor.
- Validate vectors and recompute scores (`cvss-v3-vector-validation`,
  `cvss-v4-vector-validation`); NVD data has known errors.
- CPE configurations are matched structurally (`cve-cpe-matching`); the
  `version:*` wildcard means unknown, not universal.

## Traps

- NVD enrichment lag: new CVEs can take days/weeks to be fully enriched —
  do not read absence of enrichment as absence of the CVE.
- NVD CVSS vs vendor CVSS conflicts are common; use
  `cve-vector-conflict-detection` and prefer vendor where justified.
- NVD reference tags are sometimes wrong or incomplete; classify references
  with evidence (`reference-extraction`).

## Related

`nvd-ingestion`, `cvss-normalization`, `cwe-normalization`,
`cpe-normalization`, `cve-cpe-matching`, `cve-vector-conflict-detection`.
