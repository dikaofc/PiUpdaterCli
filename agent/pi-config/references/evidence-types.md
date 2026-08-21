# Reference: Evidence Types

Catalog of evidence artifacts and how strong each is (see
`../context/evidence-model.md` for the E0–E5 ladder).

## Strong Evidence (E3+)

- **Failing test** — a minimal test that demonstrates the unexpected behavior with
  an exact assertion. The strongest single artifact.
- **Controlled request/response** — against a local or mocked service, showing the
  behavior (status, body, side effect).
- **Minimal reproduction script** — deterministic steps + observed output.
- **Trace/log from controlled run** — application-level evidence of the path
  executing (with sensitive data redacted).
- **Root-cause validation** — same reproduction passes after the minimal fix
  (E5).

## Medium Evidence (E2)

- **Complete data-flow trace** — source → transformations → validation →
  authorization → sink with file:line citations.
- **Call graph path** — demonstrating reachability from an entry point
  (`skills/static-analysis/call-graph-analysis.md`).
- **Manifest/lockfile chain** — dependency installed, included, imported, and
  used (all four verified).

## Weak Evidence (E1)

- Keyword/pattern match without a completed trace.
- Scanner output without validation.
- "Old" dependency without reachability analysis.
- Suspicious configuration without behavior confirmation.

## Not Evidence (E0)

- Similar findings from other projects.
- Code review vibes.
- An assumption that a check is missing without reading the code path.

## Rules for Attaching Evidence

- Each artifact must include enough context to re-verify: file path, version,
  command, input, output.
- Redact secrets before attaching artifacts.
- State what was NOT verified (`UNKNOWN`) next to what was.

## Related

- `../context/evidence-model.md`
- `../skills/reporting/confidence-assessment.md`
