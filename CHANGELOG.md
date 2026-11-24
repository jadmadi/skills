# Changelog

Per-skill changes. Repo-level milestone tags (`v1.0.0`, etc.) mark release points where the collection as a whole is in a shippable state; per-skill tags (`adoo@1.1.0`, etc.) track individual skill versions and match the `metadata.version` field in each `SKILL.md`.

## cofounder

### 1.1.0 — 2026-11-17

- Added explicit bare `/cofounder` repo-first flow: extract and state the inferred business idea and stage from repo files first, grill 2-3 crystallization questions with `Recommendation:` defaults, and offer tailored next `/cofounder` routes.

### 1.0.0 — 2026-11-17

- Initial release. Turns the founder playbook (Start, Build, Sell, Scale) into an active `/cofounder` copilot with workspace-first fact inspection, frontier grilling (`Q1`/`Q2` rounds with `yes`-acceptable recommendations), stage-matched structured thinking, 8 hard pushback gates, and 4 on-demand reference playbooks (`start.md`, `build.md`, `sell.md`, `scale.md`).
- Added behavioral smoke evals at `evals/cofounder/cases.md` and `evals/cofounder/inputs.json`.

## structured-thinking

Unreleased, 2026-10-14.

- Added 25 independently installable named method skills, including
  st-six-hats, with a source-sync generator and drift checks. Shortened all method
  names to st-* on 2026-10-15 for easier CLI invocation.

- Added one portable entrypoint and 25 method guides for grounded decisions, diagnosis,
  prioritization, systems analysis, and communication.
- Added installation guidance, framework and boundary cases, native-host smoke receipts,
  and controlled baseline comparisons. Evidence limits are recorded with the results.

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

## us-incorporation

### 1.0.0 — 2026-11-24

- Initial release. Thin, portable `/us-incorporation` workflow wrapping upstream `General-Legal/agent-operated-company` templates and `manifest.json` without vendoring legal `.docx` files. Includes entity triage (LLC vs C-corp), five hard safety gates (legal disclaimer, human filing approval, free `irs.gov` EIN, separate bank account shield, and vesting/83(b)/non-U.S. counsel escalation), and optional attorney-reviewed MCP setup.
- Added behavioral smoke evals at `evals/us-incorporation/cases.md` and `evals/us-incorporation/inputs.json`.

## Repo milestones

### v1.0.0 — 2026-07-07

Initial public release of the skills collection. 5 skills (adoo, cf-cpu-audit, cf-d1-audit, codebase-artifact, pre-flight-check) organized into `engineering/` and `cloudflare/` buckets. Published to [skills.sh/jadmadi/skills](https://skills.sh/jadmadi/skills). MIT licensed. Repo structure and conventions adapted from [mattpocock/skills](https://github.com/mattpocock/skills).
