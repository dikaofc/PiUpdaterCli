---
name: changelog-manager
description: Maintain CHANGELOG files following Keep a Changelog and SemVer conventions, from version-bump planning to verified release notes.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); verification steps use `cap diff` and `cap verify`.
metadata:
  category: coding
  tags: [changelog, semver, release, docs]
---

# Changelog Manager
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Keep the repository CHANGELOG accurate and convention-compliant (Keep a Changelog format, SemVer versioning): determine which unreleased changes belong to the next version, write honest entries grounded in the actual diff, and verify the result.

## Preconditions
- CHANGELOG file located (`CHANGELOG.md` or alternates via `cap search`) and its current version/format understood.
- Unreleased changes exist (or a release is being planned); the diff to summarize is known.
- Convention edition agreed: Keep a Changelog structure with `Added/Changed/Deprecated/Removed/Fixed/Security` sections.

## Workflow
1. Run `cap status` and `cap repo` to confirm repo state; `cap search` to find `CHANGELOG*`, `package.json` / manifest version, and any `version` tooling.
2. Read the existing CHANGELOG (`cap show <file>`) and the manifest (`cap show package.json`) to record current version and section style (keep-conventional vs abbreviated).
3. Determine the change set: from `cap diff` (staged/unstaged) and commits since the last tag (`git log <last-tag>..HEAD`); classify each change into Keep a Changelog sections.
4. Map each change to a fact: file, commit/sha, section, and user-visible impact sentence; do not write entries for changes without evidence.
5. Decide the next version from SemVer + the section mix: breaking -> MAJOR, new features -> MINOR, only fixes/refactors -> PATCH; record the reasoning.
6. Edit the CHANGELOG: add the new version header with date, insert verified entries under their sections, keep existing history untouched. Edit with `cap show <file>`-grounded patches only.
7. If the manifest version must bump in lockstep, apply it and cross-check with `cap explore <symbol>` for any code asserting versions.
8. Run `cap diff` to verify only intended changelog/version changes, then `cap verify`.

## Verification
- [ ] Current version and CHANGELOG format recorded from actual files.
- [ ] Every new entry traces to a diff/commit fact (no invented changes).
- [ ] Version bump reasoning matches SemVer rules and the section mix.
- [ ] Sections follow the agreed convention; old history untouched.
- [ ] `cap diff` shows only changelog/version edits.
- [ ] `cap verify` passes.

## Failure Handling
- If a change cannot be traced to a factual diff: omit it; do not guess entries.
- If breaking changes appear in the fix set: flag for a MAJOR bump and ask the user before writing the version.
- If the CHANGELOG has multiple prior formats: follow the most recent convention in the file and note the inconsistency.
- If `cap verify` fails after edits: revert with `cap rollback --task <id>`, apply the changelog edits without the version bump, and re-verify.

## Output Format
Final report:
- Current version, manifest version, last tag (facts).
- Change inventory: change -> section -> evidence (sha/file).
- Next version decision and SemVer reasoning.
- CHANGELOG edits applied (sections touched) and verification results (`cap diff`, `cap verify`).
- Entries intentionally omitted (no evidence) and the reason.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap search`, `cap show`, `cap explore`, `cap diff`, `cap verify`, `cap rollback`.