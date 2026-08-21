---
name: cli-tools
description: Master essential CLI tools — ripgrep, fzf, fd, bat, jq, tmux, htop, du, and when each beats alternatives.
category: Shell & CLI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# CLI Tools

## Search & navigate
- `rg` (ripgrep): default `rg -n pattern` (respects .gitignore, fast) — replaces `grep -r`; `rg -l` filenames only; `rg -t ts` type filter.
- `fd` (fd-find): `fd '\.ts$' src` — fast find replacement; `fd -e md -x code`.
- `fzf`: fuzzy finder — pipes: `rg --files | fzf | xargs code`; git menu; history search `history | fzf`; `CTRL-R`/`CTRL-T` hooks.
- `bat`: `bat file` = cat with syntax highlight + line numbers + git diff context.

## Data & inspection
- `jq`: JSON everywhere; `jq -r` raw strings; `jq .[].name | sort | uniq -c`.
- `du -sh * | sort -rh | head` disk hogs; `ncdu` interactive; `df -h`/`lsblk` storage.
- `htop`: CPU/mem/signal-friendly; `ps aux | sort -k3 -nr | head` CPU; `ss -tlnp` ports.
- `file` magic-type; `stat` metadata; `xxd`/`hexdump -C` bytes.

## Terminal multiplexing
- `tmux`: sessions survive ssh drops; common: `tmux new -s work`, `Ctrl-B d` detach, `tmux attach`, panes `%`/`"`. `screen` legacy alternative.
- Status-line memory, `-L` socket naming when running multiple sessions.

## Network
- `curl -I` headers, `curl -w '%{time_total}'` timing, `-sS` silent-ish errors, `--max-time`.
- `nc -zv host port` port check; `dig +short` / `nslookup` DNS; `ping`/`mtr` path.

## Discipline
- One tool per job, know its cheat sheet; prefer `-h`/`tldr` (`tldr jq`) over manpage for quick recall.
- Don't install 20 utilities — the 8 above + ssh/git/docker cover 95%.
- Safety: `--dry-run`/`-n` flags exist on `rm/clean/rsync -n` — use them.

## Checklist
- [ ] rg/fd/fzf/bat/jq installed and aliased
- [ ] tmux attached for long remote sessions
- [ ] du -sh before deleting anything big
- [ ] Curl timeouts set in scripts