# CVE_REMEDIATION.md

Remediation guidance: exact fix versions, upgrade planning, patch/backport
assessment, prioritization, and verified closure.

## Principles

1. **Fix the version, not the line.** The deliverable is the exact upgrade
   target with evidence, not a generic "update dependency".
2. **Multi-source fix resolution.** First-fixed is collected from every
   source (OSV/GHSA events, vendor advisories, distro trackers) and
   normalized per ecosystem (`cve-fix-version-resolution`). Conflicts are
   preserved with provenance; the conservative target wins.
3. **No fix known is a real answer.** `NO_FIX_KNOWN` with the source
   statement; `UNKNOWN` when unresolved. Never guess a fix version.
4. **Risk × cost ordering.** High risk + low cost first; batching by
   component; explicit plans for hard items
   (`cve-remediation-prioritization`).

## The remediation ladder

For every affected finding, in order:

1. **Upgrade** — resolve the target version, assess breaking changes and
   migration steps, plan verification and rollback
   (`cve-upgrade-planning`).
2. **Backport** — when the project cannot upgrade (pinned old versions,
   distro constraints): find existing backports (vendor security releases,
   distro backports) or assess feasibility of applying the upstream patch
   (`cve-backport-assessment`).
3. **Mitigate** — config/feature/deployment-level mitigation that closes the
   reachable path, *verified* as effective in the deployed configuration
   (`cve-configuration-applicability`); documented as mitigation, not fix.
4. **Accept with evidence** — for `PRESENT_BUT_UNUSED` / `LOW` items:
   document the reachability basis and a review date.

## Patch analysis

`cve-patch-analysis` reviews the fixing diff: root-cause pattern, files
changed, fix completeness. Incomplete fixes (one path closed, others open)
are findings, not solved CVEs. This feeds backport decisions and reachability
validation.

## Prioritization inputs

| Input | Weight direction |
|---|---|
| Triage priority band | risk side |
| Upgrade effort (breaking changes, test surface) | cost side |
| Backport availability | lowers cost |
| Component batching (one upgrade fixes N CVEs) | lowers cost |
| Dependency ordering within a stack | sequencing |

## Verification of remediation

`cve-remediation-verification`:

1. Re-resolve the lockfile/inventory to the new versions (controlled env).
2. Re-run version membership: verdict must flip to NOT-AFFECTED.
3. Delta scan: confirm no unacceptable new CVEs from the upgrade.
4. Re-run the regression suite for the upgraded component.
5. Close the CVE record only with the verdict-flip evidence.

Closure is version-verified, not manifest-verified: a changed `package.json`
without a deployed artifact change does not close a CVE.

## Report

`cve-audit-report-generation` assembles findings, actions taken, verified
closures, remaining accepted risks, and the coverage statement into
`templates/cve-report.md`.
