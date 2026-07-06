# AGENTS.md

This repository is a collection of [Agent Skills](https://agentskills.io/) published for distribution via [skills.sh](https://skills.sh) and the `skills` CLI (`npx skills add jadmadi/skills`). There is no application to build or run here — the "product" is the `SKILL.md` files themselves.

These skills must work across agents (Claude Code, Cursor, Windsurf, Codex, Devin, etc.), not just one. When in doubt, prefer the plain [agentskills.io](https://agentskills.io/specification) format over a client-specific feature.

**References worth re-reading before a substantial edit:**

- [Agent Skills specification](https://agentskills.io/specification) — the cross-agent format this repo targets
- [Claude: Agent Skills overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) and [authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) — the most detailed single source on context budget and progressive disclosure
- [mattpocock/skills: writing-great-skills](https://github.com/mattpocock/skills/blob/main/skills/productivity/writing-great-skills/SKILL.md) (+ its [GLOSSARY.md](https://github.com/mattpocock/skills/blob/main/skills/productivity/writing-great-skills/GLOSSARY.md)) — sharpest vocabulary for description hygiene and pruning (context load vs. cognitive load, leading words, no-ops, sprawl)

## Repository layout

```
skills/<bucket>/<skill-name>/SKILL.md   # one skill per directory, grouped into buckets
TEMPLATE/SKILL.md.template              # scaffold for new skills -- deliberately NOT named
                                         # SKILL.md (see below) so it can never be discovered
                                         # as an installable skill
skills.sh.json                          # groups skills into sections on the skills.sh repo page
README.md                               # top-level human-facing catalog
skills/<bucket>/README.md               # per-bucket catalog
.out-of-scope/                          # additions that were considered and rejected, with why
```

Structure follows [mattpocock/skills](https://github.com/mattpocock/skills)'s bucket convention, scaled down to this repo's size. Current buckets:

- `engineering/` — debugging, pre-ship checklists, codebase documentation
- `cloudflare/` — Cloudflare Workers / D1 specific audits

Add a new bucket when a skill doesn't fit an existing one — don't force everything into `engineering` just to avoid creating a folder, and don't create a bucket for a single skill unless more in that space are clearly coming (the way `cloudflare/` was justified by there already being a second Cloudflare-specific skill, not just one). If a skill isn't ready to publish yet or is being retired, mirror mattpocock's `in-progress/` / `deprecated/` buckets rather than half-shipping it in a promoted one.

**A directory anywhere in this repo containing a file literally named `SKILL.md` with a valid `name`+`description` is installable, full stop** — confirmed by reading the `skills` CLI's own discovery code (`discoverSkills` in [vercel-labs/skills](https://github.com/vercel-labs/skills)'s `src/skills.ts`): it scans the repo root's direct subdirectories unconditionally, not just paths under `skills/`.

The CLI also documents `metadata.internal: true` as a way to hide a skill from discovery unless `INSTALL_INTERNAL_SKILLS=1` is set or it's requested by exact name. **Don't rely on that flag alone** — it's inconsistently honored across the CLI's own code paths in practice (a plain `--list` respects it; the interactive "select skills to install" prompt, reached via the default `npx skills add jadmadi/skills` with no flags, does not — verified against a real install, twice, not just by reading the source). The actual, reliable fix used here: `TEMPLATE`'s scaffold file is named `SKILL.md.template`, not `SKILL.md`, so no discovery code path can find it regardless of flags or bugs in a specific one. `create-skill.sh` renames it to `SKILL.md` (and strips the `internal: true` line it also carries as defense in depth) only when scaffolding a real skill. If you ever add another non-shippable `SKILL.md`-shaped file to this repo, give it the same treatment — don't trust `internal: true` as the only line of defense.

## Adding or editing a skill

Follow the [Agent Skills specification](https://agentskills.io/specification):

- `name` (required): max 64 chars, lowercase letters/numbers/hyphens only, no leading/trailing/consecutive hyphens, **must match the parent directory name** (not the bucket — just the skill's own directory). Claude Code additionally rejects the substrings "anthropic" and "claude" and any XML tags in `name`/`description` — avoid those regardless of target client.
- `description` (required): max 1024 chars. State both *what the skill does* and *when to use it*, in third person / bare-imperative voice ("Extract...", "Scan...", not "I can help..." or "You can use this to..."). Include specific trigger phrases a user would actually type — under-triggering is the more common failure mode, so don't be shy about coverage.
- **But don't pad with synonyms of the same trigger.** One phrase per distinct concept; three ways of saying the same thing costs context on every turn and adds nothing a matcher can use. `cf-cpu-audit`'s description used to repeat "review my worker for performance" verbatim and list four synonyms for "optimize" — that was a bug, not thoroughness. When editing a description, ask of each phrase: does this cover a genuinely different scenario, or just reword one already covered?
- **Naming style:** Anthropic's docs prefer gerund form (`processing-pdfs`) but explicitly accept noun phrases (`pdf-processing`) and action-oriented names (`process-pdfs`) as alternatives — vague (`helper`, `utils`) or overly generic names are what to actually avoid. This repo intentionally uses short noun-phrase/mnemonic names (`adoo`, `cf-cpu-audit`, `cf-d1-audit`, `pre-flight-check`) for consistency with copies of these same skills already deployed across other tool configs — don't rename to gerund form just for its own sake, that'd break that consistency for no real gain.
- **Invocation:** every skill here is model-invoked (it keeps its `description` so the agent can fire it autonomously, not just by typed name) because each one needs to trigger from context, not only from a deliberate command. If a future skill should *only* ever be invoked by explicit name (e.g. a one-off setup wizard you'd never want firing itself mid-task), that's what `disable-model-invocation: true` is for — but note it's not part of the base agentskills.io spec, so treat it as an enhancement some clients honor rather than something to rely on everywhere.
- `license`, `metadata` (optional): this repo sets `license: MIT` and `metadata.author: jadmadi` on every skill for consistency.
- Keep the `SKILL.md` body under ~500 lines / 5000 tokens. If a skill needs more, split detail into `references/` and point to it explicitly ("read `references/x.md` when Y") rather than letting SKILL.md grow unbounded.
- Don't split just to hit a line count — only split along a real, observable branching condition (see the skill's own decision logic). A monolithic file that's always fully relevant beats a split one with router overhead. A skill that's all reference material with no branches (an audit checklist, a review rubric) is a legitimate flat structure, not something to force into a hierarchy it doesn't need.
- **Never bake in one client's UI/tool syntax.** `cf-cpu-audit` used to tell the agent to cite findings with Devin CLI's `<ref_snippet>` tag — meaningless literal text in Claude Code, Cursor, or anywhere else that doesn't parse that tag. Describe the desired output generically ("cite file path and line number, using your tool's citation syntax if it has one") and let each agent use its own mechanism.
- Only add content the agent wouldn't already know or do by default — a line that restates default behavior ("be thorough", "handle errors appropriately") costs tokens without changing anything. Prefer a specific, concrete instruction over a generic exhortation.
- Never publish project-specific secrets, internal domain names, or proprietary business logic. If a skill started life as a checklist for one specific codebase, generalize it (parameterize the specifics, keep the *shape* of the check) before it lands here — see `skills/engineering/pre-flight-check/SKILL.md` for an example of a genericized template.

## Local development: linking skills into your own agent configs

`scripts/link-skills.sh` symlinks every skill in this repo into this
machine's agent config directories (`~/.claude/skills`, `~/.config/devin/skills`,
`~/.agents/skills`, `~/.codeium/windsurf/skills`, `~/.cursor/skills` — whichever
exist). Because each entry is a symlink into this repo rather than a copy, a
`git pull` (or a local edit) is immediately live everywhere — there's nothing
to re-sync. Re-run it after adding, removing, or renaming a skill.

This is for local development on this repo itself. End users installing via
`npx skills add jadmadi/skills` (see README.md) get the equivalent behavior
automatically — that CLI also symlinks by default (`--copy` opts into real
copies instead) and `skills update` keeps it current.

## Validating

Two levels:

1. **Fast local check** (frontmatter present, `name` matches directory and is
   spec-valid, `description` non-empty and ≤1024 chars, body ≤500 lines):
   ```bash
   scripts/validate-skill.sh <bucket>/<skill-name>
   ```
2. **Authoritative check** before publishing — the real reference validator,
   a Python tool in [agentskills/agentskills](https://github.com/agentskills/agentskills/tree/main/skills-ref):
   ```bash
   git clone https://github.com/agentskills/agentskills
   cd agentskills/skills-ref && uv sync && source .venv/bin/activate
   skills-ref validate /path/to/jadmadi/skills/skills/<bucket>/<skill-name>
   ```

## Updating the catalog

If a new skill is added:

1. Add an entry to `skills/<bucket>/README.md` (create the bucket's `README.md` if it's a new bucket).
2. Add the same entry to the top-level `README.md` under the matching bucket section.
3. Add the skill's slug to a group in `skills.sh.json` (create a new group if it's a new bucket, or leave it ungrouped — it'll surface under "Other skills").
4. Run `scripts/link-skills.sh` to pick it up locally.

If a decision gets made about what *not* to add to a skill (an idea considered and rejected, not just skipped silently), write it to `.out-of-scope/<topic>.md` rather than only in the commit message — see `.out-of-scope/adoo-stage-5-and-via-negativa.md` for the shape.

## Versioning

Two layers:

- **Per-skill tags** (`adoo@1.1.0`, `cf-cpu-audit@1.0.0`, etc.) track each skill independently. The tag name matches the skill's directory name; the version matches the `metadata.version` field in its `SKILL.md`. Tag the skill whenever its `metadata.version` bumps.
- **Repo-level milestone tags** (`v1.0.0`, `v1.1.0`, etc.) mark release points where the collection as a whole is in a shippable state. Bump the repo version when a meaningful set of skill changes has accumulated, not on every individual skill bump.

Use [Keep a Changelog](https://keepachangelog.com/) format in `CHANGELOG.md`: a section per skill with version headings, plus a "Repo milestones" section for the repo-level tags. Record what changed and why, not just what — "added pre-mortem step to Optimize" is useful, "updated SKILL.md" is not.

**When to bump a skill's version** (semantic versioning):

- **Patch** (`1.0.0` → `1.0.1`): typo fixes, wording clarifications, reference doc updates — anything that doesn't change what the skill *does*.
- **Minor** (`1.0.0` → `1.1.0`): new steps, new checklist items, new trigger phrases, expanded coverage — the skill does more or does it better, but existing usage still works the same way.
- **Major** (`1.0.0` → `2.0.0`): a stage is renamed or removed, the invocation syntax changes, or existing behavior is replaced rather than extended. Existing users would need to adjust how they invoke or follow the skill.

When you bump a skill's version: update `metadata.version` in its `SKILL.md`, add a `CHANGELOG.md` entry, commit, tag as `<skill-name>@<version>`, and push the tag. When you bump the repo version: tag as `v<version>`, push, and optionally create a GitHub Release from the tag with the relevant CHANGELOG section as release notes.
