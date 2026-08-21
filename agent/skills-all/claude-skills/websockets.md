---
name: websockets
description: Build reliable realtime channels with reconnect, heartbeat, and auth.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [websocket, realtime, events]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Realtime / WebSockets

## Objective
Provide a realtime connection that survives blips and stays authorized.

## Preconditions
- `cap repo` run; transport and gateway reviewed (`cap explore <ws|socket|realtime>`).

## Workflow
1. Run `cap explore` for the socket handler and auth middleware.
2. Authenticate the upgrade request; reject unauthenticated connections.
3. Add heartbeat/ping-pong to detect dead connections and free resources.
4. Implement client reconnect with backoff + jitter and last-event resync.
5. Cap concurrent connections and message size; reject oversized frames.
6. Record channel/auth rules with `cap memory add`.

## Verification
- [ ] Upgrade authenticated.
- [ ] Heartbeat prunes dead sockets.
- [ ] Client reconnects with backoff.
- [ ] Connection/size limits enforced.

## Failure Handling
- If messages lost on reconnect, add sequence + resync.
- If fan-out explodes, shard rooms.

## Output Format
Realtime design: auth, heartbeat, reconnect, limits, and resync strategy.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
