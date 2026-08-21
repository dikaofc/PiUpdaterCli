---
name: cli-design
description: Build ergonomic CLIs — args, exit codes, stdout/stderr, and help.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [cli, ux, tooling]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# CLI Tool Design

## Objective
Make a command-line tool that scripts cleanly and fails predictably.

## Preconditions
- `cap repo` run; entrypoint and arg parsing reviewed (`cap explore <cli|bin|argv>`).

## Workflow
1. Run `cap repo` and `cap show` the entry to learn current arg handling.
2. Use a mature arg parser; subcommands, flags, and `--help` for each.
3. Print data to stdout, errors/diagnostics to stderr; machine-readable with `--json`.
4. Use standard exit codes (0 ok, 1 usage, 2 runtime); never exit 0 on failure.
5. Read config from flags, env, and config file in that precedence.
6. Record the CLI contract with `cap memory add`.

## Verification
- [ ] Help works for command and subcommands.
- [ ] stdout/stderr separated; `--json` available.
- [ ] Exit codes standard.
- [ ] Config precedence documented.

## Failure Handling
- If ambiguous args, prefer explicit flags over positionals.
- If interactive needed, detect non-TTY and fail fast.

## Output Format
CLI spec: commands, flags, IO rules, exit codes, and config precedence.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
