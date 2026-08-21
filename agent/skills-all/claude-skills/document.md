---
name: document
description: Generate and update README, API docs, architecture docs, and changelogs from verified repository facts.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: documentation
  tags: [documentation, readme, api, changelog]
---

# D
<!-- ​​ built by @dikaacode (telegram) ​​ -->
ocument

## Objective
Create or update project documentation — README, API documentation, architecture
documentation, and changelog — from verified repository facts (index, code, diffs, audit
trail) so the docs accurately reflect the current code rather than intent or memory.

## Preconditions
- Repository is indexed (`cap index --refresh`).
- The documentation scope is defined: which artifacts to create/update (README, API docs, architecture doc, changelog).
- Existing docs are located (`cap search` for `README*`, `docs/`, `CHANGELOG*`) and their current state noted.

## Workflow
1. Run `cap status` and `cap repo` to establish the environment, repo type, language, and conventions (incl. any doc style rules).
2. Survey existing docs: `cap search --path '*.md'` (or glob for README/CHANGELOG) and read them with `cap show` to see what exists and its format.
3. **README**: gather facts — what the project does (`cap repo`), install/build/test commands (from manifest/config files read via `cap show`), quick-start examples from tests or example files (`cap explore`), and badges/status. Update the README sections that are now inaccurate.
4. **API docs**: find the public surface — entry points, exports, and their signatures — via `cap explore <entrypoint>` and `cap show <file> --lines a-b`; document each exported function/class/endpoint with parameters, return values, and behaviors verified from code. For HTTP APIs, use `cap search` for route definitions and read the handlers.
5. **Architecture doc**: reuse the architecture workflow evidence (`cap repo`, `cap explore` components, `cap search` external services/database) and write or update overview, components, data/request flow, entry points, external services, and database sections.
6. **Changelog**: use `cap audit` (recent events) and `cap diff --commit <h>` / `cap diff --branch <b>` to list what changed since the last release; classify changes into features / fixes / breaking changes / maintenance; check existing `CHANGELOG*` format and follow it.
7. Run `cap rules check <doc-file>` on each written doc file to ensure it satisfies applicable rules.
8. Spot-verify docs against code after writing: re-run `cap explore`/`cap show` on any claim you are unsure about; fix mismatches. Confirm every example command shown in the README is sourced from a real config or test.

9. Record the doc set and any conventions with `cap memory add`.

## Verification
- [ ] Every factual claim (commands, APIs, endpoints, behaviors) verified against code/config via `cap show`/`cap explore`.
- [ ] README install/build/test instructions match the actual toolchain.
- [ ] API docs list every public symbol/endpoint in scope; none described from memory.
- [ ] Changelog entries map to `cap audit`/`cap diff` evidence; version bump rationale stated.
- [ ] `cap rules check` passes on doc files (where rules exist).
- [ ] Existing docs not in scope were left untouched.
- [ ] Example commands and snippets shown in docs were executed or copied from verified sources (not invented).
- [ ] Doc headings and structure follow the repo's existing documentation conventions.

## Failure Handling
- If code and existing docs conflict: the code is the source of truth; update the doc and note the discrepancy in the report.
- If an API surface is unclear (dynamic routes, metaprogramming): document what is verifiable and mark the rest as needing runtime inspection.
- If `cap audit` lacks history (fresh repo): say the changelog covers only the current state/known changes rather than inventing history.
- If no existing docs exist at all: create a minimal, accurate first version and state its scope (what is not yet covered).

## Output Format
Final report:
- Artifacts created/updated (paths).
- For each: what was added/changed and the key facts (with references).
- Verification status per artifact.
- Any discrepancies found between old docs and code.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap audit`, `cap rules check`, `cap memory`.
- CONTRACT.md §1: `cap audit` event semantics for changelog generation.
