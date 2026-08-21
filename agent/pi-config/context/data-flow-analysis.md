# Data-Flow Analysis

Data-flow analysis is the core technique for validating (or killing) a finding
candidate: trace data from its source through transformations, validation, and
authorization to the sensitive sink, recording the trust level at every step.

## The Canonical Path

```
SOURCE → TRANSFORMATION → VALIDATION → AUTHORIZATION → SINK
```

## Elements to Record for Each Path

- **Source** — where the data originates (request parameter, header, body, cookie,
  file, URL, external API, queue message, env var, CLI arg).
- **Origin** — the trust level of the source (untrusted client, authenticated user,
  tenant user, internal service, admin).
- **Trust level** — re-evaluate after every boundary crossing.
- **Transformations** — parsing, decoding, unquoting, casting, normalization,
  concatenation, formatting. Each transformation may create or remove an
  interpretation risk (e.g., double-encoding).
- **Validation** — what checks exist: type, length, format, allow-list, pattern;
  where they run; whether they run before every use.
- **Sanitization** — removal of dangerous content (stripping, escaping), and whether
  it is context-appropriate.
- **Encoding** — output-boundary encoding at the sink (HTML-encode, parameterized
  query, shell escaping) and whether the sink respects it.
- **Authorization** — server-side check that the caller may perform this operation
  on this object.
- **Sink** — the sensitive operation reached (query, exec, file, render, network,
  deserialize, crypto, privilege change, payment, state change).
- **Resulting behavior** — what actually happens when the path executes.

## Method

1. Pick a suspicious sink; find every source that can reach it (backward scan).
2. Pick a suspicious source; find every sink it can reach (forward scan).
3. For each (source, sink) pair, fill in the elements above. Mark gaps `UNKNOWN`.
4. If validation/encoding/authorization exists downstream, the candidate may be a
   false positive (`false-positive-model.md`).
5. If a gap exists, escalate to behavioral evidence: write a controlled test that
   exercises the path (E3).
6. Only then classify (E4/E5) and rate severity.

## Common Errors

- Analyzing the source and sink in isolation without the middle of the path.
- Assuming validation exists because a framework is present.
- Assuming encoding applies because an output function name sounds safe.
- Treating authorization at the route level as authorization at the object level.

## Output

For each finding: a Data Flow section (source → transformations → sink) with trust
levels and controls per step, as in `templates/vulnerability-report.md`.

## Related

- `../SECURITY_BOUNDARIES.md`
- `../context/trust-boundaries.md`
- `../skills/static-analysis/taint-analysis.md`
- `../skills/reconnaissance/data-flow-discovery.md`
- `../skills/static-analysis/data-flow-analysis.md`
