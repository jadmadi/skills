# AGENTS.md

This repository is a collection of [Agent Skills](https://agentskills.io/) published for distribution via [skills.sh](https://skills.sh) and the `skills` CLI (`npx skills add jadmadi/skills`). There is no application to build or run here — the "product" is the `SKILL.md` files themselves.

These skills must work across agents (Claude Code, Cursor, Windsurf, Codex, Devin, etc.), not just one. When in doubt, prefer the plain [agentskills.io](https://agentskills.io/specification) format over a client-specific feature.

**References worth re-reading before a substantial edit:**

- [Agent Skills specification](https://agentskills.io/specification) — the cross-agent format this repo targets
- [Claude: Agent Skills overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) and [authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) — the most detailed single source on context budget and progressive disclosure
- [mattpocock/skills: writing-great-skills](https://github.com/mattpocock/skills/blob/main/skills/productivity/writing-great-skills/SKILL.md) (+ its [GLOSSARY.md](https://github.com/mattpocock/skills/blob/main/skills/productivity/writing-great-skills/GLOSSARY.md)) — sharpest vocabulary for description hygiene and pruning (context load vs. cognitive load, leading words, no-ops, sprawl)

## Repository layout

```
skills/<skill-name>/SKILL.md   # one directory per skill
skills.sh.json                 # groups skills into sections on the skills.sh repo page
README.md                      # human-facing catalog of skills
```

## Adding or editing a skill

Follow the [Agent Skills specification](https://agentskills.io/specification):

- `name` (required): max 64 chars, lowercase letters/numbers/hyphens only, no leading/trailing/consecutive hyphens, **must match the parent directory name**. Claude Code additionally rejects the substrings "anthropic" and "claude" and any XML tags in `name`/`description` — avoid those regardless of target client.
- `description` (required): max 1024 chars. State both *what the skill does* and *when to use it*, in third person / bare-imperative voice ("Extract...", "Scan...", not "I can help..." or "You can use this to..."). Include specific trigger phrases a user would actually type — under-triggering is the more common failure mode, so don't be shy about coverage.
- **But don't pad with synonyms of the same trigger.** One phrase per distinct concept; three ways of saying the same thing costs context on every turn and adds nothing a matcher can use. `cf-cpu-audit`'s description used to repeat "review my worker for performance" verbatim and list four synonyms for "optimize" — that was a bug, not thoroughness. When editing a description, ask of each phrase: does this cover a genuinely different scenario, or just reword one already covered?
- **Naming style:** Anthropic's docs prefer gerund form (`processing-pdfs`) but explicitly accept noun phrases (`pdf-processing`) and action-oriented names (`process-pdfs`) as alternatives — vague (`helper`, `utils`) or overly generic names are what to actually avoid. This repo intentionally uses short noun-phrase/mnemonic names (`adoo`, `cf-cpu-audit`, `cf-d1-audit`, `pre-flight-check`) for consistency with copies of these same skills already deployed across other tool configs — don't rename to gerund form just for its own sake, that'd break that consistency for no real gain.
- **Invocation:** every skill here is model-invoked (it keeps its `description` so the agent can fire it autonomously, not just by typed name) because each one needs to trigger from context, not only from a deliberate command. If a future skill should *only* ever be invoked by explicit name (e.g. a one-off setup wizard you'd never want firing itself mid-task), that's what `disable-model-invocation: true` is for — but note it's not part of the base agentskills.io spec, so treat it as an enhancement some clients honor rather than something to rely on everywhere.
- `license`, `metadata` (optional): this repo sets `license: MIT` and `metadata.author: jadmadi` on every skill for consistency.
- Keep the `SKILL.md` body under ~500 lines / 5000 tokens. If a skill needs more, split detail into `references/` and point to it explicitly ("read `references/x.md` when Y") rather than letting SKILL.md grow unbounded.
- Don't split just to hit a line count — only split along a real, observable branching condition (see the skill's own decision logic). A monolithic file that's always fully relevant beats a split one with router overhead. A skill that's all reference material with no branches (an audit checklist, a review rubric) is a legitimate flat structure, not something to force into a hierarchy it doesn't need.
- **Never bake in one client's UI/tool syntax.** `cf-cpu-audit` used to tell the agent to cite findings with Devin CLI's `<ref_snippet>` tag — meaningless literal text in Claude Code, Cursor, or anywhere else that doesn't parse that tag. Describe the desired output generically ("cite file path and line number, using your tool's citation syntax if it has one") and let each agent use its own mechanism.
- Only add content the agent wouldn't already know or do by default — a line that restates default behavior ("be thorough", "handle errors appropriately") costs tokens without changing anything. Prefer a specific, concrete instruction over a generic exhortation.
- Never publish project-specific secrets, internal domain names, or proprietary business logic. If a skill started life as a checklist for one specific codebase, generalize it (parameterize the specifics, keep the *shape* of the check) before it lands here — see `skills/pre-flight-check/SKILL.md` for an example of a genericized template.

## Keeping other local copies in sync

Some of these skills also live as plain copies in this machine's other tool
configs (`~/.claude/skills`, `~/.config/devin/skills`, etc.), predating this
repo. `scripts/sync-local.sh` (gitignored — machine-specific, not part of
the published collection) pushes this repo's canonical content out to any
of those that already exist, without installing into new locations unless
asked. Once these skills are installed via `npx skills add jadmadi/skills`
(see README.md) and kept current with `skills update`, the CLI manages its
own local copy and symlinks it into each agent's directory — at that point
this script has nothing left to reconcile and can be deleted.

## Validating

There's no npm package for this yet. The reference validator is a Python tool
in [agentskills/agentskills](https://github.com/agentskills/agentskills/tree/main/skills-ref):

```bash
git clone https://github.com/agentskills/agentskills
cd agentskills/skills-ref && uv sync && source .venv/bin/activate
skills-ref validate /path/to/jadmadi/skills/skills/<skill-name>
```

At minimum, sanity-check by hand: frontmatter parses as YAML, `name` matches
the directory name, `description` is non-empty and under 1024 chars.

## Updating the catalog page

If a new skill is added, also:

1. Add an entry to `README.md` under "Available Skills" with a 1-2 sentence summary and a "Use when" bullet list.
2. Add the skill's slug to a group in `skills.sh.json` (or leave it ungrouped — it'll surface under "Other skills").
