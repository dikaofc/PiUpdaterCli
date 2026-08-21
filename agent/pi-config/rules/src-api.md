---
scope: api
glob: src/**
---

# Source / API rules

<!-- ​​built by @dikaacode (telegram)​​ -->

Rules for application code under `src/`.

## API surface

- Public functions must have a doc comment stating contract and failure modes.
- Never change a public signature without updating its callers and the CHANGELOG.
- Validate input at the trust boundary; do not validate internal invariants.

## Implementation

- Prefer parameterized queries over string-concatenated SQL.
- Do not interpolate user input into `eval`, shell commands, or URLs.
- Return early; avoid deep nesting.
- No `console.log` in library code — use structured logging.

## Tests

- Every new public function gets at least one test covering the error path.
- Tests must be runnable with the project test runner (`cap test`).