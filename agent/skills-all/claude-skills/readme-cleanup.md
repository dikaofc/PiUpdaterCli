---
name: readme-cleanup
description: Update the README — install, usage, quickstart — verifying each claim against the actual project.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: documentation
  tags: [readme, onboarding, install, usage]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# README Cleanup

## Objective
Bring the README up to date and fact-based: install instructions, usage, and a
working quickstart — with every claim verified against the repository (package
manifest, CLI help, entry points, test commands). Stale or invented instructions are
removed or corrected; the result is a README a newcomer can follow end-to-end without
guessing.

## Preconditions
- A README exists (or the user asks to create a fresh one) and the repo structure can be read via `cap repo`/`cap explore`.
- `cap pick --query "README"` locates the file to edit.

## Workflow
1. Run `cap status` and `cap repo` to get project type, test runner, and package manager facts.
2. Confirm the README path: `cap pick --query "readme"` or `cap explore "README"`.
3. Read the README with `cap show` and inventory its claims: install commands, prerequisites, usage examples, quickstart steps, test/lint commands, badges/links.
4. Verify each claim:
   - Install: cross-check against `package.json` (`cap show package.json`), lockfile, `.nvmrc`/`.tool-versions`, and `Capfile`/`cap init` docs (`cap explore "init"`).
   - Usage: run the documented commands safely or verify flags against `cap show` of the CLI entry (`cap explore "main|bin"`).
   - Quickstart: re-execute the steps in order; each must match the current API (`cap explore <symbol>` for any command/symbol referenced).
5. Mark each claim VERIFIED, STALE, WRONG, or UNVERIFIABLE with evidence.
6. Rewrite the README: fix/remove stale and wrong sections, keep verified ones, and reorder to Install → Usage → Quickstart → Test → Contributing.
7. Keep the edit minimal: no feature advertising, no unsupported claims, no invented badges.
8. Re-verify the rewritten README: re-run any changed commands or re-check symbols; confirm every remaining claim is backed.
9. Run `cap diff` to confirm README-only changes; no code was touched.
10. `cap memory add` any environment quirks discovered (e.g., actual install flags) so future doc edits start from facts.

## Verification
- [ ] Every README claim classified; VERIFIED/WRONG backed by evidence.
- [ ] Re-running the quickstart steps succeeds (in order) or each failing step is reported with the fix.
- [ ] Install instructions match the manifest/lockfile facts.
- [ ] `cap diff` shows README-only changes; no code modified.
- [ ] No unverifiable badge/statistic left in place.

## Failure Handling
- If the quickstart cannot be fully executed in this environment (missing service, network): execute the runnable subset and mark the rest VERIFY-MANUALLY with exact commands; never fake a pass.
- If install instructions conflict between README and manifest: trust the manifest (`cap show package.json`) and fix the README, noting the discrepancy.
- If a documented callback/API no longer exists: `cap explore <symbol>` for the current equivalent before updating the text.

## Output Format
- Claim inventory: claim (quoted) | evidence (file:line or command result) | verdict.
- Changes applied: sections rewritten/removed/added.
- Remaining manual-verify items with exact commands.
- Verification summary (`cap diff`).

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap repo`, `cap pick`, `cap show`, `cap explore`, `cap diff`.
- CONTRACT.md §5 Rollback rules (revert README changes via `cap rollback` if needed).