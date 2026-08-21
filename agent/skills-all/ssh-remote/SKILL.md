---
name: ssh-remote
description: Use SSH correctly — keys, agents, config, tunnels/port forwarding, hardening, multi-hop.
category: Shell & CLI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# SSH

## Keys & auth
- Ed25519 keys (`ssh-keygen -t ed25519`) preferred; passphrase-protected; `ssh-agent` + `ssh-add` for session (or `Keychain` integration).
- Never password auth in scripts (prompt hangs) — keys only, agent-forward where needed.
- `~/.ssh/config` is the control panel: Host blocks (`Host prod\n  HostName 10.0.1.5\n  User deploy\n  IdentityFile ~/.ssh/prod`), `ServerAliveInterval 30`, `ControlMaster` multiplexing (fast repeat connects).

## Hardening
- Disable `PermitRootLogin no`, `PasswordAuthentication no` (Keys only), `PubkeyAuthentication yes`; keep `AllowUsers`/`AllowGroups`.
- `MaxAuthTries 3`; fail2ban optional; audit `~/.ssh/authorized_keys` regularly — remove stale keys.
- Verify remote host keys once (TOFU); `ssh-keyscan` + known_hosts hygiene; never `StrictHostKeyChecking no` in prod.
- MFA: skip (not standard) — use `AuthenticationMethods "publickey"` only.

## Tunnels (the superpower)
- Local forward: `ssh -L 5432:db.internal:5432 app` — dev DB access through jump host.
- Dynamic SOCKS: `ssh -D 1080 jump` → `curl --socks5`.

- Jump/multi-hop: `-J jump` (`ProxyJump`) — cleaner than ProxyCommand chains; `ssh -J bastion app01`.
- Remote forward `-R` for inbound dev; reverse forwards (exposing localhost services to the remote) — cautious (any local listener exposed).

## Automation & scripting
- `ssh -o BatchMode=yes` (no prompts) in CI/scripts + `-o ConnectTimeout=10`; `ControlMaster=auto` for speed on loops.
- `scp`/`rsync` instead of raw scp `-v` debug; rsync `-az --delete` (danger: verify before `--delete`).
- Exit codes + `Exec` through jump host keep agent streams clean; never embed secrets in command lines (`ssh user@h 'export PASS=...'` — visible in ps).

## Incident behavior
- Suspicious login/scan → who/wtmp review, key check, firewall (`ufw allow from <ip>`), rotate keys.

## Checklist
- [ ] Ed25519 + agent; config with host blocks
- [ ] Password auth disabled; root login off
- [ ] StrictHostKeyChecking sane; known_hosts clean
- [ ] BatchMode in scripts, no prompts
- [ ] Tunnels documented + closed after use