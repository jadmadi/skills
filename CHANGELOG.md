# Changelog

Per-skill changes. Repo-level milestone tags (`v1.0.0`, etc.) mark release points where the collection as a whole is in a shippable state; per-skill tags (`adoo@1.1.0`, etc.) track individual skill versions and match the `metadata.version` field in each `SKILL.md`.

## adoo

### 1.1.0 — 2026-07-07

- Added "apply domain audit knowledge during implementation, not after" to the Optimize stage. If the task touches a domain where a dedicated audit skill exists and is available (e.g. `cf-cpu-audit`, `cf-d1-audit`), apply that skill's checklist while writing the fix rather than saving it for a separate post-implementation audit pass. Conditional, not hard-wired — skips silently when no audit skill applies.
- Added matching checklist item to Optimize.

### 1.0.0 — 2026-07-06

- Initial public release. Four-stage framework (Assess, Deconstruct, Organize, Optimize) with stage-transition summaries, checklists, and anti-patterns. Includes pre-mortem step in Optimize (state one way the fix could fail before implementing), regression-test promotion (manual reproductions become automated tests), and doc-correction step (fix wrong assumptions written in comments/READMEs/AGENTS.md).

## cf-cpu-audit

### 1.0.0 — 2026-07-06

- Initial public release. Scans Cloudflare Workers repos for CPU-time-consuming patterns: global scope misses, memory buffering, pure-JS crypto, blocking iterations, missing `waitUntil()` deferral. Agent-agnostic citation syntax (no Devin-specific `<ref_snippet>` tags).

## cf-d1-audit

### 1.0.0 — 2026-07-06

- Initial public release. Scans Cloudflare Workers repos for D1 patterns that inflate billing (Rows Read / Rows Written), risk timeouts, or cause consistency bugs: missing indexes, N+1 queries, unbatched round-trips, wildcard SELECTs, wrong extraction methods, read-after-write hazards.

## codebase-artifact

### 1.0.0 — 2026-05-11

- Initial release. Scans a codebase and produces a single self-contained HTML file documenting architecture, user journey, component hierarchy, and key code patterns. Includes `references/DESIGN_CONTRACT.md` and `references/SVG_GRAMMAR.md`.

## pre-flight-check

### 1.0.0 — 2026-07-06

- Initial public release. Pre-commit / pre-deploy checklist for backend and full-stack changes: typecheck/lint gates, API response envelope consistency, route ordering, schema/column verification, mutation return-value checking, frontend/backend validation alignment. Genericized from a project-specific checklist.

## Repo milestones

### v1.0.0 — 2026-07-07

Initial public release of the skills collection. 5 skills (adoo, cf-cpu-audit, cf-d1-audit, codebase-artifact, pre-flight-check) organized into `engineering/` and `cloudflare/` buckets. Published to [skills.sh/jadmadi/skills](https://skills.sh/jadmadi/skills). MIT licensed. Repo structure and conventions adapted from [mattpocock/skills](https://github.com/mattpocock/skills).
