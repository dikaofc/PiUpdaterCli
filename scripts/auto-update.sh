#!/bin/sh
# auto-update — keep PiUpdaterCli + pi agent in sync, non-interactively.
#
# WHY: update.sh re-applies dist patches + re-merges pack files, but it
# only runs when you remember to call it. This script is the cron target:
# git pull the latest pack, then run update.sh. Safe to call unattended
# (update.sh is idempotent and zero-config).
#
# USAGE:
#   scripts/auto-update.sh
# Scheduled via Termux job scheduler (see install.sh --schedule):
#   termux-job-scheduler -s scripts/auto-update.sh --period-ms 21600000
#   (21600000ms = 6h; Android enforces a 900000ms / 15min minimum)

set -e
PACK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$PACK_DIR/auto-update.log"

log() { printf '%s  %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOG" 2>/dev/null || true; }

log "=== auto-update start ==="

# 1. Pull latest pack (non-fatal if offline / no remote).
if [ -d "$PACK_DIR/.git" ]; then
	( cd "$PACK_DIR" && git pull --ff-only >> "$LOG" 2>&1 ) || log "git pull skipped (offline or diverged)"
fi

# 2. Re-sync pack files + dist patches + pi upgrade.
if [ -x "$PACK_DIR/update.sh" ]; then
	( cd "$PACK_DIR" && ./update.sh >> "$LOG" 2>&1 ) && log "update.sh OK" || log "update.sh failed (see above)"
else
	log "update.sh not found — skipping"
fi

log "=== auto-update done ==="
