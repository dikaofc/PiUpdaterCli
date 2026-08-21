---
name: termux-android
description: Develop and automate on Termux/Android — package install, storage permissions, scripts, SSH, cron, native android gotchas.
category: Shell & CLI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Termux (Android)

## Environment basics
- Packages: `pkg install <name>` (apt repos, no sudo — all user-space); update first `pkg update && pkg upgrade`.
- Storage: `termux-setup-storage` grants `~/storage/{shared,downloads,dcim}` (Android scoped storage) — files under `$HOME` are app-private.
- Termux runs without root; `sudo`/`proot-distro` (full distros) only for special cases — prefer native packages.
- API: `termux-api` package — battery, clipboard, notifications, SMS, location via `termux-*` commands + `termux-notification-listener` for automation triggers.

## Dev stack (typical)
- Node: `pkg install nodejs-lts` (or `nodejs` には build-essential + prebuilt binaries; `nodejs-lts` safer).
- Python: `pkg install python`; pip with `python -m pip` — some wheels need `pkg install clang` for compiling.
- Git/SSH: `pkg install git openssh` — `ssh-keygen` then add key to GitHub; mirrors: `termux-change-repo` pick faster mirrors in your region.
- Editors: `pkg install python vim`; VS Code remote over `code-server` (`pkg install code-server`) or `termux:open --vscode`-style integrations.

## Gotchas
- **No root**: nothing works with su/bash that requires elevation — design around user-space.
- Android kills background processes: `termux-wake-lock` for long-running jobs; foreground notification keeps sessions alive.
- File paths: Android `/data/data/com.termux/files/home` IS `$HOME` (not `/home/...`) — absolute paths in scripts must use `$HOME`.
- Locale/crypto: `pkg install gnupg` for signing; `termux-fix-shebang` after moving scripts between systems.
- Networking: localhost only inbound (port 8080 bind shows on-device only); `termux-wifi-enable` + `-api` for hardware controls.
- Update cadence: Android platform updates can break Termux — keep `pkg upgrade` current.

## Automation patterns
- Cron: `pkg install cronie` + `crond` start (see `cron-scheduling`).
- Scripts referencing Android intent: `termux-open-url`, `termux-share`, `termux-download`.
- Backups: `tar czf ~/storage/shared/termux-backup.tgz $HOME` (exclude .cache), restore with `termux-setup-storage` first.

## Checklist
- [ ] pkg updated; mirrors chosen
- [ ] storage permission mapped
- [ ] wake-lock for long jobs
- [ ] Absolute paths via $HOME
- [ ] Backup script scheduled