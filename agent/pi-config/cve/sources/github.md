# Source: GitHub Security Advisories (GHSA)

**Priority: #6** for advisory-level severity and ecosystem ranges.

## When to use

- Packages hosted/reviewed on GitHub (npm, PyPI, Maven, NuGet, Go, RubyGems,
  crates, etc.).
- Advisories that carry a `cve_id` (most do) or are GHSA-only.
- Cross-checking affected ranges for GitHub-ecosystem packages.

## What to extract

- `ghsa_id`, `cve_id`, `summary`, `severity` (GHSA level), `cvss`
  (vector+score), `cwes`, `ecosystem`, `vulnerable` ranges with
  `vulnerable_version_range` and `first_patched_version`, `references`.

## How to use

- GHSA severity is advisory-level: compare against NVD/vendor with
  `cve-advisory-severity-validation` and preserve both.
- Map GHSA ecosystems to canonical ecosystem keys.
- Multiple GHSA records may reference the same CVE (one per ecosystem/
  package) — reconcile via `duplicate-detection`/`record-merging`.
- GHSA ranges complement NVD CPE ranges for language packages; prefer them
  for ecosystem consumers.

## Traps

- `vulnerable_version_range` strings follow GitHub's own syntax (e.g.,
  `>= 1.0, < 2.1`); normalize before comparing.
- Some advisories are withdrawn or marked false-positive; check state.
- GHSA coverage is GitHub-centric; non-GitHub-hosted packages need OSV or
  ecosystem trackers.

## Related

`github-advisory-ingestion`, `ecosystem-advisory-ingestion`,
`cve-advisory-correlation`, `cve-advisory-severity-validation`.
