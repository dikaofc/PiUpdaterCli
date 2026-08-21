---
name: regression-hunter
description: Find which commit introduced a regression using git bisect driven by a reproduction test — evidence, not archaeology.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [regression, bisect, history, commit]
---

# Regression Hunter
<!-- built by @dikaacode (telegram) -->

## Objective
Narrow a regression to the single introducing commit by bisecting history against a reproduction that fails only on bad revisions. Deliver the culprit commit, the repro evidence, and the minimal reverted/fixed diff.

## Preconditions
- A behavior changed between two known revisions (good vs. bad) — or can be reproduced on current HEAD and did not exist at a known older tag/commit.
- The repo has usable history (`cap repo --log`) and the bad revision reproduces locally.
- A reproduction exists or is constructible as a one-command check (the `crash-reproducer` skill output suffices).
- Repository is indexed (`cap index --refresh`).

## Workflow
1. Run `cap status` and `cap repo --log` to record HEAD, and `cap repo` to confirm history and tool state; ensure the working tree is clean before bisecting (stash or note dirty files).
2. Verify the reproduction is a genuine proxy for the regression: run it on a known-good revision (older tag) and on the current bad one via `cap`'s revision switching — it must pass on good and fail on bad. If it passes on both, the regression has no repro yet; build one first.
3. Establish the bisect range: good = oldest revision where the behavior worked; bad = the first reported broken revision. If only one bad point is known, derive good from `cap repo --log` at the feature's adding commit.
4. Run `cap plan` to sketch bisection steps, then bisect: check out midpoint, `cap test --target <repro>` (or the one-command check), classify good/bad; repeat halving until exactly one commit remains.
5. On the culprit commit: `cap diff <culprit>` to see the full change; `cap explore` its touched symbols to understand intent.
6. For each change in the culprit, isolate which hunk flips the repro: re-run the repro with the hunk reverted in a scratch worktree (never on the bisect branch). The hunk whose revert makes the repro pass is the regression.
7. Decide fix vs. revert: if the culprit is a deliberate feature, fix forward (`cap plan` + smallest patch); if accidental, revert that hunk only.
8. Run `cap verify` on the fix/revert, then confirm the repro passes and `cap diff` is scoped. `cap memory add` the culprit commit and its pattern.

## Verification
- [ ] Repro validated on both ends of the range: pass on good, fail on bad — never trusted unvalidated.
- [ ] Bisect narrowed to exactly one commit (log of midpoint classifications kept).
- [ ] The causing hunk isolated: reverting it flips the repro in a scratch worktree.
- [ ] Fix/revert scoped by `cap diff`; original repro passes post-fix.
- [ ] `cap verify` passes; no worktree/stash residue (`cap status` clean).

## Failure Handling
- Repro is flaky mid-bisect: skip that revision (`cap` bisect skip) and note it; a flaky repro means the proxy is weak — strengthen or replace it (see `flaky-test-triage`).
- Range contains a large merge: test each parent; the culprit may be a merge resolution, not a single-parent change.
- Known-good revision does not exist (regression predates history): bisect the repo's initial state as the exclusive lower bound, and report the limitation — the hunt then finds the earliest regression-containing commit, not the true introduction.
- The culprit commit fixes symptoms elsewhere: do not revert wholesale; isolate the hunk (step 6) and report the coupling explicitly.

## Output Format
Report:
- Bisect range (good/bad revisions) and midpoint classification log.
- Culprit commit (hash, message, author/date) and its full `cap diff` summary.
- Causing hunk with reason: which behavior change flips the repro.
- Decision (fix forward vs. hunk revert), the scoped `cap diff`, and `cap verify` result.
- If range was incomplete: the earliest-known-containing commit and why the true intro cannot be proven.

## References
- CONTRACT.md §2 Skill Format; §1 Tool Layer (`cap repo --log`, `cap diff`, `cap test`).
- CONTRACT.md §7.3: reproduce first — the repro validates every bisect step.
- `crash-reproducer` for constructing the failing fixture; `debug` for reproduction discipline.