# Language Guide: JavaScript

Security and correctness analysis notes for JavaScript (Node.js backend, browsers,
tooling).

## Dangerous APIs

- `eval`, `new Function`, `Function()`, `vm.runIn*` — code injection
  (`skills/injection/code-injection.md`).
- `child_process.exec`/`spawn` with shell strings — command injection
  (`command-injection.md`); prefer `execFile`/`spawn` with argv arrays.
- `fs` operations with user-influenced paths — traversal (`path-traversal.md`).
- `innerHTML`, `document.write`, `outerHTML`, `insertAdjacentHTML` — DOM XSS
  (`dom-xss.md`); `javascript:` URLs.
- `JSON.parse` on untrusted data — safe parsing (bomb risk, prototype pollution
  via `__proto__` in merge utilities).
- `setTimeout`/`setInterval` with string arguments — code execution.
- `Buffer.from(..., 'base64')` misuse; `querystring`/`URLSearchParams` parsing
  pitfalls (HPP).

## Common Mistakes

- `==` loose equality, truthiness of `"0"`/`[]`/`{}` — type-confusion logic
  (`type-confusion.md`).
- Prototype pollution from shallow merges of untrusted objects
  (`mass-assignment.md`, `parser-security.md`).
- Async races: `await` inside loops, shared mutable state between requests
  (`async-state-analysis.md`, `race-condition.md`).
- Callback/promise error swallowing → silent failures (`exception-analysis.md`).
- Integer coercion: `Number("1e999")`, `parseInt` bases, `-0`, `NaN`
  (`boundary-validation.md`).
- Regex denial of service (ReDoS) on user input (`cpu-exhaustion.md`,
  `algorithmic-complexity.md`).

## Input Handling

- Validate types/shapes at boundaries (`schema-validation.md`); reject unknown
  keys; watch `Object.prototype` access patterns.
- Normalize unicode before checks (`unicode-handling.md`); canonicalize URLs
  (`url-validation.md`).

## Filesystem / Networking

- Path resolution with `path.resolve`/`path.join` still allows `..` if base
  prefix is only textual — canonicalize with `realpath` and verify containment.
- Server-Side Request Forgery via `http`/`https`/`fetch` to user URLs
  (`ssrf-analysis.md`); set timeouts.

## Database

- Parameterized queries via drivers/ORM (e.g., pg `$1`, mysql `?`, Knex/Prisma
  bindings); never template-string queries (`query-safety.md`).
- NoSQL injection in MongoDB operators (`nosql-injection.md`).

## Serialization

- `JSON.stringify`/`parse` — check depth/size limits; `node-serialize`,
  `vm`-based eval deserialization — unsafe (`deserialization-analysis.md`).

## Concurrency

- Single-threaded event loop: sync blocking work exhausts availability
  (`cpu-exhaustion.md`); worker threads/child processes need resource bounds.
- Shared memory via closures/modules across async requests is per-process global —
  audit for cross-request state (`concurrent-state.md`).

## Authentication / Errors / Dependencies

- JWT via `jsonwebtoken`: verify algorithm allow-list, expiry, audience
  (`jwt-analysis.md`).
- Error objects can carry stack traces — strip before client response
  (`stack-trace-exposure.md`).
- npm: lockfile + `npm audit`; integrity hashes; scope confusion
  (`dependency-confusion.md`, `package-integrity.md`).

## Testing

- Node `node:test`, Jest/Vitest/Mocha; property testing with fast-check;
  fuzzing with `jsfuzz`/`jazzer.js` (`fuzzing-strategy.md`).

## Related

- `../skills/frontend/*`, `../skills/backend/*`
- `../skills/injection/*`
