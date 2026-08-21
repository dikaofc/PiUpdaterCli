---
name: pr-description
description: Generate a structural PR description from a diff — why, risk, test plan — with verified facts.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: coding
  tags: [pr, description, changelog, review]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# PR Description Generation

## Objective
Produce a ready-to-paste PR description from the working tree diff: what changed,
why it changed, risk assessment, and a test plan — every statement grounded in
`cap` facts (diff, risk score, symbols touched), never guessed from memory.

## Preconditions
- The diff to describe exists: staged (`cap diff --staged`), committed (`cap diff --base <ref>`), or a branch (`cap diff --base <base-branch>`).
- Repository is indexed (`cap index --refresh`) so symbol impact analysis is accurate.

## Workflow
1. Run `cap status` to confirm which changes are staged vs unstaged, and pick the diff scope.
2. Gather the diff: `cap diff [--staged | --base <ref>] --json` for the summary (files, added/deleted lines, symbols touched).
3. Determine WHY: for each changed area, `cap explore <symbol>` to find callers/dependents, and check `cap memory get` for task context (`cap task status <id>` if a task exists); if a ticket/issue is linked in the branch, include it.
4. Assess risk: `cap risk --json` for the numeric score and category; read the risk-critical hunks with `cap show <file> [--lines a-b]` to cite them precisely.
5. Build the test plan: `cap test --target <file>` targets derived from the symbols touched, plus `cap verify` for the full pipeline.
6. Check conventions: `cap rules check <file>` for files whose style changed; note any rule deviations as review asks.
7. Draft the description in the standard structure: **Summary** (one paragraph, why), **Changes** (bulleted, per area with file:line anchors), **Risk** (score + category + the specific risky lines), **Test Plan** (commands run and expected), **Out of scope** (explicitly not covered).
8. Validate every claim against the diff: re-run `cap diff` and cross-check each bullet has an anchor; remove unverifiable statements.
9. If a `cap commit` proposal is wanted, run `cap commit --dry-run` for the commit subject; keep PR title <= 70 chars.
10. Present the description for user review — do not push, open a PR, or commit unless explicitly asked.

## Verification
- [ ] Every "why" claim traceable to `cap diff`, `cap explore`, or memory/task entries.
- [ ] Risk section cites the actual `cap risk` score, not a paraphrase.
- [ ] Test plan commands are runnable `cap` invocations with expected outcomes stated.
- [ ] File:line anchors match `cap show` output.
- [ ] PR title and summary within length conventions.

## Failure Handling
- If the diff is empty (nothing staged, base equals HEAD): report "no changes to describe" with the `cap status` output — do not fabricate a description.
- If `cap risk` returns an error for the scope: fall back to `cap diff` impact analysis and say the risk score was unavailable.
- If a claim cannot be verified (unclear why a change was made): mark it ASK-REVIEWER in the description instead of inventing a reason.

## Output Format
- PR title (<= 70 chars).
- Summary / Changes (with anchors) / Risk (score, category, lines) / Test Plan / Out of scope / Review asks (open questions, rule deviations).

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap diff`, `cap risk`, `cap explore`, `cap verify`, `cap commit --dry-run`.
- CONTRACT.md §4 Severity/risk definitions used by the risk section.