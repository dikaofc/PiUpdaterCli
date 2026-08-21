# Checklist: Performance

Verification checklist for performance and resource usage.

## Unbounded Work

- [ ] No user-controlled loops/recursion/iteration without limits
  (`infinite-loop-analysis.md`, `algorithmic-complexity.md`)
- [ ] Pagination/limits on all list endpoints (`api-pagination.md`)
- [ ] Input size limits at boundaries (`boundary-validation.md`)
- [ ] No expensive operations (N+1, O(n²)) in request paths

## Resources

- [ ] No memory leaks (retained objects, closures, timers)
  (`memory-leak-analysis.md`)
- [ ] Caches bounded with eviction (`cache-analysis.md`, `caching-correctness.md`)
- [ ] Connection pools sized; no connection leaks (`connection-leak.md`)
- [ ] File descriptors closed on all paths (`file-descriptor-leak.md`)
- [ ] Disk usage bounded (temp files, logs) (`disk-exhaustion.md`)

## Concurrency

- [ ] No unbounded parallelism or thread/goroutine creation
  (`resource-exhaustion.md`)
- [ ] Locks released on all paths; no deadlocks (`deadlock-analysis.md`)

## Verification

- [ ] Load/boundary tests on changed paths (`boundary-testing.md`)
- [ ] Profiling evidence for claimed bottlenecks

## Related

- `../skills/performance/*`
- `../workflows/performance-audit.md`
