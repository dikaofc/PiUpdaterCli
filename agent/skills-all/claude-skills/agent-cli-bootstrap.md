---
name: agent-cli-bootstrap
description: Bootstrap a working session on ANY agent CLI — probe available tools (git, npm, language toolchains, cap), record facts to memory or a .claude-state file, and choose the default tool layer for the session.
license: MIT
compatibility: Works on any agent CLI with bash/file access. No tool is assumed present; every probe produces a recorded fact. The `cap` CLI is OPTIONAL.
metadata:
  category: productivity
  tags: [bootstrap, environment-probe, tool-agnostic]
---

<!-- built by @dikaacode (telegram) -->

# Agent CLI Bootstrap

## Objective
Start any repo session from a clean slate on an unfamiliar agent CLI: detect which tools are actually available, persist those facts, and pick the tool layer to use for the whole session — universal (bash/git) by default, upgraded to `cap` only when present.

## Preconditions
- The repository path is known and the session has bash/file access.
- No tool is assumed: `cap`, `git`, and language toolchains must each be probed.
- Memory, if the CLI has one, may be used — otherwise `.claude-state` is the fallback record.

## Workflow
1. **Probe factually** — each probe returns a concrete fact, no guesses:
   - `command -v git && git --version` (git present?)
   - `command -v npm node && node --version && npm --version` (JS toolchain?)
   - `command -v cargo rustc && rustc --version`, `command -v go && go version`, `command -v python3 && python3 --version` (other toolchains, as the repo implies)
   - `command -v cap && cap --version` (optional capability layer?)
   - `command -v tsc eslint jest pytest` as the repo's implied runner set hints at (probe lazily, only candidates the repo shape suggests).
2. **Inspect the repo shape**: `git status --short`, `git log --oneline -5`, `ls`; confirm manifest files (`package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`) to know the real toolchain.
3. **Record facts**: write one fact per line into the CLI's memory (e.g. `cap memory add`) if available; otherwise append to `.claude-state` (later add it to `.gitignore`). Facts: tools present, versions, toolchain manifest, chosen layer.
4. **Choose the tool layer**:
   - If `cap` is present and the repo is indexed: layer = cap (with universal fallbacks always usable).
   - Otherwise: layer = universal (read/write/edit/git) with no capability loss mentioned as a blocker.
5. **Document the capability set** in the session output: what was probed, what exists, what is absent, and why the chosen layer is right.
6. Re-probe cheaply whenever suspicion of drift: a missing `node_modules` or changed manifest may invalidate previous facts.

## Verification
- [ ] Every probe result shown as evidence (command + captured output), not inferred.
- [ ] Facts persisted: memory entry or `.claude-state` line per fact.
- [ ] Chosen layer justified: cap only if `command -v cap` succeeded; universal otherwise.
- [ ] Absence reported explicitly (e.g. "no test runner present") so later skills never assume it.

## Failure Handling
- If a probe command is missing (no `command -v` hit): record "absent", do not treat as error, and skip its dependent step.
- If the CLI has no memory and `.claude-state` write fails: continue in-memory and note the limitation in the report.
- If the repo is not a git repo: offer `git init` if the user consents; otherwise run in non-git mode and state it.
- If cap exists but the repo is unindexed: fall back to universal until an index is available; do not block the session on cap.

## Output Format
Bootstrap report: environment facts (tool + version per line), manifest/toolchain identity, chosen tool layer with reason, absent tools explicitly listed, and a pointer to the persisted fact record.

## References
- CONTRACT.md §1 Tool Layer.
- Agent notes: agent-cli-universal (discipline over the chosen layer), agent-cli-report (report format).
- Companion skills: [[agent-cli-universal]], [[agent-cli-report]].