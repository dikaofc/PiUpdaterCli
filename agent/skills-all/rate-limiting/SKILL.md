---
name: rate-limiting
description: Implement rate limiting and abuse protection — per-IP/user keys, token bucket, headers, 429 handling, defense in depth.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Rate Limiting

## Where
- Reverse proxy/CDN level for brute force (nginx/Gateway/Cloudflare — cheap, scales) AND app level for business rules (per-user quota, expensive endpoints).
- Redis/in-memory counter vs proxy limits: app limits per authed user (id, not IP — VPN/NAT friends share IPs).

## Algorithm
- Token bucket (bursty-friendly) — client fairness; fixed window (simple, boundary bursts); sliding window (smooth, costlier). Pick token bucket default.
- Keys: `user:<id>:<endpoint>` or `user:<id>` global; IP fallback when unauthenticated; composite for auth endpoints.

## Response
- 429 + `Retry-After` header; optional `X-RateLimit-Limit/Remaining/Reset`; body explains human-readable ("too many requests, retry in 30s").
- Client honors 429 gracefully (backoff, no hammer); log rate-limit events with user id for abuse patterns.

## Defense in depth
- Auth endpoints stricter: login 5-10/min/user + per-IP cap; OTP/send-message endpoints rate-limited per user AND target (phone/email) — stops SMS bombing.
- Sensitive: password change, export, webhook creation — tighter + audit log.
- Long-lived: quota (per day/month) for LLM calls, storage, emails — separate from per-second burst limits.
- Not just 429: also detect patterns (same UA, burst from new IPs, headless) → challenge/block; keep threshold configurable per env.

## Checklist
- [ ] Per-user + per-IP keys where both matter
- [ ] Token bucket or sliding window impl
- [ ] 429 + Retry-After correct
- [ ] Limits on OTP/send endpoints
- [ ] Burst vs quota limits distinguished