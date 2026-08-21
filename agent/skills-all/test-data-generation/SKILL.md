---
name: test-data-generation
description: Generate realistic test data — factories, fakers, anonymized prod data, deterministic ids, boundary datasets.
category: Testing
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Test Data Generation

## Factory vs fixture
- **Factories** (`factory-bot`/`faker`-style builders) — per-test variation, defaults sane: `User.make({role: 'admin'})`; fill required fields via helpers, optional ones via random.
- Fixtures (static JSON) for stable expected-output tests — keep small, versioned.
- Never hardcode 50-line objects inline in tests — builders keep intent visible.

## Realistic values
- Faker locales per product region (names, addresses), `faker` seeded per test for determinism (seeded → reproducible failures).
- Money: cents integers + fixture floats; dates: relative-to-now (`createdAt: daysAgo(3)`) not absolute strings (age assertions stay true).
- Boundary sets: empty list, one item, max page size+1, unicode names, 255-char strings, nulls vs absent.

## Anonymization (prod data to dev/test)
- Replace PII deterministically: `anon(s) = hash(s) + faker.name(s)` (same input → same output across runs), drop tokens/credit-cards entirely (replace with test cards), strip access logs of emails.
- Scope: production snapshots need DPA/approval + deletion cadence — treat as sensitive.

## Per-environment strategy
- Unit: factories in-memory. Integration: seeded DB with 100-1000 rows incl. adversarial records (expired session, deleted user FK, soft-deleted).
- E2E: minimal data via API; heavy datasets via direct DB seed scripts run in `beforeAll`.

## Deterministic vs random
- Random catches shape bugs; seeded determinism lets you replay failure → choose seed-per-suite (`faker.seed(42)` + counter).
- Randomizing ids: never `1`/`abc` — generate unique (`crypto.randomUUID`) to catch accidental id-collision assumptions.

## Checklist
- [ ] Factories for entities; fixtures only for expected-output
- [ ] Seeded faker; dates relative
- [ ] Boundary sets in every data shape
- [ ] Prod data anonymized (hash-deterministic) + approved
- [ ] Unique ids everywhere