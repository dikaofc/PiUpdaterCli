---
name: shell-script-lint
description: Review bash/zsh scripts for portability, injection risk, and exit-code correctness, with concrete fixes and verification.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); audit is read-only and does not modify scripts.
metadata:
  category: review
  tags: [shell, bash, zsh, lint, injection]
---

# Shell Script Lint
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Audit bash/zsh scripts for portability issues, command-injection hazards, and broken exit-code handling; report each finding with severity, evidence, and a suggested fix. The audit is read-only — the user applies fixes or asks for them explicitly.

## Preconditions
- Target script paths are known (or discoverable via `cap search '*.sh|*.zsh'`).
- The repository is indexed: run `cap index --refresh` first.
- The script's intended interpreter (bash vs zsh vs POSIX sh) is stated or inferred from shebang.

## Workflow
1. Run `cap status` and `cap index --refresh` to establish repo state and searchable index.
2. Locate target scripts with `cap search` (patterns: `*.sh`, `*.zsh`, `*.bash`); check shebangs with `cap show <file>` (first line).
3. For each script, read it via `cap show <file>` in chunks and check, in order:
   - Shebang/interpreter consistency; features used beyond the declared interpreter (bashisms in `sh` scripts).
   - `set -euo pipefail` (or zsh equivalents `set -euo pipefail` / `emulate -LR zsh`); missing `set -e` means unchecked failures.
   - Unquoted variable expansions in command position, `eval`, `$(...)` with user/input data, `curl | sh` patterns, and unsafe `read` usage — each is an injection case.
   - Explicit `exit` codes on failure paths; commands whose failure is silently swallowed (`cmd || true` without intent comment).
4. Record each finding: line number (from `cap show`), category (portability/injection/exit-codes), severity, and the exact offending line.
5. For suspicious dynamic execution, trace data flow with `cap explore <symbol>` if the script calls into project functions.
6. If fixes are requested, apply minimal quoting/set-flags patches, then validate with `cap lint` on the scripts and `cap verify`.
7. Run `cap diff` to show exactly what changed.

## Verification
- [ ] Every script read fully via `cap show` with line numbers recorded (no skipped chunks).
- [ ] Shebang-interpreter consistency checked per file.
- [ ] Injection scan (unquoted vars, eval, curl-pipe, unsafe read) completed per file.
- [ ] Exit-code handling (`set -euo pipefail` presence, explicit exits) checked per file.
- [ ] Findings carry line numbers and are reproducible from the cited lines.
- [ ] If fixes were applied: `cap lint` passes and `cap diff` shows only intended edits.
- [ ] `cap verify` passes when changes were made.

## Failure Handling
- If a script cannot be executed/parsed in this environment: state it, fall back to static analysis only, and mark dynamic checks as not-run.
- If a finding is ambiguous (false-positive risk): downgrade to "possible", give the counter-evidence, and let the user decide.
- If a fix request conflicts with a script's intentional behavior (no `set -e` by design): flag it and ask before patching.
- If `cap lint` has no shell support: state that and rely on the manual checklist; never claim a tool-backed pass.

## Output Format
Final report:
- Scripts audited, their shebangs, and interpreter match/mismatch.
- Findings table: file:line, category, severity, offending fragment, suggested fix.
- Injection and missing-exit-code findings listed first (highest severity).
- Verification results (`cap lint`, `cap verify`, `cap diff` if fixes applied).
- Scripts skipped and why.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap index --refresh`, `cap search`, `cap show`, `cap explore`, `cap lint`, `cap verify`, `cap diff`.