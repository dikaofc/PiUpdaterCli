---
description: Produce a system overview — components, boundaries, data flow, dependencies
argument-hint: [focus area]
---

Bui
<!-- ​​ built by @dikaacode (telegram) ​​ -->
ld the system picture from repository intelligence, not from memory.

1. `cap repo` — repository map (detection: language, entry points, structure).
2. `cap explore "<module names>"` for each top-level module — file/symbol relationships.
3. `cap show <entry file> [--lines a-b]` for each major entry point; `cap headers <file>` for core file metadata.
4. Optionally `cap search "<import patterns>"` to sketch the dependency graph between components.

Output — **System Overview**:
- **Components** — each with its responsibility and key files (file:line).
- **Boundaries/interfaces** — how components interact (APIs, exports, services).
- **Data flow** — the main paths through the system, start to end.
- **Dependencies** — external + internal dependency graph.
- **Observations** — architecture-level risks noticed (coupling, dead code, missing boundaries), each with evidence.

If the argument names a focus area (e.g. `auth`, `storage`), limit the overview to that subsystem.