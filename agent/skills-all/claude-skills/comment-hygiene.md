---
name: comment-hygiene
description: Audit code comments — stale, misleading, redundant — and replace them with clear names or remove them.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: review
  tags: [comments, docs, naming, hygiene]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Comment Hygiene Audit

## Objective
Audit comments across a module or diff and classify them: STALE (contradicts the
code), MISLEADING (inaccurate contract or claim), REDUNDANT (restates the code), or
VALUABLE (explains why). Fix by renaming the code to carry the meaning, deleting
redundancy, and correcting stale claims — never by expanding comment volume.

## Preconditions
- Repository is indexed (`cap index --refresh`); the target module is known or
  discoverable via `cap explore`.
- The project's doc-comment rules are identified (`cap rules check <file>`).

## Workflow
1. Run `cap status` and `cap repo` to confirm environment and note the working tree state.
2. Scope the audit: the current diff (`cap diff --base <ref>`) or a module found via `cap explore <module>`.
3. Harvest comment sites: `cap search "//"` and `cap search "/\*"` within the target paths; also `cap search "TODO|FIXME|HACK"` for action items.
4. Read each site with `cap show <file> [--lines a-b]`, then verify the claim against the code below it and the symbol contract via `cap explore <symbol>`.
5. Classify each comment: STALE (code changed, comment not), MISLEADING (contract wrong: params, returns, failure modes), REDUNDANT (restates the line), VALUABLE (explains non-obvious why).
6. Run `cap risk --json` to confirm low change risk, then apply the minimal fix per class:
   - REDUNDANT → delete.
   - STALE → delete (the code is truth) unless the fix is to correct the comment.
   - MISLEADING → correct the comment or, better, fix the naming via a rename (`cap plan "rename <symbol>"`).
   - TODO/FIXME → verify against `cap search`/`cap explore`; resolve, convert to a tracked issue in the report, or keep with a date.
7. Never touch code behavior; comment fixes must be zero-behavior-change edits.
8. Verify: `cap verify`, `cap test`, `cap lint`, `cap typecheck`; `cap rollback --task <id>` on any regression.
9. `cap diff` to confirm only comment/rename changes.
10. `cap memory add` the comment convention (comment why, not what) for future reviews.

## Verification
- [ ] Every comment in scope classified; classification backed by `cap show` evidence.
- [ ] Deleted/corrected comments leave no stale claim behind (re-check with `cap search` on keywords).
- [ ] `cap verify` passes; `cap diff` shows comment/rename-only changes.
- [ ] TODO/FIXME items either resolved, reported as actionable issues, or kept with justification.
- [ ] No new comment was added to explain code that should be renamed.

## Failure Handling
- If a STALE comment hides a real behavior bug (code and comment disagree on a contract): stop, report the disagreement as a finding with both versions — do not silently pick one.
- If the module is on a hot/released path and `cap risk` is high: audit only, no edits; deliver the classification table.
- If a rename is required to kill a comment but the symbol is exported: check callers via `cap explore <symbol>`; defer the rename if callers are out of scope.

## Output Format
- Classification table: file:line | class | the comment | the evidence (code it describes) | action (delete/correct/rename/keep).
- Renames applied (old → new) and files touched.
- TODO/FIXME resolution status.
- Verification results (`cap verify`, `cap test`, `cap risk`).

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap explore`, `cap search`, `cap show`, `cap risk`, `cap rollback`.
- CONTRACT.md §3 Rules for doc comments on public functions (comments are contract, not decoration).