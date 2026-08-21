---
name: architecture
description: Produce an architecture report — system overview, components, data/request flow, entry points, external services, database, risk areas, and technical debt.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: architecture
  tags: [architecture, design, analysis]
---

# A
<!-- ​​ built by @dikaacode (telegram) ​​ -->
rchitecture

## Objective
Build an evidence-based architecture report of the system: a high-level overview, the
component decomposition, data and request flow, entry points, external services,
database schema and access patterns, risk areas, and accumulated technical debt — with
every statement grounded in files found via the index.

## Preconditions
- Repository is indexed (`cap index --refresh`).
- `cap status` and `cap repo` succeed so the environment and repo type are known.
- No assumption is made about existing documentation; the code is the source of truth.

## Workflow
1. Run `cap status` (ecosystem state) and `cap repo` (repo detection: language, build system, entry points).
2. Run `cap index --refresh`, then survey the top-level structure with `cap explore <top-level-query>` (e.g., `src`, `app`, `lib`) to map module boundaries.
3. **Entry points**: `cap explore <entrypoint>` (`main`, `index`, `server`, `cli`, workers) and read each with `cap show <file> --lines a-b`; record startup sequence and initialization.
4. **Components**: identify components via `cap explore` (module/package boundaries) and `cap search` for import/dependency edges between them; describe each component's responsibility from its code.
5. **Data/request flow**: trace a representative request or data pipeline end-to-end using `cap explore <symbol>` references and `cap show`; record the path (handler → service → store) and note async/queued stages.
6. **External services**: `cap search` for HTTP clients, `fetch`, connection strings, and config; list each external service, its purpose, and failure handling.
7. **Database**: `cap explore` for models, migrations, and query modules; `cap show` the schema definitions; note storage engines, key collections/tables, and index/replication hints visible in code.
8. **Risk areas**: note monoliths, tight coupling, shared mutable state, missing error handling, and unguarded boundaries found during tracing.
9. **Technical debt**: flag TODOs/FIXMEs (`cap search` for `TODO|FIXME|HACK`), duplicated logic, dead code (`cap explore` symbols with no references), and outdated dependencies.
10. Run `cap risk` for the current change state, and record durable architecture decisions with `cap memory add`.

## Verification
- [ ] Overview, components, and flow statements each have file references (`cap show`/`cap explore`).
- [ ] Entry points, external services, and database sections list concrete files/lines.
- [ ] Data/request flow was traced through actual code, not inferred from naming.
- [ ] Risk areas and technical debt items are evidence-based (file:line).
- [ ] Sections that could not be completed are marked unknown, not filled with guesses.

## Failure Handling
- If a component's purpose is unclear: read its tests and callers (`cap explore` references); if still unclear, mark it unknown rather than speculating.
- If the repo is too large to cover exhaustively: scope to the requested area, and state the covered/not-covered boundary in the report.
- If documentation exists but contradicts code: trust the code, note the discrepancy.

## Output Format
Final report with sections in order:
1. System overview (1 paragraph).
2. Component list (each: name, responsibility, key files).
3. Data/request flow (with file:line hops).
4. Entry points.
5. External services.
6. Database (schema/files, key structures, access patterns).
7. Risk areas.
8. Technical debt.
9. Open questions / unknowns.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap risk`, `cap memory`.
