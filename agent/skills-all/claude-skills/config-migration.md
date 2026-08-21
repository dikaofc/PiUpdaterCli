---
name: config-migration
description: Migrate configuration between formats or schemas with pre/post validation, a dry-run diff, and a rollback path.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); validation and rollback run through `cap verify` and `cap rollback`.
metadata:
  category: coding
  tags: [config, migration, schema]
---

# Config Migration
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Move configuration between formats (e.g. JSON to YAML, dotenv to JSON) or schemas (renames, restructuring) with validation before and after the migration, a dry-run diff for user approval, and a guaranteed rollback path.

## Preconditions
- Source config files located (`cap search`) and their current schema understood (`cap show`).
- Target format/schema definition exists or is agreed with the user (field mapping is explicit).
- A validation method exists for both sides (parse, schema check, or tooling) — in this skill, verification runs through `cap verify` and per-file parse checks.

## Workflow
1. Run `cap status` and `cap index --refresh`; locate config files and their consumers (`cap search`, `cap explore`) to know the blast radius.
2. Record source facts: path, format, key inventory, value types, and any consumers importing/reading the config (`cap explore <config-symbol>`).
3. Define the mapping table: source key -> target key, value transformation (if any), and default handling for missing keys.
4. Run a dry-run migration in memory: produce the target content without writing; verify parse + schema validity of the output.
5. Show the dry-run diff (`cap diff`-style output of in-memory old vs new) to the user; get approval before writing.
6. Write the migrated config; keep a rollback copy or a recorded git-ignored snapshot of the source.
7. Update consumers: re-point imports/reads to the new path or schema with the minimal edit; verify each consumer with `cap explore`/`cap search`.
8. Validate post-migration: parse every migrated file, check keys/values against the mapping table, and run `cap verify` (config-driven tests must keep passing).
9. Confirm the diff by comparing old config snapshot vs new: every intended transformation present, none missing.

## Verification
- [ ] Source inventory completed, all consumers found.
- [ ] Mapping table complete (every source key accounted for).
- [ ] Dry-run output validated (parse + schema) before writing.
- [ ] User approval recorded for the written migration.
- [ ] Post-migration: every target file parses; every mapped key/value matches the table.
- [ ] Consumers updated and verified with `cap explore` / `cap search`.
- [ ] `cap verify` passes after migration.

## Failure Handling
- If a key has no mapping in the source: fail the dry run, list the unmapped key, and pause for the user before continuing.
- If post-migration validation fails: restore from the snapshot (`cap rollback --task <id>`), fix the mapping, and re-run dry-run before rewriting.
- If a consumer cannot be updated (missing symbol): flag it as a blocker; the migration is not complete until every consumer is verified.
- If the target format has no validator available: validate structurally (parse + key inventory) and state the limitation.

## Output Format
Final report:
- Source facts and consumer list.
- Mapping table (source -> target, transformations, defaults).
- Dry-run result and approval status.
- Written files and consumer updates.
- Post-migration validation results and `cap verify` outcome.
- Rollback instructions (snapshot path or `cap rollback --task <id>`).

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap index --refresh`, `cap search`, `cap show`, `cap explore`, `cap diff`, `cap verify`, `cap rollback`.