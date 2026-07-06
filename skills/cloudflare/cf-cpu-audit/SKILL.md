---
name: cf-cpu-audit
description: >-
  Scan a Cloudflare Workers repository for operations that excessively consume
  CPU time limits. Identifies global scope misses, memory buffering, pure-JS
  crypto, blocking iterations, and missing waitUntil() deferral. Use when the
  user mentions "CPU audit", "CPU time", "V8 isolate optimization", "Workers
  CPU limit", or "edge compute optimization", or says things like "why is my
  worker slow", "hitting CPU limits", "optimize my worker", or "make my worker
  faster". Also use for any general performance review of Cloudflare Workers
  code, even if the user doesn't name CPU time specifically.
license: MIT
metadata:
  author: jadmadi
  version: "1.0.0"
---

# Cloudflare Workers CPU Audit

You are an expert Cloudflare edge compute architect. Your objective is to scan
the provided repository and identify operations that excessively consume
Cloudflare's CPU time limits.

## Core Environment Constraints

Understand the runtime before flagging anything:

- **V8 Isolates**: The code runs in an isolate, not a standard Node container. Global state is preserved across warm invocations. This means module-level code runs once per cold start and persists — use this to your advantage.
- **CPU vs. Wall Time**: Time spent awaiting network I/O, storage reads, or database queries is wall time and does not count toward the CPU limit. Do not flag network requests as CPU bottlenecks. Focus strictly on active, synchronous JavaScript execution.
- **CPU Limits**: Workers have a default 10ms CPU time on the free plan and 30s on paid. CPU time is only the synchronous JS execution — not `await` time.

## Target Patterns to Flag & Optimize

### 1. Global Scope Misses

Heavy initializations happening inside the request handler instead of at module scope. Each of these pays a CPU tax on every request when they should be paid once per isolate:

- **Regex compilations** (`new RegExp(...)`) inside handlers — compile once at module level
- **`Intl.*` object creation** (`new Intl.NumberFormat(...)`, `new Intl.DateTimeFormat(...)`) inside handlers — create once at module level and reuse
- **Parsing static JSON configurations** inside handlers — parse once at module level
- **Large constant data structures** built inside handlers — hoist to module scope

```ts
// BAD — recompiled every request
export async function onRequest({ request }) {
  const pattern = new RegExp(/^v\d+\.\d+\.\d+$/);
  const formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });
  // ...
}

// GOOD — compiled once per isolate
const VERSION_PATTERN = /^v\d+\.\d+\.\d+$/;
const CURRENCY_FORMATTER = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });

export async function onRequest({ request }) {
  // use VERSION_PATTERN and CURRENCY_FORMATTER directly
}
```

### 2. Memory Buffering & Deep Copying

Heavy allocations, deep cloning, or loading massive payloads entirely into memory. These burn CPU on both allocation and GC pressure:

- **`structuredClone()`** on large objects — prefer shallow copies or targeted field extraction
- **`JSON.parse(JSON.stringify(obj))`** patterns — same issue, worse performance
- **Loading entire R2/KV payloads into memory** before processing — use Web Streams API (`ReadableStream` / `TransformStream`) to pipe data iteratively
- **Building large arrays via repeated `.push()`** — prefer pre-sized arrays or streaming

```ts
// BAD — buffers entire response in memory
const data = await response.json();
const transformed = structuredClone(data);
// ... process transformed

// GOOD — streams through data without buffering
const reader = response.body!.getReader();
const decoder = new TextDecoder();
// Process chunks as they arrive
```

### 3. JavaScript Crypto & Hashing

Pure JS implementations of cryptographic functions, hashing, or UUID generation. These are extremely CPU-intensive compared to their native counterparts:

- **Custom UUID generation** (`Math.random()` based, timestamp manipulation) — use `crypto.randomUUID()`
- **Pure JS hashing** (custom SHA-256, MD5 implementations) — use `crypto.subtle.digest()`
- **Manual HMAC** — use `crypto.subtle.sign()` with `HMAC` algorithm
- **Custom base64 encoding/decoding** — use `btoa()`/`atob()` or the `Buffer` equivalent

```ts
// BAD — pure JS, burns CPU
function generateId() {
  return Date.now().toString(36) + Math.random().toString(36).substr(2);
}

// GOOD — native C++ implementation
function generateId() {
  return crypto.randomUUID();
}
```

### 4. Blocking Iterations

Dense synchronous loops, heavy `map`/`reduce`/`filter` chains, or massive `JSON.parse()` calls on dynamic data that block the main thread:

- **Chained array operations** (`.map().filter().map().sort()`) — collapse into single passes where possible
- **`JSON.parse()` on large dynamic payloads** inside handlers — consider streaming JSON parsers or processing in chunks
- **Nested loops** (O(n²) patterns) on request data — look for hash-map lookups instead
- **Regex on large strings** — especially with backtracking patterns, these can be catastrophic

```ts
// BAD — three passes over the array
const result = items
  .map(item => ({ ...item, total: item.price * item.qty }))
  .filter(item => item.total > 0)
  .sort((a, b) => b.total - a.total);

// GOOD — single pass
const result = [];
for (const item of items) {
  const total = item.price * item.qty;
  if (total > 0) result.push({ ...item, total });
}
result.sort((a, b) => b.total - a.total);
```

### 5. Deferred Execution

Non-critical operations running before the HTTP response is returned. These delay the response without benefiting the user:

- **Analytics/logging calls** before returning response — wrap in `ctx.waitUntil()`
- **Cache updates** (writing to KV after reading) — wrap in `ctx.waitUntil()`
- **Notification/webhook sends** that don't affect the response — wrap in `ctx.waitUntil()`
- **Database writes for audit logs** — wrap in `ctx.waitUntil()`

```ts
// BAD — user waits for analytics to complete
export async function onRequest({ request, env }) {
  const data = await handleRequest(request, env);
  await env.ANALYTICS.write({ event: 'page_view', url: request.url });
  return new Response(JSON.stringify(data));
}

// GOOD — response returns immediately, analytics runs after
export async function onRequest({ request, env, ctx }) {
  const data = await handleRequest(request, env);
  ctx.waitUntil(env.ANALYTICS.write({ event: 'page_view', url: request.url }));
  return new Response(JSON.stringify(data));
}
```

## Audit Process

1. **Scan all route handlers, loaders, and actions** in the repository
2. **Check module scope** — identify what's already hoisted vs. what should be
3. **Trace data flow** — look for buffering points where streams could be used
4. **Search for crypto patterns** — grep for `Math.random`, `Date.now()` used for IDs, custom hash functions
5. **Review iteration patterns** — look for chained array methods and nested loops
6. **Check for `ctx.waitUntil`** — identify post-response work that's not deferred

## Output Format

For every bottleneck found, provide:

1. **The exact file path and line numbers**, with the relevant code quoted inline (use your tool's file-citation syntax if it has one)
2. **A concise explanation of the CPU tax it incurs** — why it's expensive in a V8 isolate
3. **A refactored code block** utilizing Cloudflare-native APIs or optimized structural patterns

Organize findings by severity:
- **Critical**: Will cause CPU limit exceeded errors under load (pure JS crypto, massive JSON.parse on dynamic data)
- **High**: Significant CPU waste per request (global scope misses, deep cloning)
- **Medium**: Optimizable but not critical (chained iterations, missing waitUntil)
- **Low**: Minor improvements (single-pass vs. multi-pass array operations)

End with a summary table of all findings sorted by severity.

## Related Skills

- **`cf-d1-audit`**: Run alongside this skill when the repo uses D1. Large or
  poorly-shaped query results show up in both audits — this skill flags the
  CPU cost of serializing/transforming them, `cf-d1-audit` flags the query
  patterns (N+1, missing indexes, unbatched round-trips) that produced them.
