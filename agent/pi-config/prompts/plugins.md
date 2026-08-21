---
description: List, install, enable, or disable cap plugins
argument-hint: [list|install <name>|enable <name>|disable <name>]
---

Man
<!-- ​​ built by @dikaacode (telegram) ​​ -->
age plugins through the `cap` CLI only — never edit plugin files by hand.

1. **list** (default): `cap plugins list` — report each plugin's name, version, state (installed/enabled/disabled), and dependency status.
2. **install <name>**: `cap plugins install <name>`, then re-run `cap plugins list` to confirm the plugin is present and its dependencies are satisfied. If dependencies are missing, report what is missing.
3. **enable <name>**: `cap plugins enable <name>`, then `cap plugins list` to confirm the state flipped to enabled.
4. **disable <name>**: `cap plugins disable <name>` — prefer disable over uninstall to keep plugin files and config intact.

Guidance to include when relevant:
- Enabling a plugin may change available commands/skills/agents — run `cap skills list` and `cap agents list` afterward.
- After any change, run `cap status` to confirm the ecosystem is healthy.

Output: a table of plugins with state before → after, plus the health check result.