# Skills

Jad Madi's agent skills — for Claude Code, Cursor, Windsurf, Codex, Devin, and any other agent that supports the [Agent Skills](https://agentskills.io/) format. Built from real engineering work, refined against real usage, published as I use them.

[![skills.sh](https://skills.sh/b/jadmadi/skills)](https://skills.sh/jadmadi/skills)

## Quickstart

```bash
npx skills add jadmadi/skills
```

Pick the skills you want and which agents to install them on. Skills are used automatically once installed — the agent reaches for them when a task matches.

## Skills

Organized into buckets under `skills/`. All skills below are model-invoked (the agent can reach for them on its own, based on the task, not just by typed name).

### [Engineering](skills/engineering/)

Debugging, pre-ship checklists, and codebase documentation.

- **[adoo](skills/engineering/adoo/SKILL.md)** — Structured problem-solving via the ADOO method (Assess, Deconstruct, Organize, Optimize) for bugs, refactors, and incidents where jumping straight to a fix is risky.
- **[pre-flight-check](skills/engineering/pre-flight-check/SKILL.md)** — Pre-commit / pre-deploy checklist for backend and full-stack changes: typecheck/lint gates, API response consistency, route ordering, schema checks, and result-checking. Ships as an adaptable template.
- **[codebase-artifact](skills/engineering/codebase-artifact/SKILL.md)** — Scan a codebase and produce a single self-contained HTML file documenting its architecture, user journey, component hierarchy, and key code patterns.

### [Cloudflare](skills/cloudflare/)

Audits for Cloudflare Workers CPU usage and D1 database performance/billing.

- **[cf-cpu-audit](skills/cloudflare/cf-cpu-audit/SKILL.md)** — Scan a Cloudflare Workers repo for operations that excessively consume CPU time: global scope misses, memory buffering, pure-JS crypto, blocking iterations, missing `waitUntil()` deferral.
- **[cf-d1-audit](skills/cloudflare/cf-d1-audit/SKILL.md)** — Scan a Cloudflare Workers repo for D1 patterns that inflate billing, risk timeouts, or cause consistency bugs: missing indexes, N+1 queries, unbatched round-trips, wildcard `SELECT`s, and more.

## For contributors

```bash
# Scaffold a new skill from the template
scripts/create-skill.sh <bucket> <skill-name>

# Quick local sanity check (frontmatter, name/description rules, body length)
scripts/validate-skill.sh <bucket>/<skill-name>

# List every skill in the repo
scripts/list-skills.sh

# Symlink every skill into this machine's agent config directories
# (~/.claude/skills, ~/.config/devin/skills, ~/.agents/skills, etc.)
scripts/link-skills.sh
```

See [AGENTS.md](AGENTS.md) for the full conventions (naming, description hygiene, cross-agent portability, when to add a new bucket) and [.out-of-scope/](.out-of-scope/) for additions that were deliberately rejected, and why.

## Skill structure

Each skill is a directory under `skills/<bucket>/<name>/` containing:

- `SKILL.md` — instructions for the agent (required)
- `scripts/` — helper scripts for automation (optional)
- `references/` — supporting documentation loaded on demand (optional)
- `assets/` — templates or files used in output (optional)

## License

MIT

## Author

Jad Madi — [github.com/jadmadi](https://github.com/jadmadi)
