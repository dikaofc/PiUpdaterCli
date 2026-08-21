# Language Guide: TypeScript

Security and correctness analysis notes for TypeScript.

## Dangerous APIs

Same dangerous API set as JavaScript (eval, child_process, DOM sinks, fs paths),
with additional risk from **compile-time-only safety**: types are erased at
runtime and never validate data.

## Common Mistakes

- **Type assertions as validation.** `as User`, `as number`, `!` non-null
  assertions do not check anything at runtime (`type-confusion.md`,
  `schema-validation.md`). Untrusted JSON passed as a typed object is still
  untrusted.
- **`any`/`unknown` misuse.** `any` disables checking entirely; unknown values
  must be validated with runtime guards (zod, io-ts, class-validator, hand-rolled
  guards) before use.
- **`enum` and `const enum` edge cases:** numeric enums accept out-of-range
  values at runtime.
- **Structural typing surprises:** excess property checks are bypassed by
  intermediate variables; validated-at-API shapes are not validated at service
  layer by default.
- `@ts-ignore`/`@ts-expect-error` hiding real problems.
- Template literal types and string patterns used as validation (types are
  compile-time only).

## Input Handling

- Runtime validation at every trust boundary: parse → validate schema → then use
  typed object. Libraries: zod, io-ts, ajv, class-validator
  (`schema-validation.md`).

## Filesystem / Networking / DB / Serialization

- Same as JavaScript (`languages/javascript.md`); note `node:` prefix imports do
  not change security semantics.
- ORMs with type-safe query builders (Prisma, TypeORM, Drizzle) still require
  parameterization; raw query escapes exist and bypass safety
  (`orm-security.md`, `query-safety.md`).
- `JSON.parse` results remain untrusted regardless of the declared return type.

## Concurrency

- Same event-loop model as JS; async races and shared module state
  (`async-state-analysis.md`).

## Authentication / Errors / Dependencies

- JWT libs (jsonwebtoken, jose): validate `algorithms` list explicitly
  (`jwt-analysis.md`).
- Errors: typed errors should not leak internal shapes; strip stacks
  (`stack-trace-exposure.md`).
- npm/ts ecosystem: `npm audit`, lockfile integrity, dependency confusion
  (`dependencies/*`).

## Testing

- Vitest/Jest with `tsx`/SWC; property testing (fast-check); type-level tests
  (`expect-type`) for API contracts; fuzzing via `jazzer.js`
  (`testing/*`).

## Language-Specific Pitfalls

- Compiler `noUncheckedIndexedAccess` off → implicit `undefined` on index access
  (`boundary-validation.md`).
- Decorator-based validation (class-validator) skipped when DTOs bypassed
  (e.g., raw body passed to service) (`api-input-boundaries.md`).

## Related

- `../languages/javascript.md`
- `../skills/input-validation/*`, `../skills/backend/*`
