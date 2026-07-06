---
name: pre-flight-check
description: >-
  Pre-commit and pre-deploy checklist for backend and full-stack changes:
  typecheck/lint gates, API response envelope consistency, router ordering
  (static vs. dynamic routes), schema/column verification before writes,
  checking mutation return values instead of assuming success, and keeping
  frontend form fields aligned with backend validation schemas. Use when the
  user says "deploy", "commit", "ship", "push", "ready to merge", or before
  committing any change that touches route handlers, service/repository
  layers, or shared validation logic. Also use when reviewing a PR for common
  full-stack bug patterns before it merges.
license: MIT
metadata:
  author: jadmadi
  version: "1.0.0"
---

# Pre-Flight Check

A checklist to run before committing or deploying backend and full-stack
changes. The bugs it catches aren't things a typechecker or linter will find
— they're mismatches between two places that are supposed to agree (route
order, schema vs. query, frontend field vs. backend schema, response
envelope shape), or a call site that never checked whether the thing it
called actually succeeded.

This skill is a template. Steps 3, 5, 8, and 11 reference conventions
(response envelope shape, schema location, table ownership, database engine)
that differ per project — adapt the specifics to whatever this repo actually
does. The value is in the *shape* of each check, not the literal example.

## When to invoke

- Before committing any change that touches route handlers, service/repository layers, or shared validation schemas
- Before deploying to production
- When the user says "deploy", "commit", "ship", "push", or "ready to merge"
- When reviewing a PR that touches backend or full-stack logic

## Steps

1. **Typecheck:** Run the project's typecheck command (`tsc --noEmit`, `npm run typecheck`, etc.) — must exit 0.
2. **Lint:** Run the project's linter. Treat warnings as failures unless the project has explicitly decided otherwise.
3. **API response shape:** Confirm every route handler returns the same response envelope the rest of the API uses (consistently `{ success: true, data: {...} }`, or consistently flat fields — whichever this project has standardized on). A handler that breaks the pattern silently breaks every client that destructures the standard shape.
4. **Route order:** In the same router, static/specific routes (`/export`, `/stats`, `/me`) must be registered before parameterized routes (`/:id`) that would otherwise shadow them.
5. **Schema vs. query:** Verify every column referenced in an `INSERT`/`UPDATE` actually exists on the target table. Check the schema file or introspect the live database — don't assume from the variable name.
6. **Result checking:** Every call to a create/update/delete function must check its return value before treating the operation as successful — not just `await repo.create(...)` and moving on. `if (!result.success) return { success: false, error: result.error }`.
7. **Field names:** Frontend form field names must match the backend validation schema's field names exactly. A silent mismatch (`name` vs. `full_name`) fails validation without an obvious error.
8. **Column ownership:** Before writing `UPDATE <table> SET <column> = ?`, confirm the column actually lives on that table — not a related table that happens to get joined in elsewhere.
9. **Counts:** Never derive a total count from `array.length` of a paginated list response — that's capped at page size. Use a dedicated count/stats endpoint or a `COUNT` query.
10. **Batch semantics:** If the database's batch/transaction API is all-or-nothing (e.g. Cloudflare D1's `db.batch()`), one failing statement rolls back the entire batch. Use per-item mini-batches for bulk operations where partial success should be preserved.
11. **ORM writes on SQLite-family databases:** Some ORM convenience methods rely on a `RETURNING` clause that isn't fully supported on every SQLite-family backend (D1 included, depending on version — see the `cf-d1-audit` skill for more). If a "create" call silently returns no row, verify with a direct write plus a separate read instead of trusting the ORM's return value.
12. **Verify after deploy:** Hit the affected endpoint(s) directly (`curl`, HTTP client) and confirm the resulting database state matches expectations — don't rely solely on a 200 response.

## Common bug patterns to check for

| Pattern | Bug | Fix |
|---------|-----|-----|
| ORM `.returning()` / `RETURNING` on a SQLite-family DB | May silently return no data instead of erroring | Use a direct write, then a separate read, if rows are created but IDs come back missing |
| `INSERT INTO x (... column_not_in_schema)` | Column doesn't exist | Check the schema first; migrate if the column is genuinely needed |
| `await repo.create(db, data)` with no result check | Failure is silently reported as success | `if (!result.success) return { success: false, error: result.error }` |
| `router.get('/:id')` defined before `router.get('/export')` | The static route is never reached — `/export` is parsed as `id="export"` | Register static/specific routes before parameterized ones |
| Inconsistent response envelope (`{ created: 5 }` vs. `{ success, data }`) | Client expects `response.data` and gets `undefined` | Standardize on one envelope shape across all routes |
| Frontend field `name` vs. backend schema field `full_name` | Validation silently drops or rejects the field | Align field names between the form and the validation schema |
| `UPDATE <domain_table> SET status = ?` when `status` actually lives on a shared/parent table | Query succeeds but updates nothing, or updates the wrong row | Verify column location in the schema before writing the query |
| `paginatedList.length` used as "total" | Always returns the page size, not the true total | Use a dedicated count/stats endpoint |
| No fallback for an empty avatar/image URL | Broken `<img>` tag in the UI | Fall back to initials or a placeholder image |

## Related Skills

- **`cf-d1-audit`**: If this project uses Cloudflare D1, run it for a deeper
  pass on query patterns (N+1, missing indexes, batching) beyond what this
  checklist covers.
- **`cf-cpu-audit`**: If this project runs on Cloudflare Workers, run it
  alongside a deploy check to catch CPU-time regressions before they ship.
