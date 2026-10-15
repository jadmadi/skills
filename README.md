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

## Structured thinking

Use [skills/structured-thinking/SKILL.md](skills/structured-thinking/SKILL.md) when a decision,
problem, or message needs more structure. It selects a suitable method or follows one you name,
then reads only that method's guide. Routine edits do not need a framework.

The toolkit includes Six Thinking Hats, Ishikawa, Eisenhower, second-order thinking, Iceberg,
abstraction laddering, decision matrices, impact-effort, connection circles, the ladder of inference,
conflict resolution, SBI, hard choices, Zwicky boxes, OODA, Minto, concept maps, Cynefin,
Productive Thinking, inversion, issue trees, confidence versus speed/quality, first principles,
and balancing and reinforcing feedback loops.

It distinguishes evidence from assumptions, leaves unknown scores unknown, and ends with a
useful result or next action. The methods support general decisions as well as engineering work.
The skill adds no tools, runtime dependencies, or new execution permissions.

## Install structured thinking

For a specific method, install its standalone folder instead, for example
`skills/st-six-hats/`. Each named method contains everything it needs in
`SKILL.md`; it does not require the general toolkit. Install only the methods you want, or all 25.
Use the same copy procedure below, substituting that skill's name in both paths.

Copy the complete skills/structured-thinking/ folder, including references/, into a directory
your agent discovers. Copying only SKILL.md loses the method guides. The following Bash example
starts in this repository; replace the target project path before running it:

```bash
skill_source="$PWD/skills/structured-thinking"
skill_target="/absolute/path/to/your-project/.agents/skills/structured-thinking"
if [ -e "$skill_target" ] || [ -L "$skill_target" ]; then
  printf 'Already exists; compare before updating: %s\n' "$skill_target"
else
  mkdir -p "$(dirname "$skill_target")"
  cp -R "$skill_source" "$skill_target"
fi
```

For an update, compare the installed folder with the source, preserve any local changes, and
replace the complete folder deliberately. Do not install multiple copies under the same name.
No installation is performed by reading this repository or using its validator.

Documented native locations, checked on 2026-10-14:

| Agent | Project skill parent | Global skill parent |
| --- | --- | --- |
| Codex | .agents/skills/ | ~/.agents/skills/ |
| OpenCode V2 | .agents/skills/ or .opencode/skills/ | ~/.config/opencode/skills/ |
| agy CLI | .agents/skills/ | ~/.gemini/antigravity-cli/skills/ |

Append structured-thinking/ to the chosen parent. Discovery varies by host and configuration.
These paths follow [Codex documentation](https://learn.chatgpt.com/docs/build-skills),
[OpenCode V2 documentation](https://opencode.ai/v2/docs/skills/), and
[agy CLI documentation](https://www.agy.dev/docs/skills/). Documentation support is distinct from
the runtime results in [evals/structured-thinking/results.md](evals/structured-thinking/results.md).

## Use structured thinking

Choose `structured-thinking` when you want the agent to select a method. Choose a named skill
when you already know which method to use. For example, after installing its folder:

The method prefix is now `st-`. If you installed the earlier long names, replace those installed
folders or links with their `st-` equivalents and restart your agent session to refresh discovery.

```text
/st-six-hats Should we move the workshop online?
```

The slash form applies to hosts that expose skills as slash commands, such as agy's interactive
CLI. In Codex, use `$st-six-hats` instead. For other hosts, ask
`Use st-six-hats to assess this decision: ...` or provide its `SKILL.md` path.
These are separate named skills, not a custom CLI or universal slash-command registration.

| Named skill | Method |
| --- | --- |
| [st-six-hats](skills/st-six-hats/SKILL.md) | Six Thinking Hats |
| [st-ishikawa](skills/st-ishikawa/SKILL.md) | Ishikawa |
| [st-eisenhower-matrix](skills/st-eisenhower-matrix/SKILL.md) | Eisenhower Matrix |
| [st-second-order-thinking](skills/st-second-order-thinking/SKILL.md) | Second-order thinking |
| [st-iceberg-model](skills/st-iceberg-model/SKILL.md) | Iceberg Model |
| [st-abstraction-laddering](skills/st-abstraction-laddering/SKILL.md) | Abstraction laddering |
| [st-decision-matrix](skills/st-decision-matrix/SKILL.md) | Decision matrix |
| [st-impact-effort-matrix](skills/st-impact-effort-matrix/SKILL.md) | Impact-Effort Matrix |
| [st-connection-circles](skills/st-connection-circles/SKILL.md) | Connection circles |
| [st-ladder-of-inference](skills/st-ladder-of-inference/SKILL.md) | Ladder of inference |
| [st-conflict-resolution](skills/st-conflict-resolution/SKILL.md) | Conflict Resolution Diagram |
| [st-situation-behavior-impact](skills/st-situation-behavior-impact/SKILL.md) | Situation-Behavior-Impact |
| [st-hard-choice-model](skills/st-hard-choice-model/SKILL.md) | Hard choice model |
| [st-zwicky-box](skills/st-zwicky-box/SKILL.md) | Zwicky box |
| [st-ooda-loop](skills/st-ooda-loop/SKILL.md) | OODA loop |
| [st-minto-pyramid](skills/st-minto-pyramid/SKILL.md) | Minto Pyramid |
| [st-concept-map](skills/st-concept-map/SKILL.md) | Concept map |
| [st-cynefin](skills/st-cynefin/SKILL.md) | Cynefin |
| [st-productive-thinking](skills/st-productive-thinking/SKILL.md) | Productive Thinking |
| [st-inversion](skills/st-inversion/SKILL.md) | Inversion |
| [st-issue-trees](skills/st-issue-trees/SKILL.md) | Issue trees |
| [st-confidence-speed-quality](skills/st-confidence-speed-quality/SKILL.md) | Confidence, speed and quality |
| [st-first-principles](skills/st-first-principles/SKILL.md) | First principles |
| [st-balancing-feedback-loop](skills/st-balancing-feedback-loop/SKILL.md) | Balancing feedback |
| [st-reinforcing-feedback-loop](skills/st-reinforcing-feedback-loop/SKILL.md) | Reinforcing feedback |

In a supporting agent, ask naturally:

```text
Use structured-thinking to assess whether we should move the workshop online.
We have attendance records but no cost comparison. Choose a useful method.
```

Or select a method:

```text
Use structured-thinking with a decision matrix to compare these options.
Treat unknown costs as unknown. Show what evidence could change the recommendation.
```

Codex also supports mentioning $structured-thinking. agy's interactive CLI exposes installed
skills as slash commands, including /structured-thinking. These are host features, not new
commands installed by this package. The same plain-language request works without an adapter.

For an agent with file access but no native skill discovery, give the actual entrypoint path:

```text
Read skills/structured-thinking/SKILL.md and its relevant method reference.
Use it to examine this decision: [your decision and available evidence].
```

That relative path assumes this repository is the working directory; use the installed path
elsewhere. For an agent without file access, paste the entrypoint contents, ask which guide it
needs, then supply that guide's contents with your task. File-reading and discovery are not
claimed for hosts that lack those capabilities. Referenced websites are attribution, not a
requirement for network access during ordinary use.

By default, results stay in the conversation. Request a file if you want one. An analysis request
does not authorize implementation; already authorized work does not require a special APPLY word.

## Check structured thinking

```bash
bash scripts/validate-skill.sh structured-thinking
go run scripts/generate-structured-thinking.go -check
go test scripts/generate-structured-thinking.go scripts/generate-structured-thinking_test.go
```

The named skills are generated from the general toolkit's routing table, reference guides, and
shared evidence/output rules. Edit those canonical sources, then run
`go run scripts/generate-structured-thinking.go` from this repository root. Commit the generated
folders alongside the source changes. `-check` detects missing or stale outputs without writing.
The generator refuses to replace an existing skill without its generated-file marker.
Go is a maintainer-only requirement; installed skills need no runtime or generator.
See [named-skill checks](evals/structured-thinking/named-skills.md) for the scope of validation.

This existing check is shallow: it does not prove YAML validity, method correctness, or improved
answers. See [evals/structured-thinking/cases.md](evals/structured-thinking/cases.md) for behavioral
cases and [evals/structured-thinking/results.md](evals/structured-thinking/results.md) for receipts,
limitations, and baseline comparisons. There is no application build or typecheck for this package.

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

## Credits

This repo's conventions were learned from others, not invented here:

- **[mattpocock/skills](https://github.com/mattpocock/skills)** (Matt Pocock) — the bucket layout (`skills/<bucket>/<name>/`), per-bucket `README.md`s, `scripts/link-skills.sh` / `scripts/list-skills.sh`, and the [`.out-of-scope/`](.out-of-scope/) convention for recording rejected ideas instead of only in commit messages are all adapted directly from his repo. His [`writing-great-skills`](https://github.com/mattpocock/skills/blob/main/skills/productivity/writing-great-skills/SKILL.md) skill and its glossary also shaped how the skills here are written — description hygiene, cutting duplication, and the vocabulary for what makes a skill predictable rather than just plausible-sounding.
- **[vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)** — the `skills.sh.json` grouping format and the general shape of this README (badge, "what it does / use when" summaries per skill) come from theirs.
- **[Agent Skills specification](https://agentskills.io/)** — the open format every skill here implements, and the source for the authoring best-practices this repo tries to follow.

If you're setting up your own skills repo, all three are worth reading directly.

## License

MIT

## Author

Jad Madi — [github.com/jadmadi](https://github.com/jadmadi)
