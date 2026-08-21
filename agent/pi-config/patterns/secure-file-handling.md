# Pattern: Secure File Handling

## Problem

File uploads, downloads, and processing must not enable traversal, arbitrary code,
parser abuse, or resource exhaustion.

## Design

1. **Path canonicalization.** Resolve and verify every user-influenced path stays
   inside an allow-listed base directory; reject absolute paths, `..`, symlinks
   escaping the base (`skills/files/path-traversal.md`).
2. **Upload validation:** server-side content-type + magic-byte checks, size
   limits, filename sanitization (generate server-side names), storage outside the
   web root, no executable extensions served (`file-upload-security.md`).
3. **Safe download serving:** Content-Disposition, correct Content-Type, no path
   control by clients (`file-download-security.md`).
4. **Archive safety:** member count/size limits, path validation per member, no
   zip-slip (`archive-processing.md`).
5. **Parser safety:** size limits, depth limits, timeout on parsing, use safe
   parser options (no external entities for XML) (`parser-security.md`,
   `xml-security.md`).
6. **Storage:** object storage with private-by-default buckets and signed URLs
   (`cloud-storage-security.md`).

## Verify

- Boundary tests: oversized files, nested archives, traversal names, crafted
  headers; negative tests that files are never written outside the base dir.

## Anti-Patterns

- Client-supplied filenames used in paths; `eval`-like processing of uploads;
  trusting content-type header; unbounded decompression.

## Related

- `../skills/files/*`
- `../checklists/backend.md`
