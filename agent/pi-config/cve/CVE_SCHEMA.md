# CVE_SCHEMA.md

The canonical record formats used by the CVE Intelligence Engine. JSON Schema
definitions live in `schemas/*.json`; this document explains the model and
the rules that keep data honest.

## 1. cve.schema.json — canonical CVE record

One record per canonical CVE ID (`CVE-YYYY-NNNNN`), regardless of how many
sources describe it. Identity comes from CVE.org; enrichment comes from other
sources with provenance.

| Field | Type | Notes |
|---|---|---|
| `id` | string | `CVE-YYYY-NNNNN`, uppercase, canonical format |
| `state` | enum | `PUBLISHED` / `RESERVED` / `REJECTED` (from CVE.org) |
| `assigner` | string | CNA/source identifier |
| `datePublished`, `dateUpdated` | ISO-8601 | from CVE.org |
| `descriptions[]` | array | lang + text; NVD enrichment merged with provenance |
| `weaknesses[]` | array | `{ cweId, confidence: authoritative\|inferred }` |
| `metrics[]` | array | `{ version: v2\|v3.0\|v3.1\|v4, source, vector, baseScore, baseSeverity }` |
| `configurations[]` | array | NVD CPE nodes (structured, see cpe.schema.json) |
| `references[]` | array | `{ url, tags[], classification, source }` |
| `affected[]` | array | per-package: `{ ecosystem, package, ranges[], versions[], sources[] }` |
| `fixedVersions[]` | array | per (package, source): normalized first-fixed |
| `exploitation` | object | `{ status: KNOWN_IN_THE_WILD\|NOT_KNOWN\|UNKNOWN, kev?, sources[] }` |
| `reachability` | object | per-project annotation: classification + evidence level |
| `aliases[]` | array | GHSA/OSV/DSA ids resolving to this CVE |
| `provenance` | object | per-field source tags and merge changelog |

**Rules**

- Absent fields stay absent or are marked `UNKNOWN`; never defaulted.
- REJECTED records carry no metrics/exploitation flags.
- RESERVED records (no description yet) keep state visible; treated as
  `UNKNOWN`, not as vulnerabilities.
- Every merged field keeps both values when sources conflict.

## 2. cpe.schema.json — CPE 2.3 (WNF) match entries

Structured representation of NVD configuration data for applicability.

| Field | Notes |
|---|---|
| `part` | `a` / `o` / `h` |
| `vendor`, `product` | normalized canonical keys (aliases resolved) |
| `version` | exact version or `*` (unknown) |
| `update`, `edition`, `language`, `sw_edition`, `target_sw`, `target_hw` | WNF fields |
| `versionStartIncluding/Excluding` | range start endpoints |
| `versionEndIncluding/Excluding` | range end endpoints |
| `nodeLogic` | AND/OR node context in the configuration |
| `source` | record provenance |

**Rules**

- Version `*` means unknown — product matching still valid, version must be
  verified separately.
- Range endpoints are first-class fields, never string-concatenated.

## 3. cvss.schema.json — CVSS vector/score records

| Field | Notes |
|---|---|
| `version` | `2.0` / `3.0` / `3.1` / `4.0` |
| `vector` | raw vector string |
| `components` | parsed metric values (validated against the version spec) |
| `baseScore`, `baseSeverity` | recomputed-or-verified values |
| `source` | NVD / vendor advisory / GHSA / OSV / other |
| `computedAt` | timestamp |
| `recomputeMatches` | boolean: score recomputed from vector == published |

**Rules**

- Vectors are validated against the version-specific enumeration; malformed
  vectors are flagged, not silently fixed.
- Cross-version comparison uses qualitative bands, never raw-number mixing.

## 4. advisory.schema.json — advisory records

Any advisory that references a CVE (vendor, GitHub, OSV, distro, ecosystem).

| Field | Notes |
|---|---|
| `id` | advisory id (e.g., `GHSA-xxxx`, `DSA-xxxx`, vendor id) |
| `cveId` | canonical CVE link (may be absent for advisory-only records) |
| `source`, `url`, `publishedAt` | provenance |
| `affected[]` | per package: ecosystem, package, ranges, versions |
| `fixed[]` | fixed/patched version lists per package |
| `severity` | advisory-level severity (may differ from canonical) |
| `withdrawn` | boolean |
| `raw` | original document/JSON preserved |

**Rules**

- Advisory records are first-class; they are linked to CVEs, never merged
  into them silently.
- Advisory severity is advisory-level data, not the canonical severity.

## 5. package.schema.json — package inventory records

The project-facing side: components discovered in the codebase.

| Field | Notes |
|---|---|
| `ecosystem` | npm, pypi, maven, nuget, go, cargo, rubygems, composer, ... |
| `name` | canonical package name (identity-resolved) |
| `version` | resolved exact version (lockfile) |
| `source` | manifest/lockfile path |
| `deployed` | enum `DEPLOYED` / `BUILD_ONLY` / `OPTIONAL_NOT_INSTALLED` / `UNKNOWN` |
| `via[]` | dependency chain for transitive components |
| `platform[]` | OS/arch constraints if any |
| `devOnly` | boolean |

**Rules**

- Version is lockfile-resolved, never manifest-declared.
- Package identity follows per-ecosystem canonicalization rules.

## Integrity invariants across schemas

- `fixed` version must not fall inside an `affected` interval (violations are
  flagged as data errors with both sources preserved).
- `datePublished <= dateUpdated` for every record.
- Every `related[]`/`alias` reference must resolve.
- CWE ids must be canonical 4-digit and resolve in the CWE hierarchy.
- Every record's provenance lists which source supplied each field.
