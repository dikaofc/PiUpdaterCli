# Sources — priority and principles

Which source to trust for which purpose, and the ordering rules for merging.

## Priority order (for conflicting data)

1. **Vendor advisory** — the vendor is the authority on *their* product's
   affected/fixed versions and severity.
2. **CVE.org (CVE Services / CNA records)** — authority on CVE *identity*:
   ID, state (PUBLISHED/RESERVED/REJECTED), assigner, dates.
3. **NVD** — authority on *enrichment*: CVSS vectors/scores, CWE mappings,
   CPE configurations, references.
4. **CISA KEV** — authority on *known in-the-wild exploitation* (status +
   due dates). Priority input only, never an applicability verdict.
5. **OSV** — ecosystem records with typed ranges (SEMVER/ECOSYSTEM/GIT) and
   aliases; strong for language-package ranges.
6. **GitHub Advisory (GHSA)** — advisory-level severity and ecosystem ranges;
   secondary to vendor/NVD when they conflict.
7. **Distro/ecosystem trackers** (Debian, Ubuntu USN, Alpine secdb, Red Hat,
   npm audit, PyPA ...) — authority on distro-specific patched versions and
   backport status.

## Purpose-specific authority

| Question | Primary source |
|---|---|
| Does this CVE ID exist / its state? | CVE.org |
| What is the affected/fixed version for product X? | Vendor advisory > NVD/CPE > OSV > GHSA |
| What is the CVSS vector/score? | NVD (validated), vendor advisory (preferred if more precise) |
| What CWE family? | NVD weaknesses array (authoritative), else inference (tagged) |
| Is it exploited in the wild? | CISA KEV; vendor statements |
| Ecosystem package ranges (npm/PyPI/...)? | OSV, GHSA, ecosystem trackers |
| Distro-patched version? | Distro trackers (backport semantics) |
| Where is the patch? | NVD references, vendor advisory, patch extraction |

## Principles

1. **Never overwrite silently.** Conflicting fields keep both values with
   provenance; the priority order selects the *canonical* value.
2. **Absence is not safety.** A source that lacks data (e.g., no version
   ranges in a vendor advisory) yields `UNKNOWN`, not "not affected".
3. **Freshness matters.** Record fetched/updated timestamps; stale data is
   flagged (`cve-timeline-analysis`), and re-triage triggers on KEV/feed
   changes.
4. **Offline is a first-class mode.** All analysis runs against local caches;
   network fetches are an update path only. Missing data → `UNKNOWN`, never
   fabrication.
5. **Idempotent ingestion.** Re-running a fetch/merge converges; the
   pipeline's end state is deterministic for the same inputs.

## Ecosystem coverage

| Ecosystem | Primary range source | Distro nuance |
|---|---|---|
| npm / pnpm / yarn | OSV, GHSA, npm audit | — |
| PyPI | OSV, PyPA, GitHub | distro python packages via Debian/Ubuntu trackers |
| Maven / Gradle | GHSA, NVD, vendor | distro builds via distro trackers |
| NuGet | GHSA, NVD | — |
| Go modules | OSV (Go vuln DB) | — |
| Cargo | OSV (rustsec) | — |
| RubyGems | OSV, Ruby Advisory DB | — |
| Composer | GHSA, Packagist | — |
| OCI containers | image SBOM scan + OS trackers | base-image vs distro patched |
| OS packages | distro trackers (DSA/USN/secDB/RH) | backport semantics mandatory |

See `sources/vendor.md`, `sources/cve-org.md`, `sources/nvd.md`,
`sources/cisa-kev.md`, `sources/osv.md`, `sources/github.md` for per-source
details, and `CVE_SCHEMA.md` for the record model.
