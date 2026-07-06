# Not adopted from mattpocock/skills: release tooling, plugin manifest, docs site

When restructuring this repo to follow [mattpocock/skills](https://github.com/mattpocock/skills)'s
bucket convention, several other things in that repo were deliberately left out rather
than silently skipped:

- **Changesets + `CHANGELOG.md` + `package.json` + `.github/workflows/release.yml`** —
  real, working release automation, but it's a meaningful ongoing commitment (learning
  and maintaining the changesets workflow, a CI pipeline) that isn't proportionate to a
  first-time-published, 5-skill repo. Worth adopting if/when this repo has enough churn
  that hand-written commit messages stop being enough of a changelog.
- **`.claude-plugin/plugin.json`** — packages the repo as a Claude Code plugin, an
  additional distribution channel beyond skills.sh. Reasonable to add later; skipped for
  now to avoid Claude-specific coupling before the skills.sh distribution path is even
  proven out.
- **`docs/<bucket>/<skill-name>.md` mirror tree** — mattpocock publishes these to his own
  site (`aihero.dev`). Not applicable here; there's no companion site to publish to.
- **`CONTEXT.md` (domain glossary)** — mattpocock's is built iteratively by his
  `grill-with-docs` skill for a specific project's jargon. This repo doesn't have
  proprietary jargon dense enough to need translation yet.
- **`ask-matt`-style router skill** — routes between multiple *user-invoked* skills.
  Every skill in this repo is currently model-invoked; there's nothing to route between
  yet. Revisit if a user-invoked skill gets added.

None of these are rejected outright — they just don't earn their cost yet at this repo's
current size. Revisit as the collection grows.
