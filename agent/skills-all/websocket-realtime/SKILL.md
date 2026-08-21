---
name: websocket-realtime
description: Build realtime features — WebSocket/SSE choice, auth, heartbeats, reconnection, scaling, message protocol.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Realtime (WebSocket / SSE)

## Protocol choice
- **WebSocket**: bidirectional full-duplex (chat, multiplayer, live cursors). 
- **SSE** (EventSource): one-way server→client pushes, auto-reconnect built-in, HTTP/2 friendly (chats-notifications, dashboards, streams). Simpler + more robust; use when client never sends events.
- Long-polling: legacy fallback only.

## Auth & handshake
- Upgrade request carries token (`?token=`/cookie/`Authorization` — Sec-WebSocket-Protocol trick) — validate BEFORE accepting; never upgrade unauthenticated.
- Re-auth per reconnection; subscriptions declared on connect (`{"type":"sub","topic":"room:42"}`); server enforces permission per topic (not client-side filtering — IDOR via subscribe = leak).
- Session state: connection ↔ user ↔ topics map (in memory per node + broadcast registry).

## Protocol
- Envelope: `{"type":"event","data":{...},"id":"evt_..."}` — id for client dedupe; types as stable enum; version field on payload (forward-compat).
- Heartbeat: client ping / pong (or server ping every 30s, drop dead conns ≤ 90s).
- Rate-limit message rate per connection; cap payload size; sanitize/user-input never injectable into frame handling.

## Reliability
- Reconnect + resume: client sends `last_id`; server replays missed window (buffer or DB sequence) — at-least-once with dedupe is acceptable default.
- Presence: connect/disconnect events (heartbeat-refined); stale mark offline after timeout.
- Unicast vs broadcast: per-node fanout; messages delivered to *all* subscriber nodes — use Redis PUB/SUB or managed channel (Ably/Pusher/Socket.io adapter) for multi-node broadcast; sticky sessions avoid cross-node for simple transports.

## Scale notes
- Horizontal: pub/sub backplane + connection registry per node; backpressure (`ws.bufferedAmount`), slow-consumer 👉 drop policy documented.
- WSS + sticky load balancer; `IdleTimeout`/`ReadTimeout` tuned; keepalive.

## Checklist
- [ ] Auth before upgrade; per-topic permission checks
- [ ] Heartbeat + dead-connection reaping
- [ ] Reconnect/resume (ids + dedupe)
- [ ] Backpressure policy on slow consumers
- [ ] No message injection into HTML (escape client content)