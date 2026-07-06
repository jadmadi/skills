# AGENTS.md

This repository is a collection of [Agent Skills](https://agentskills.io/) published for distribution via [skills.sh](https://skills.sh) and the `skills` CLI (`npx skills add jadmadi/skills`). There is no application to build or run here — the "product" is the `SKILL.md` files themselves.

## Repository layout

```
skills/<skill-name>/SKILL.md   # one directory per skill
skills.sh.json                 # groups skills into sections on the skills.sh repo page
README.md                      # human-facing catalog of skills
```

## Adding or editing a skill

Follow the [Agent Skills specification](https://agentskills.io/specification):

- `name` (required): max 64 chars, lowercase letters/numbers/hyphens only, no leading/trailing/consecutive hyphens, **must match the parent directory name**.
- `description` (required): max 1024 chars. State both *what the skill does* and *when to use it* — include the specific trigger phrases a user would actually type. Err on the side of a slightly "pushy" description; under-triggering is the more common failure mode.
- `license`, `metadata` (optional): this repo sets `license: MIT` and `metadata.author: jadmadi` on every skill for consistency.
- Keep the `SKILL.md` body under ~500 lines / 5000 tokens. If a skill needs more, split detail into `references/` and point to it explicitly ("read `references/x.md` when Y") rather than letting SKILL.md grow unbounded.
- Don't split just to hit a line count — only split along a real, observable branching condition (see the skill's own decision logic). A monolithic file that's always fully relevant beats a split one with router overhead.
- Never publish project-specific secrets, internal domain names, or proprietary business logic. If a skill started life as a checklist for one specific codebase, generalize it (parameterize the specifics, keep the *shape* of the check) before it lands here — see `skills/pre-flight-check/SKILL.md` for an example of a genericized template.

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
