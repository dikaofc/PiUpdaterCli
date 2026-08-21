# Source: OSV.dev

**Priority: #5** for ecosystem records with typed ranges.

## When to use

- Language-package ranges for npm, PyPI, Go, Maven, NuGet, Cargo, RubyGems,
  Composer, pub.dev, Hex, crates.io, etc.
- Records that may not (yet) have a CVE (OSV-* / GHSA-* advisories).
- Bulk export (all.zip) or per-ecosystem/query API (`/v1/query` with
  package+version).

## What to extract

- `id` (OSV-*, GHSA-*, or CVE-*), `aliases` (→ canonical CVE IDs).
- `affected[]`: package (ecosystem + name), `ranges` with `type`
  (SEMVER / ECOSYSTEM / GIT), `events` (introduced / fixed /
  last_affected), `versions` lists.
- `severity[]`, `references[]`, `summary`, `details`, `published`,
  `modified`, `withdrawn`.

## How to use

- Resolve aliases to the canonical CVE (duplicate-detection).
- Normalize ranges per type: GIT ranges use commits, ECOSYSTEM ranges use
  ecosystem version semantics, SEMVER uses semver — never conflate
  (`cve-range-analysis`).
- Ecosystem package names normalize per ecosystem identity rules
  (`package-identity-resolution`).
- Withdrawn advisories must not produce findings.

## Traps

- ECOSYSTEM ranges for distro ecosystems (Debian/Alpine) encode *distro*
  versions, not upstream — use distro trackers for OS packages.
- `last_affected` semantics differ from `introduced`-`fixed` pairs; handle
  per the OSV schema.
- An OSV record without a CVE alias is an advisory-level finding; do not
  mint a fake CVE.

## Related

`osv-ingestion`, `ecosystem-advisory-ingestion`, `version-normalization`,
`cve-range-analysis`, `cve-package-correlation`.
