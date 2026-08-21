# .claude — Claude Coding Agent Platform

<!-- ​​built by @dikaacode (telegram)​​ -->

Every agent-facing artifact of the platform lives under `.claude/`. The `cap`
CLI keeps this directory tidy: `cap init` scaffolds it, `cap plugins` manages
the registry, `cap rules`/`cap hooks`/`cap memory`/`cap task` operate on the
policy and state stores.

## Layout

| Path | Purpose |
|---|---|
| `settings.json` | Cap CLI config: approval mode, command policy, token economy |
| `plugins/` | Plugin registry: `<name>/plugin.json` + `README.md` |
| `skills/` | Structured workflows: `<name>/SKILL.md` |
| `commands/` | Slash-commands for the host: `<name>.md` |
| `agents/` | Specialist agents: `<name>.md` |
| `hooks/` | Lifecycle hooks: `<event>.md` (declarative, run by the host) |
| `rules/` | Evaluation rules: `<name>.md` with frontmatter `glob` |
| `state/` | Runtime state: `plugins.json`, `memory.json`, `tasks/*.json` |
| `cache/` | Derived artifacts: `index.json` (from `cap index`) |