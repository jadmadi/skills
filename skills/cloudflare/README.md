# Cloudflare

Audits for Cloudflare Workers CPU usage and D1 database performance/billing.

- **[cf-cpu-audit](./cf-cpu-audit/SKILL.md)** — Scan a Cloudflare Workers repo for operations that excessively consume CPU time: global scope misses, memory buffering, pure-JS crypto, blocking iterations, missing `waitUntil()` deferral.
- **[cf-d1-audit](./cf-d1-audit/SKILL.md)** — Scan a Cloudflare Workers repo for D1 patterns that inflate billing, risk timeouts, or cause consistency bugs: missing indexes, N+1 queries, unbatched round-trips, wildcard `SELECT`s, and more.

Run both together when a change touches a Worker backed by D1 — large or poorly-shaped query results show up in both audits.
