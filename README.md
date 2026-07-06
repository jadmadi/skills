# Skills

A collection of skills for AI coding agents — Claude Code, Cursor, Windsurf, Codex, Devin, and others. Skills are packaged instructions (and optional scripts) that extend what an agent can do out of the box.

Skills follow the [Agent Skills](https://agentskills.io/) open format.

[![skills.sh](https://skills.sh/b/jadmadi/skills)](https://skills.sh/jadmadi/skills)

## Available Skills

### adoo

Structured problem-solving via the ADOO method (Assess, Deconstruct, Organize, Optimize). A four-stage framework for working through complex bugs, multi-step refactors, and unclear requirements without jumping straight to a fix.

**Use when:**

- Invoking `/adoo` followed by a task, bug report, feature request, or problem description
- Tackling complex bugs, multi-step refactors, or unclear requirements
- Investigating production incidents or performance regressions
- A problem spans multiple files/systems and the root cause is unknown

### cf-cpu-audit

Scans a Cloudflare Workers repository for operations that excessively consume CPU time limits — global scope misses, memory buffering, pure-JS crypto, blocking iterations, and missing `waitUntil()` deferral.

**Use when:**

- Optimizing a Cloudflare Worker for CPU time or V8 isolate performance
- Investigating "hitting CPU limits" or a Worker that feels slow
- Reviewing edge compute code for performance before shipping

### cf-d1-audit

Scans a Cloudflare Workers repository for D1 database patterns that inflate billing (Rows Read / Rows Written), risk timeout errors, or cause consistency bugs — missing indexes, N+1 queries, unbatched round-trips, wildcard `SELECT`s, wrong extraction methods, massive unbatched mutations, read-after-write hazards, and missed upsert opportunities.

**Use when:**

- Optimizing D1 queries or reducing D1 billing
- Investigating D1 timeouts, row limits, or "overloaded" errors
- Reviewing database access patterns before shipping

### pre-flight-check

Pre-commit and pre-deploy checklist for backend and full-stack changes: typecheck/lint gates, API response envelope consistency, router ordering, schema/column verification before writes, checking mutation return values instead of assuming success, and keeping frontend fields aligned with backend validation schemas. Ships as an adaptable template — see the skill for which steps to customize per project.

**Use when:**

- About to commit, ship, push, or deploy a backend/full-stack change
- Reviewing a PR that touches route handlers, service/repository layers, or shared validation logic

## Installation

Install the whole collection with the [`skills` CLI](https://github.com/vercel-labs/skills):

```bash
npx skills add jadmadi/skills
```

Skills are automatically available once installed — your agent uses them when a relevant task is detected.

**Examples:**

```
Use ADOO to break down this bug
```

```
Audit this Cloudflare Worker for CPU bottlenecks
```

```
Run a pre-flight check before I deploy
```

## Skill structure

Each skill contains:

- `SKILL.md` — instructions for the agent (required)
- `scripts/` — helper scripts for automation (optional)
- `references/` — supporting documentation (optional)

See [AGENTS.md](AGENTS.md) for the conventions this repo follows when adding a new skill.

## License

MIT
