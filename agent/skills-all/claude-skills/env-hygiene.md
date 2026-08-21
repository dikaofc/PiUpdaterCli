---
name: env-hygiene
description: Audit .env files and environment variables for secret leakage, naming consistency, and missing documentation.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); the audit is read-only and never prints secret values.
metadata:
  category: review
  tags: [env, secrets, .env, hygiene]
---

# Env Hygiene
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Audit environment-variable usage across the repository: detect secrets committed or printed, flag inconsistent naming, and verify every variable is documented (`.env.example` / README) with a defined type and default. Never write secret values to the report.

## Preconditions
- Repository indexed (`cap index --refresh`); `.env*` files and code reading `process.env` / `os.getenv` are discoverable.
- The user knows which files hold real secrets versus templates (`.env.example`); the audit treats `.env` values as redacted by default.
- The audit is read-only; any fix requires explicit user approval.

## Workflow
1. Run `cap status` and `cap index --refresh` to establish repo state.
2. Find env artifacts: `cap search` for `.env`, `.env.*`, `env.example`, `*.env` files; record which are tracked in git (`cap repo` / `cap status`).
3. Detect committed secrets: cross-reference tracked files against known credential patterns (tokens, api keys, passwords, connection strings) with `cap search`. Do not copy values into the report; redact to the variable name + risk level.
4. Map consumption: `cap search` for `process.env.` / `process.env[` (Node) and `os.getenv` / `$VAR` (other) to build the used-variable list; correlate with `cap explore` for how each var is passed into modules.
5. For each variable record: name, cases (e.g. `SUPER_SECRET_KEY`), usage sites, doc status, and value status (must-be-secret, may-be-default, must-be-set).
6. Flag naming inconsistencies across files: quoting style, suffix conventions (`_KEY`, `_TOKEN`, `_URL`), required vs optional defaults.
7. Flag undecorated risk: secrets stored in test fixtures `.env.test` that mirror prod values; `.env` tracked in git; hardcoded fallbacks in code.
8. With approval, apply fixes (remove committed `.env`, unify naming in `.env.example`, add docs), then `cap lint`, `cap verify`, and `cap diff` to confirm.
9. Persist durable rules (e.g. "never commit .env") via `cap memory add`.

## Verification
- [ ] Every env artifact located and its track status recorded.
- [ ] Secret scan completed; no secret value written to the report (names + risk only).
- [ ] Full variable inventory: name, usage sites, doc status, default, requiredness.
- [ ] Naming-convention inconsistencies tabulated.
- [ ] `.env.example` (or equivalent) is complete relative to consumed variables.
- [ ] If fixes applied: `cap verify` passes, `cap diff` shows intended edits, nothing committed without user request.

## Failure Handling
- If `.env` is tracked in git: stop the audit and flag it as a high-severity finding; recommend rotation, not just deletion, and get user confirmation before touching it.
- If a secret value must be referenced in the report: rotate it first or reference by hash — never plaintext.
- If a variable's semantics are unclear: mark documented-unknown and ask the user; do not invent conventions.
- If `cap verify` fails after fixes: use `cap rollback --task <id>` and re-apply fixes one at a time.

## Output Format
Final report:
- Artifact table: path, tracked?, contains-secrets?, role (template/real/test).
- Variable inventory: name, usage sites, doc status, default, required, risk.
- Inconsistent naming and doc gaps list.
- Actions taken (none unless approved) and verification results (`cap verify`, `cap diff`).

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap index --refresh`, `cap search`, `cap show`, `cap explore`, `cap repo`, `cap lint`, `cap verify`, `cap diff`, `cap rollback`, `cap memory add`.