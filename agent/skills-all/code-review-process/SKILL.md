---
name: code-review-process
description: Run effective code reviews — priorities, size discipline, review dimensions, giving/responding to feedback.
category: Productivity
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Code Review Process

## Priorities (time-box: ≤ 45 min/PR, longer = skim deeper only)
1. **Correctness** (bugs, race conditions, edge cases in the actual change path)
2. **Security** (trust-boundary handling: input, authz, secrets, injection)
3. **Behavior change risk** (breaking API/cache/DB semantics, rollback safety)
4. **Maintainability** (naming, dead code, structure) — lowest urgency, flag not block

## Review dimensions (quick pass each)
- Does the change do what the description says (and nothing extra — scope creep blocks)?
- Edge cases: empty/null/boundary/concurrency/time — where's the error path, and is it handled?
- Is this the *right layer* (validation at boundary, logic in domain, not UI)?
- Tests: do they cover the failure mode, not just the happy path?
- No unrelated refactors hidden in the diff (reviewer's #1 silent cost).

## Size discipline
- PRs < 300 lines reviewable properly; > 500 → split (or flag + timebox). Rename/refactor PRs separate from behavior PRs.
- Small, frequent reviews beat one marathon: reviewing daily in 10-min slices catches more.

## Feedback mechanics
- Ask, don't demand: "Could we...?", "What if the user...?" — propose alternatives with reasoning; distinguish nit vs must (labels help: `nit`/`should`/`block`).
- Praise good patterns explicitly (reviews are also teaching + reinforcement).
- Respond promptly to review comments; push fixes as follow-up commits (keep history readable for reviewer); disagree constructively — data/examples over authority.
- Ship small wins first: green-lighting 60% with nits lets progress flow; block only on actual defects.

## Tooling that helps
- CI on PR = first reviewer (lint/type/tests/vuln); require it green before human pass.
- Review diff (not full files): `git diff main...branch`; check what actually changed.

## Checklist
- [ ] Scope = description; no hidden refactors
- [ ] Error paths + boundaries reviewed
- [ ] Security scan on trust-boundary changes
- [ ] Feedback concrete; nit vs block separated
- [ ] Tests cover failure mode