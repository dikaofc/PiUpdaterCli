---
name: shell-command-patterns
description: Compose shell one-liners and pipelines — awk, sed, jq, grep, find, xargs, sorting, streaming. Use for data munging, log analysis, quick scripting.
category: Shell & CLI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Shell Command Patterns

## Workhorses
- **Text filter/extract**: `grep -E` patterns or `rg` (ripgrep, faster, better defaults: `rg -n 'pat' dir`); `sed -n '5,9p'` line slices; `sed -E 's/pat/repl/g'` transforms.
- **Column/csv-ish**: `awk -F, '{print $1, $3}'`; `sort` + `uniq -c | sort -rn` frequency tables; `cut -d' ' -f2` fixed columns.
- **JSON**: `jq '.items[] | select(.price > 10) | {name, price}'` — never parse JSON with grep/sed/awk.
- **Find**: `find dir -name '*.log' -mtime -7 -size +1M` then `-exec` / `xargs -0`; `-print0 | xargs -0` handles spaces (asked-for robustness).
- **Parallel**: `xargs -P 8 -n 1` for repeated commands; `seq | xargs -P` map-parallel.

## Patterns worth stealing
- Count occurrences: `grep -o 'pat' file | wc -l`.
- Top list: `sort -k2 -nr file | head`.
- Dedupe keep-first: `sort -u`; keep-last with sort -k with awk associative.
- In-place backup edit: `sed -i.bak 's/old/new/' file` (backup then `-i` alone).
- Loop file-safe: `while IFS= read -r f; do ...; done < list.txt`; `find ... -print0 | while IFS= read -r -d '' f`.
- Sum column: `awk '{s+=$1} END {print s}'`.
- Stream tail-follow + filter: `tail -F app.log | rg 'ERROR'`.

## Safety rules
- Pipe through `head` early in huge streams (avoids full consumption).
- Quote globs always (`"$var"`); `--` to end options (`rm -- "$f"`).
- Delimiter discipline: use comma/tab not spaces in data (awk defaults bite).
- `set -o pipefail` in scripts using pipes (see `bash-scripting`).
- Preview before destructive: replace `rm`/`mv` with `ls`/`echo` in dry-run, then execute.

## Checklist
- [ ] jq for JSON, awk for columns, never grep-parsing
- [ ] -print0/xargs -0 for filenames with spaces
- [ ] head-bounded huge streams
- [ ] Dry-run preview on destructive ops