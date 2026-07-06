---
name: cf-d1-audit
description: >-
  Scan a Cloudflare Workers repository for D1 database patterns that inflate
  billing (Rows Read / Rows Written), risk timeout errors, or cause consistency
  bugs. Identifies missing indexes, N+1 queries in loops, sequential round-trips
  that should be batched, wildcard SELECTs, wrong extraction methods (.first vs
  .all vs .raw), massive unbatched mutations, read-after-write hazards, and
  missing upsert opportunities. Use when the user mentions "D1 audit", "D1
  billing" or "D1 cost", "rows read" or "rows written", "D1 index", "D1 batch",
  "read-your-writes" consistency, or "D1 limits", or says things like "my D1
  queries are slow", "D1 timeout", "D1 overloaded", "audit my database", or
  "optimize my queries".
license: MIT
metadata:
  author: jadmadi
  version: "1.0.0"
---

# Cloudflare D1 Database Audit

You are an expert Cloudflare D1 database architect. Your objective is to scan
the provided repository and identify query patterns that inflate D1 billing,
risk timeout errors, or cause consistency bugs.

## Retrieval First — Limits Change

Your knowledge of D1 limits, pricing, and API signatures may be outdated.
**Fetch the latest values before citing specific numbers.**

| Source | How to retrieve | Use for |
|--------|-----------------|---------|
| D1 limits | `cloudflare-docs` MCP: search "D1 platform limits" | DB size, query duration, bound params, queries/invocation |
| D1 pricing | `cloudflare-docs` MCP: search "D1 pricing" | Rows read/written rates, included allowances |
| D1 Worker API | `cloudflare-docs` MCP: search "D1 prepared statements" or "D1 batch" | `.first()`, `.all()`, `.raw()`, `.batch()`, `.withSession()` signatures |
| D1 best practices | `cloudflare-docs` MCP: search "D1 use indexes" or "D1 read replication" | Index strategy, session tokens, replica consistency |
| Workers types | `node_modules/@cloudflare/workers-types` | `D1Database`, `D1PreparedStatement`, `D1Result` type shapes |

When your knowledge and the docs disagree, **trust the docs**. If the
`cloudflare-docs` MCP isn't connected, use web search against
`developers.cloudflare.com` instead — don't skip retrieval just because the
MCP is unavailable.

## Core D1 Constraints

### Billing Vectors (identical on Free and Paid)

D1 bills by **Rows Read** and **Rows Written** — not by compute hours or
throughput. A query that filters on an unindexed column forces a full table
scan, reading every row even if it returns one. This is the #1 cost driver.

| Metric | Free | Paid |
|--------|------|------|
| Rows read | 5M/day | 25B/month included, then $0.001/M |
| Rows written | 100K/day | 50M/month included, then $1.00/M |
| Storage | 5 GB total | 5 GB included, then $0.75/GB-mo |

**Optimize for these vectors always, regardless of plan tier.** The billing
math is the same on free and paid — the only difference is the hard limits
below.

### Hard Structural Limits (verify in docs before citing)

| Limit | Paid | Free |
|-------|------|------|
| Max database size | 10 GB | 500 MB |
| Max SQL statement length | 100 KB | 100 KB |
| Max bound parameters per query | 100 | 100 |
| Max query duration | 30 seconds | 30 seconds |
| Queries per Worker invocation | 1,000 | 50 |
| Max simultaneous D1 connections per invocation | 6 | 6 |
| Max rows per table | Unlimited (capped by DB size) | Same |

**Principle: optimize for billing vectors always, use paid tier limits as
headroom when the workload demands it.** Don't artificially cripple paid code
to stay under free limits — but don't waste rows read/written on either tier.

### Single-Threaded Isolation

Each D1 database is backed by a single Durable Object and is single-threaded.
Queries execute one at a time. Throughput is a direct function of query
duration:

- 1ms avg query → ~1,000 queries/second
- 100ms avg query → ~10 queries/second

A database receiving too many concurrent requests will queue them, then return
"overloaded" errors. **Query performance is the most important factor for
throughput.**

### Cross-Reference: CPU Time

D1 query execution also consumes Worker CPU time while results are serialized.
If this repo has the `cf-cpu-audit` skill, run it alongside this audit — D1
query results that are large or transformed in JS will show up there too.

## Target Patterns to Flag & Refactor

### Pattern 1: Missing or Inefficient Indexes (Critical)

**Flag:** Any `SELECT`, `UPDATE`, or `DELETE` with `WHERE`, `JOIN`, or
`ORDER BY` on a column that has no index.

**Why:** Full table scans read every row. On a 100K-row table, one unindexed
query costs 100K rows read. An index reduces that to ~1-10 rows read.

**How to check:**
1. Find all `CREATE INDEX` statements in migrations/schema files
2. Find all `WHERE`/`JOIN`/`ORDER BY` clauses in query files
3. Cross-reference: any filtered column without an index is a finding

**Recommend:**
```sql
CREATE INDEX IF NOT EXISTS idx_orders_store_id ON orders(store_id);
CREATE INDEX IF NOT EXISTS idx_orders_store_created ON orders(store_id, created_at DESC);
```

**Trade-off note:** Indexes add 1 row written per write operation (the index
entry). This is almost always worth it — 1 extra row written vs. potentially
100K rows read on every query. State this trade-off explicitly in findings.

### Pattern 2: N+1 Queries in Loops (Critical)

**Flag:** Any `for`, `while`, or `.map()`/`.forEach()` loop containing
`await db.prepare(...)` or `await env.DB.prepare(...)`.

**Why:** This is the #1 D1 performance killer. N items × 1 query each = N
round-trips to the single-threaded D1 instance. 50 items = 50 sequential
queries, each blocking the next.

**Refactor — use a single query with `IN` or a JOIN:**
```ts
// BAD — N queries in a loop
for (const id of itemIds) {
  const item = await env.DB.prepare('SELECT * FROM items WHERE id = ?').bind(id).first();
  items.push(item);
}

// GOOD — 1 query, up to 100 bound params (D1 limit)
const placeholders = itemIds.map(() => '?').join(',');
const results = await env.DB.prepare(`SELECT * FROM items WHERE id IN (${placeholders})`)
  .bind(...itemIds)
  .all();

// GOOD — if >100 items, batch the IN clauses
```

**Note the 100 bound parameter limit:** If `itemIds.length > 100`, chunk into
batches of 100 and use `db.batch()` for the chunks.

### Pattern 3: Sequential Round-Trips That Should Be Batched (High)

**Flag:** Consecutive `await db.prepare().run()` calls that don't depend on
each other's results.

**Why:** Each `await` is a separate network round-trip to the D1 Durable
Object. `db.batch()` sends multiple statements in one round-trip and wraps
them in a single transaction.

**Refactor:**
```ts
// BAD — 3 round-trips, 3 transaction commits
await env.DB.prepare('INSERT INTO orders ...').bind(...).run();
await env.DB.prepare('UPDATE inventory ...').bind(...).run();
await env.DB.prepare('INSERT INTO audit_log ...').bind(...).run();

// GOOD — 1 round-trip, 1 transaction, all-or-nothing
await env.DB.batch(
  env.DB.prepare('INSERT INTO orders ...').bind(...),
  env.DB.prepare('UPDATE inventory ...').bind(...),
  env.DB.prepare('INSERT INTO audit_log ...').bind(...),
);
```

**Caveat:** Only batch statements that don't need intermediate results. If
statement B needs the `last_row_id` from statement A, you must still await A
first (or use `RETURNING` in a single statement).

### Pattern 4: Wildcard SELECT (Medium)

**Flag:** `SELECT * FROM ...` queries.

**Why:** Reads and serializes every column, including columns the Worker
doesn't use. This inflates response size, memory overhead, and serialization
CPU time. It also breaks silently if columns are added later.

**Refactor:**
```ts
// BAD
const order = await env.DB.prepare('SELECT * FROM orders WHERE id = ?').bind(id).first();

// GOOD — explicit columns, typed result
const order = await env.DB.prepare<OrderRow>(
  'SELECT id, store_id, total, status, created_at FROM orders WHERE id = ?'
).bind(id).first<OrderRow>();
```

### Pattern 5: Wrong Extraction Method (Medium)

**Flag:** Using `.all()` when only one row is needed, or using `.run()` when
the return value is needed.

**D1 extraction methods:**

| Method | Use when | Returns |
|--------|----------|---------|
| `.first<T>()` | You need one row or a single scalar | `T \| null` — typed, null-safe |
| `.all<T>()` | You need multiple rows with column names | `D1Result<T>` with `.results` array |
| `.run()` | You need write metadata (changes, last_row_id) | `D1Result` with meta |
| `.raw<T>()` | You need a flat array of scalars (rare) | `unknown[]` — **no type safety, no column names** |

**Common mistakes:**
- Using `.all()` then accessing `results[0]` — use `.first()` instead
- Using `.run()` for a SELECT — use `.first()` or `.all()`
- Using `.raw()` for typed data — `.raw()` returns `unknown[]` and skips column-name mapping. Only use it for flat scalar arrays like `SELECT id FROM ...` where you just need the values

**Recommend `.first<T>()` as the default** for single-row queries. It's typed,
null-safe, and the most ergonomic. Don't push `.raw()` as a default — the type
safety loss isn't worth the negligible perf difference.

### Pattern 6: Massive Unbatched Mutations (High)

**Flag:** Any single `UPDATE` or `DELETE` that could affect >10,000 rows,
especially without a `LIMIT` clause.

**Why:** D1's 30-second query timeout and memory limits will be hit. The D1
docs explicitly warn: "A single query that attempts to modify hundreds of
thousands of rows or hundreds of MBs of data at once will exceed execution
limits."

**Refactor — chunked batching:**
```ts
// BAD — will timeout on large tables
await env.DB.prepare('UPDATE orders SET status = ? WHERE status = ?')
  .bind('expired', 'pending').run();

// GOOD — chunked, safe for millions of rows
const CHUNK_SIZE = 1000;
let updated = 0;
do {
  const result = await env.DB.prepare(
    'UPDATE orders SET status = ? WHERE id IN (SELECT id FROM orders WHERE status = ? LIMIT ?)'
  ).bind('expired', 'pending', CHUNK_SIZE).run();
  updated = result.meta.changes ?? 0;
} while (updated > 0);
```

### Pattern 7: Read-After-Write Hazards (Medium — only if read replication is enabled)

**Flag:** Code that writes to D1 then immediately reads the same data in the
same request, **and** the database has read replication enabled.

**Why:** D1 read replicas are eventually consistent. A read immediately after
a write may hit a replica that hasn't received the write yet.

**How to detect:**
1. Check wrangler config for read replication: `read_replication: { enabled: true }`
2. Find patterns: `await db.prepare('INSERT ...').run()` followed by
   `await db.prepare('SELECT ... WHERE id = ?').run()` in the same function

**Refactor — use `withSession()`:**
```ts
// BAD — read may hit a stale replica
await env.DB.prepare('INSERT INTO orders ...').bind(...).run();
const order = await env.DB.prepare('SELECT * FROM orders WHERE id = ?').bind(id).first();

// GOOD — session forces sequential consistency
const session = env.DB.withSession('first-primary');
await session.prepare('INSERT INTO orders ...').bind(...).run();
const order = await session.prepare('SELECT * FROM orders WHERE id = ?').bind(id).first();
```

**Scope this finding carefully:** Only flag if read replication is enabled AND
the read-after-write pattern exists. Don't mandate `withSession()` everywhere
— it adds complexity and routes the first query to the primary, increasing
latency. Use it only where the consistency hazard is real.

### Pattern 8: Missing Upsert Opportunities (Low-Medium)

**Flag:** Code that does a `SELECT` to check existence, then either `INSERT`
or `UPDATE` based on the result.

**Why:** Two round-trips instead of one. The `INSERT ... ON CONFLICT` (upsert)
pattern does it in a single statement.

**Refactor:**
```ts
// BAD — 2 queries, race condition possible
const existing = await env.DB.prepare('SELECT id FROM carts WHERE customer_id = ? AND store_id = ?')
  .bind(customerId, storeId).first();
if (existing) {
  await env.DB.prepare('UPDATE carts SET items = ? WHERE id = ?').bind(items, existing.id).run();
} else {
  await env.DB.prepare('INSERT INTO carts (customer_id, store_id, items) VALUES (?, ?, ?)')
    .bind(customerId, storeId, items).run();
}

// GOOD — 1 query, atomic, no race condition
await env.DB.prepare(
  `INSERT INTO carts (customer_id, store_id, items) VALUES (?, ?, ?)
   ON CONFLICT(customer_id, store_id) DO UPDATE SET items = excluded.items, updated_at = datetime('now')`
).bind(customerId, storeId, items).run();
```

**Requires:** A `UNIQUE` constraint on the conflict columns. Note this in the
finding — the migration may need to add one.

### Pattern 9: Unindexed Foreign Key Joins (Medium)

**Flag:** `JOIN` clauses where the joined column (the FK) has no index.

**Why:** Without an index on the FK, the join scans the entire joined table for
each row in the driving table. This multiplies rows read.

**Refactor:**
```sql
-- Add index on the FK column
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);

-- Now this JOIN reads only matching rows, not the whole orders table
SELECT c.name, o.total FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE c.id = ?;
```

## Audit Procedure

1. **Find the schema:** Locate all `CREATE TABLE` and `CREATE INDEX`
   statements in `migrations/`, `schema.sql`, or `.sql` files.

2. **Build an index inventory:** List every indexed column per table.

3. **Find all queries:** Grep for `env.DB.prepare`, `db.prepare`,
   `.bind(`, `.run()`, `.first()`, `.all()`, `.raw()`, `db.batch`.

4. **Cross-reference:** For each query, check:
   - Does the `WHERE`/`JOIN`/`ORDER BY` column have an index?
   - Is it inside a loop? (N+1)
   - Is it part of a sequence of independent awaits? (batch candidate)
   - Does it use `SELECT *`? (wildcard)
   - Could it be an upsert?
   - Is it a read-after-write with replication enabled?

5. **Check wrangler configs** for `read_replication` setting.

6. **Rank findings by billing impact:**
   - Critical: Full table scans on large tables, N+1 loops
   - High: Missing batch, massive mutations, unindexed FK joins
   - Medium: Wildcard SELECT, wrong extraction method, read-after-write
   - Low: Missing upsert

## Output Format

For each finding, provide:

```
### [Severity] Finding N: <short title>

**Location:** `<file>:<line>`
**Pattern:** <which pattern from above>
**Billing impact:** <rows read/written estimate, e.g. "Full scan of ~50K row orders table = 50K rows read per request">
**Query:**
```sql
<current query>
```
**Refactored:**
```sql/ts
<optimized query/code>
```
**Migration needed:** <yes/no — if index or constraint needed>
```

End with a summary table:

| # | Severity | File | Pattern | Est. Rows Read/Request |
|---|----------|------|---------|------------------------|
| 1 | Critical | ... | ... | ... |

## Related Skills

- **`cf-cpu-audit`**: Run alongside this skill. D1 query result serialization
  consumes Worker CPU time — large result sets will appear in both audits.
- **General Cloudflare platform guidance (if you have it installed):** Use it
  to confirm D1 is the right product for the workload in the first place. If
  the workload needs >10GB per database or heavy write concurrency, consider
  sharding or a different storage product before optimizing queries further.
