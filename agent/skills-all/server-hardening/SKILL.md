---
name: server-hardening
description: Harden servers and infrastructure — minimal install, SSH, firewall, updates, application isolation, audit.
category: DevOps
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Server Hardening

## Baseline (graybox your new/legacy box)
1. **Minimal**: reclaim suid (find `-perm -4000`), remove unused services/packages; single-purpose roles.
2. **SSH**: keys only, `PermitRootLogin no`, `PasswordAuthentication no`, `AllowUsers` list, rate-limit via fail2ban. Never run apps as root.
3. **Firewall**: default-deny (`ufw`/`nft`): allow 80/443 from anywhere, 22 from admin ranges, app ports from LB/VPC only. Deny outbound DNS except resolvers.
4. **Updates**: unattended security upgrades on + reboot policy; kernel pinned with maintenance window; audit `-l` no root access during window.

## Application isolation
- Run services as dedicated unprivileged user/group (`useradd -r app`), chroot/`systemd` sandboxing (`ProtectSystem`/`PrivateTmp`/`NoNewPrivileges`), capabilities drop `--cap-drop=ALL`.
- Containers: non-root `USER`, read-only rootfs, seccomp/apparmor default-deny, no host network/volume-write.
- Secrets: files readable only by service user (0600), env injection via systemd `EnvironmentFile`; never in image layers/process args.

## Filesystem & runtime
- Mount `/tmp` noexec+nosuid (`nofail` fstab), separate `/var` when data grows; check `df` mounts and bind strong.
- `sysctl` sane: `net.ipv4.conf.all.accept_redirects=0`, `log_martians=1`; disable unnecessary modules loading.
- Read-only mounts for binaries (`--read-only`), integrity baseline (AIDE/Samhain) optional for hardened envs.

## Audit & review
- Weekly: `last -5`, fail2ban status, `journalctl -p err`, `auditd` key changes; quarterly full reconnect review.
- Compliance tick: NIST/CIS Level 1 subset covers most infra teams' real risk fast.

## Checklist
- [ ] SSH hardened; root off; keys only
- [ ] Firewall default-deny, only needed ports
- [ ] Apps unprivileged + sandboxed
- [ ] Auto security updates on
- [ ] Audit trail (auth/priv changes) recorded