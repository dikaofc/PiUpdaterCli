---
name: idor
description: Broken Object-Level Authorization / IDOR playbook — enumerate object references (IDs, UUIDs, filenames, tokens) in API routes and file downloads, test cross-user/cross-tenant access with session switching, and prove impact with evidence of another user's data. Use when the target has object-centric endpoints like /api/v1/orders/{id}, /users/123, /files/{uuid}, invoice/download links, or any resource keyed by a guessable identifier.
allowed-tools:
  - http
  - shell
  - file_write
---

# IDOR / BOLA playbook

Goal: prove that one user can read or modify another user's (or another tenant's) objects. The finding is only valid when you can show a REAL second user's/tenant's data — not the same session's own data.

## 1. Map object endpoints

From your own session (browser capture or API logs), collect routes with object identifiers: `/api/v1/orders/{id}`, `/users/{id}`, `/files/{uuid}`, `/attachments/{name}`, `/messages/{id}`, `/invoices/{n}`. Note request method, params, and which identifiers are sequential (predictable) vs UUIDs (harder).

## 2. Test each with a different identity

The gold-standard test uses TWO sessions (two accounts):

```sh
# session A (your normal user): create an object, note its id
curl -ksS "https://TARGET/api/v1/orders/1043" -H "Authorization: Bearer $USERA"
# session B (different account): fetch the SAME id
curl -ksS "https://TARGET/api/v1/orders/1043" -H "Authorization: Bearer $USERB"
```

- Session B sees A's object → IDOR read.
- B can PATCH/DELETE A's object → IDOR write (usually higher severity).

If you only have one account, enumerate around your own object (`id+1`), but tag such findings as same-session observation and verify cross-account later — or use a second account if the engagement allows creating one.

## 3. Variations to test

- **UUIDs still leak**: check `/api/v1/orders?page=2`, list endpoints exposing other users' UUIDs, then fetch by UUID.
- **Parameter swaps**: `{id}` in path vs `?file_id=` in query vs JSON body — a copy of the object reference in a different location may skip the check.
- **Numeric vs type confusion**: `id=1043` vs `id[]=1043` vs `id=1043.0` vs string `"1043"` — frameworks sometimes skip checks on type mismatches.
- **Mass assignment in writes**: PATCH with `user_id`/`ownerId` fields in the body to reassign an object to your account.
- **Tenant traversal**: `X-Tenant-Id`, `tenant=`, subdomain headers — try swapping tenant identifiers with the same token.
- **Bulk endpoints**: `/export?ids=1,2,3` or graphQL `node(id:)` aliases that batch-check only the first ID.

## 4. Chain (typical combo)

IDOR read on a user object often yields: PII/PII exposure, session tokens in responses, password-reset tokens, payment/card data. IDOR write can do account takeover via `email`/`password` fields on `/api/v1/users/{id}`.

## 5. Reporting

Evidence: request for YOUR object with session A, request for the SAME object with session B, and the response containing B-exclusive data. Impact: horizontal access to every user's data, or account takeover on write-IDOR. Remediation: server-side authorization check per object (not per collection), ownership/tenant scoping, use of unguessable IDs is not a fix.

When you can corroborate with a second identity, call `confirm_finding`.