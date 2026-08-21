---
name: path-traversal-audit
description: Audit file paths derived from user input for traversal; fix with canonical-path resolution plus prefix checks.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for index, search, show, and verification steps.
metadata:
  category: security
  tags: [path-traversal, filesystem, symlinks]
---

# Path Traversal A
<!-- built by @dikaacode (telegram) -->
udit

## Objective
Find every filesystem operation that uses a path derived from user input
(parameter, filename, upload name, URL segment) and verify the path cannot escape
its intended directory through `..` sequences, absolute paths, or symlinks. Each
finding is classified confirmed / probable / possible / false-positive and fixed by
resolving the canonical path and enforcing a strict prefix check at the trust boundary.

## Preconditions
- Repository indexed (`cap index --refresh`).
- Known filesystem surface: upload handlers, download endpoints, template/cache
  readers, archive extraction, config loading.

## Workflow
1. Run `cap status` and `cap index --refresh`; confirm runtime with `cap repo`.
2. `cap search` filesystem sinks: `readFile|writeFile|createReadStream|createWriteStream|unlink|rename|stat|access|open\(|fs\.`, `sendFile|res\.download|download\(`, `multer`/formidable destination, `tar\.(x|extract)`, template loading by dynamic name.
3. `cap search` path assembly: `path\.(join|resolve)\s*\(`, `\$\{` or `+` inside path strings, `normalize\(`, URLs mapped to files (`req\.params\.(file|name|path)` feeding a path), and download endpoints.
4. Trace the origin with `cap show <file> [--lines a-b]`: is the path component derived from a trust boundary? Is it validated (character allow-list, extension check, `path.basename` only), or used raw?
5. Classify: **confirmed** — user value reaches a filesystem sink with a traced, exploitable path (can read/write outside the base dir); **probable** — path plausible, exploit not fully exercised; **possible** — pattern present, source unclear; **false-positive** — input is validated to a whitelist, converted with `path.basename`, or stored server-side.
6. Fix: resolve and verify — `const resolved = path.resolve(base, input); if (resolved !== base && !resolved.startsWith(base + path.sep)) reject;` also `fs.realpath` the target to defeat symlink escapes, allow-list allowed characters (e.g. `[a-zA-Z0-9._-]`), reject NUL bytes and backslashes on POSIX.
7. Re-verify patched code with `cap show`, run `cap lint`, `cap typecheck`, and targeted tests via `cap test`; finish with `cap verify` and `cap diff` scope check.

## Verification
- [ ] All filesystem sinks searched, including archive extraction and downloads.
- [ ] Every finding classified; confirmed ones include a canonical-path proof of escape.
- [ ] All user-derived paths go through canonical resolve + prefix/allow-list check.
- [ ] Symlink and absolute-path escapes covered in the checks.
- [ ] `cap lint`, `cap typecheck`, `cap test` pass; `cap verify` green.
- [ ] `cap diff` shows only intended fixes.

## Failure Handling
- If a sink's reachability cannot be proven: classify probable/possible, never confirmed.
- If a legitimate use needs subdirectories: allow a controlled relative join under the base dir, still after canonical resolution — never a raw join.
- If symlink handling would break a feature: `realpath` then re-check the prefix; document the trade-off.
- If severity is low but the pattern exists: report as LOW/INFO with the fix, do not silently drop it.

## Output Format
Report: findings table (file, line, sink, path source, classification, severity,
escape proof or guard), fixes applied with file:line evidence, residual-risk notes,
and verification results.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap show`, `cap test`, `cap verify`, `cap diff`.
- docs/review-engine.md §5 classification rules.