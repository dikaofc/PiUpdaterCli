---
name: file-system-ops
description: Safe filesystem operations — find/rm/mv safety, symlinks, permissions, archive/compress, disk space checks.
category: Shell & CLI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# File System Operations

## Safety-first ops (destructive)
- **`rm`**: preview first (`ls`/`find -name` dry), `rm -i` interactive, `--` after globs; never `rm -rf /`-style paths from user input; `rm` inside scripts: guard the variable (`[[ -n "$DIR" && "$DIR" != "/" ]]`).
- **Move/rename**: `mv` overwrites silently — `-n` to no-clobber when unsure; check target exists (`test -e "$dst"`).
- **Find+delete**: `find . -name '*.tmp' -delete` — always run the `-print` version first, confirm list, then repeat with `-delete`. `-print0` only with `-exec` pairing.
- **Multi-user races**: `mkdir -p` idempotent; file creation `touch`/heredoc with O_EXCL semantics via `set -C` (noclobber) if needed.

## Permissions & ownership
- `chmod`: 644 files / 755 dirs default; exec bits only where binary logic needs; `chmod -R a+rX` for web-accessible dirs (capital X = dirs only).
- `chown user:group` deliberate — never `chown -R` on shared dirs without listing affected users.
- `umask 022` sanity; ACLs (`setfacl`) for project-shared dirs, not blanket 777.

## Symlinks & hardlinks
- `ln -s` targets absolute (relative breaks on copy); dangling links = runtime errors — check `readlink -f`; `find . -type l ! -exec test -e {} \; -print` lists dangling.
- Never `rm -rf` a dir containing a symlink to elsewhere (follows into target on some ops — `rm` doesn't follow, `cp -r`/`tar` might).

## Archive & compress
- `tar czf` vs `tar czf - dir | gzip` streaming; **`tar -t` list test before extract** (archive bombs / wrong content); `tar xzf --strip-components=1` for flattening reused repos.
- `zip -r` predictable; `--exclude` caches; sanity `--test` on zip that matters.
- Verify extraction checksum for downloaded artifacts (`sha256sum -c`).

## Disk & quota checks
- Pre-op: `df -h mountpoint` free space; `du -sh` before archive; delete-in-chunks when freeing (space released immediately, not deferred).

## Checklist
- [ ] Destructive ops: preview → confirm → execute
- [ ] Guards on script vars (`[[ $p =~ ... ]]`, not-"/" checks)
- [ ] Permissions 644/755 sane; no blanket 777
- [ ] Tar/zip test-listed before extraction
- [ ] Disk space checked before big writes