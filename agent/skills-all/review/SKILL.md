---
name: review
description: Review a diff across correctness, security, performance, maintainability, testing, and compatibility, with severity, confidence, and verified findings.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a git repository with a diff to review.
metadata:
  category: review
  tags: [review, code-review, findings]
---

# R
<!-- ​​ built by @dikaacode (telegram) ​​ -->
eview

## Objective
Produce a verified code review of a change set: obtain the diff, gather context, evaluate
every change across six categories (correctness, security, performance, maintainability,
testing, compatibility), and report findings with severity
(BLOCKER/CRITICAL/HIGH/MEDIUM/LOW/INFO) and confidence (0-1). **Verify each finding
against the actual code before reporting it.**

## Preconditions
- A change set exists: working tree, staged changes, a commit, or a branch.
- Repository is indexed (`cap index --refresh`) and `cap status` is healthy.
- The review scope is defined (which diff: unstaged / staged / commit / branch).

## Workflow
1. Run `cap status` for ecosystem and git state, then `cap index --refresh`.
2. Get the diff and impact analysis: `cap diff` (add `--staged`, `--commit <h>`, or `--branch <b>` as appropriate). Note symbols touched and the diff summary.
3. Read the full diff, then read each changed file in context with `cap show <file> --lines a-b` (the changed lines plus surrounding context).
4. For changed symbols, gather usage context: `cap explore <symbol>` for definitions/references and `cap search <usage>` for callers and tests.
5. Run `cap review` to collect engine findings, then evaluate the diff **manually** per category: correctness, security, performance, maintainability, testing, compatibility.
6. For each candidate finding, record: file, line, severity, category, problem, reason, impact, suggested_fix, confidence (0-1) — per CONTRACT.md §7.
7. **Verify findings before reporting**: re-read the code path for each finding; confirm with `cap show`/`cap explore`; run `cap test`/`cap lint` when a finding depends on observable behavior. Downgrade or drop findings you cannot verify.
8. Check the overall change risk with `cap risk` and include it in the report.
9. When a finding's impact is unclear, estimate the blast radius from callers (`cap explore` references) rather than guessing; record the estimate as such.
10. Record durable review lessons with `cap memory add` (e.g., recurring defect patterns in this repo).

## Verification
- [ ] Every reported finding was verified against the code (file:line confirmed by `cap show`).
- [ ] No unverified findings are reported as fact; uncertain ones are marked INFO/low confidence.
- [ ] Severities are calibrated (BLOCKER only for must-fix before merge; CRITICAL/HIGH for urgent fixes).
- [ ] All six categories were considered, not just the ones with findings.
- [ ] Findings include problem, reason, impact, and suggested_fix.
- [ ] `cap risk` score reported.
- [ ] Impact/blast-radius statements are labeled estimated when not measured.

## Failure Handling
- If a finding cannot be verified: downgrade its severity/confidence or drop it, and note the uncertainty.
- If the diff is too large to review safely: split by commit (`cap diff --commit <h>`) and review in chunks, reporting the limitation.
- If the engine and manual review disagree: investigate both views with the code as the source of truth.

## Output Format
Final report:
- Review scope (diff base, files, +/- counts).
- Findings list, each with: file, line, severity, category, problem, reason, impact, suggested_fix, confidence.
- Summary by severity and category.
- `cap risk` score and overall recommendation (approve / approve with changes / reject).

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §7 Findings schema (severity levels, categories, confidence).
- CONTRACT.md §1 Tool Layer: `cap diff`, `cap review`, `cap show`, `cap explore`, `cap search`, `cap risk`.
