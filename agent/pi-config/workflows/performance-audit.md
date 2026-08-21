# Workflow: Performance Audit

## Purpose

Audit performance and reliability: resource exhaustion, leaks, unbounded work,
bottlenecks, and availability risks — treated as first-class defects (availability
is impact).

## Method

### 1. Profile the Surface

- Identify request/processing paths with user-controlled cost drivers: input size,
  iteration counts, recursion, pagination depth, concurrency
  (`skills/performance/algorithmic-complexity.md`).
- List background/worker/queue paths (`backend/background-job-security.md`,
  `queue-security.md`).

### 2. Resource Analysis

- Memory: leaks, unbounded caches, large allocations per request
  (`memory-leak-analysis.md`, `cache-analysis.md`).
- CPU: expensive operations per request, O(n²) loops, regex backtracking, sync
  work in async paths (`cpu-exhaustion.md`).
- Disk: unbounded writes, log growth, temp file leaks (`disk-exhaustion.md`).
- Connections: pool exhaustion, leaked connections, missing close
  (`connection-leak.md`).
- File descriptors: leaks in file/stream handling (`file-descriptor-leak.md`).
- Loops/recursion: infinite or unbounded (`infinite-loop-analysis.md`).

### 3. Concurrency & Caching

- Contention, lock holding, deadlocks (`concurrency/deadlock-analysis.md`).
- Cache correctness and stampedes (`performance/caching-correctness.md`).

### 4. Load & Boundary Testing

- Boundary tests at limits (max payload, max page size, max concurrency)
  (`skills/testing/boundary-testing.md`).
- Reproduce exhaustion candidates with controlled load on local instances.

### 5. Report

- Availability impact rated per severity model (availability is impact).
- Remediation: bounded loops, pooling, backpressure, limits, caching strategy.
- Regression tests: resource-bound assertions (e.g., "1000 concurrent requests do
  not grow heap unboundedly").

## Related

- `../skills/performance/*` (10 skills)
- `../checklists/performance.md`, `../checklists/reliability.md`
- `../skills/testing/boundary-testing.md`
