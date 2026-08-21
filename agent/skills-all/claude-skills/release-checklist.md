---
name: release-checklist
description: Run the pre-release gate: version, changelog, tests, build, and tag readiness, each backed by verified facts.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); release checks run through `cap verify`, `cap test`, and `cap repo`.
metadata:
  category: review
  tags: [release, version, tag, checklist]
---

# Release Checklist
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Produce a binary go/no-go verdict for a release by checking, in order, version consistency, changelog completeness, test and build health, and tag readiness — each item supported by executable facts, never assumptions.

## Preconditions
- A target version is known or proposed; candidate release branch/commit identified.
- The repository is indexed and the toolchain configured (`cap repo`).
- The release is not actually performed by this skill — it audits readiness only (tag/push remain manual or user-approved).

## Workflow
1. Run `cap status` and `cap repo` to record branch, dirty-tree state, and the current version from manifests.
2. Version consistency: read `package.json` (or equivalent manifests) with `cap show`; compare against CHANGELOG's latest version header and the last git tag (`git tag --list`); report every mismatch as a blocker question.
3. Changelog readiness: `cap show <CHANGELOG>`; the release version must have entries in the required sections, the exact version string, and a date; entries must trace to commits/branches.
4. Test gate: run `cap test` (targeted then full suite); record pass/fail counts and any flaky tests.
5. Build gate: run the project build (`cap verify` covers build where configured); record the artifact or build output status.
6. Static health: run `cap lint` and `cap typecheck` (where applicable); list failures as blocker or non-blocker with reasons.
7. Tag readiness: confirm the release commit sha exists, the working tree is clean (or the dirty files are approved), and the tag target is unambiguous.
8. Summarize each item as PASS / FAIL / UNKNOWN with evidence (sha, log tail, command output summary).

## Verification
- [ ] Version strings cross-checked across manifest, CHANGELOG, and tags; mismatches listed.
- [ ] CHANGELOG release entry exists, dated, and content-traceable.
- [ ] `cap test` executed; counts recorded.
- [ ] Build executed via `cap verify`; result recorded.
- [ ] `cap lint` / `cap typecheck` results recorded with blocker classification.
- [ ] Release commit sha and tree cleanliness confirmed.
- [ ] Go/no-go verdict issued with every item's evidence.

## Failure Handling
- If version strings disagree: mark NO-GO, list the conflicting sources, and do not proceed to tag checks.
- If tests fail: mark NO-GO unless the failures are pre-existing, documented, and agreed as non-blocking — state that explicitly.
- If build fails: NO-GO until a build error is fixed and re-verified.
- If any check could not run in this environment: mark UNKNOWN, never PASS, and say why.
- The skill never creates a git tag by itself; if a tag is requested, return the exact command and require user execution.

## Output Format
Final report:
- Verdict: GO / NO-GO / GO-WITH-CAVEATS (one line).
- Checklist table: item, result (PASS/FAIL/UNKNOWN), evidence, blocker? (yes/no + reason).
- Blockers list and the minimal fix for each.
- Exact tag command (version, message, target sha) for user execution, if a tag is requested.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap show`, `cap test`, `cap lint`, `cap typecheck`, `cap verify`.