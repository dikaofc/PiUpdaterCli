# Workflow: Incident Debugging

## Purpose

Debug a reported incident (crash, outage, data corruption, security event,
mysterious behavior) from symptom to root cause to verified fix. Prioritizes speed
and evidence discipline under pressure.

## Method

### 1. Capture the Symptom (before anything else)

- Exact error message / stack trace / observable behavior, with timestamp and
  version.
- Request/response or event that triggered it (sanitized).
- Logs around the incident (application, access, error, audit).
- Environment facts: version, config, deployment, traffic level.

### 2. Reproduce

- Try to reproduce deterministically in the local environment with fixtures.
- If not reproducible, build the most faithful reproduction (same version, same
  config, captured input, mocks for missing pieces).
- Record the reproduction steps — they become the regression test.

### 3. Hypothesize & Isolate

- Form 2–4 concrete hypotheses tied to the evidence.
- Use binary search / bisection: git bisect the change, toggle config, isolate the
  subsystem.
- Confirm the hypothesis with a controlled test before accepting it
  (`../context/evidence-model.md` E3+).

### 4. Root Cause

- Identify the defective implementation (E5): the wrong assumption, missing check,
  ordering, or invariant.
- Check adjacent paths for the same defect.

### 5. Fix & Verify

- Minimal fix per fixing mode (`../METHODOLOGY.md`).
- Add the reproduction as a regression test.
- Verify no regressions (relevant suites, type checks).

### 6. Post-Incident

- Write `../templates/root-cause-analysis.md` and the finding report.
- Update threat model/checklists if the incident reveals a coverage gap.
- Update `../CHANGELOG.md` for knowledge-base changes.

## Rules

- Never modify production state as a debugging step without authorization.
- Never delete evidence to "clean up"; archive it.
- Do not skip reproduction because the fix "looks obvious" — the reproduction is
  what prevents recurrence.

## Related

- `../templates/root-cause-analysis.md`
- `../skills/errors/exception-analysis.md`
- `../skills/dynamic-analysis/dynamic-behavior-analysis.md`
- `../skills/testing/reproduction-test-design.md`
