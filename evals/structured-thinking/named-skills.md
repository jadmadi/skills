# Named structured-thinking skills

## Short-name update, 2026-10-15

All 25 method packages now use `skills/st-*/SKILL.md` and matching `name: st-*` frontmatter.
The general `structured-thinking` selector keeps its original name. The generator, its tests
and README command catalog use the new prefix. The earlier sections below record the original
long-name delivery; use `skills/st-*` in its validator loop today.

Generator check, targeted Go tests, Go vet, all 25 skill validators and git diff --check pass
after the rename. Both repository checkouts contain the short names. Methods are unchanged.
Existing links were migrated for all 25 methods in each of ~/.agents/skills, ~/.claude/skills,
~/.config/devin/skills and ~/.codeium/windsurf/skills: 100 verified links in total.
Old links were archived outside discovery directories at
/home/jad/.local/state/st-old-links-4177490132. The first archive attempt hit a cross-device
rename error before moving any old links; retrying with an archive on the home filesystem passed.
No new installation destinations were added. Restart the client to refresh its skill catalog.
Native runtime invocation of the renamed methods remains untested.
Independent reviewer /root/named_skills_review accepted the rename with no findings:
25 matching directory/frontmatter names, no old named directories, updated README, and
generator check, Go tests and Go vet all exit 0. Installed links were outside that review.

## Original named-skill delivery

Date: 2026-10-14. User-approved extension: expose every method as an independently
installable skill, retaining the general toolkit for method selection.

## Implementation and evidence

The 25 skills under skills/structured-thinking-*/ contain one self-contained SKILL.md each.
The six-hats suffix is intentional; other suffixes match the canonical reference basenames.
scripts/generate-structured-thinking.go derives descriptions from the router and embeds each
method body verbatim alongside the toolkit's shared evidence, output and provenance sections.
The original toolkit and its recorded candidate hashes are unchanged.

Maintainer commands, run from the repository root, all exit 0:

```bash
go run scripts/generate-structured-thinking.go -check
go test scripts/generate-structured-thinking.go scripts/generate-structured-thinking_test.go
go vet scripts/generate-structured-thinking.go scripts/generate-structured-thinking_test.go
for skill in skills/structured-thinking-*; do
  bash scripts/validate-skill.sh "${skill##*/}" || exit
done
git diff --check
```

Execution used Go 1.27.2 through /home/jad/.local/share/mise/shims/go and a disposable
GOCACHE under /tmp. The generator is maintained here because repeated source synchronization
is required. It is not an installed-skill dependency and is not promoted to go-tools.

Tests cover all 25 verbatim method bodies, standalone reference independence, missing outputs,
drift, refusal to overwrite unmanaged skills, and no partial generation on malformed sources.
The first test run failed because Go runs tests from scripts/, not the repository root.
The fixture now resolves ../skills/structured-thinking; tests and vet pass after that correction.
A one-off Go check using the already cached yaml.v3 parser also passed all 25 frontmatter
documents, directory/name agreement, description limits and external-only Markdown links.
That checker is a disposable validation aid, not shipped project tooling.

## Independent review

Reviewer: /root/named_skills_review. Accepted after the fixture-path correction.
The reviewer independently ran generator check, Go tests and Go vet, each exit 0, and checked
self-contained content, shared evidence and authorization rules, method-specific descriptions,
the six-hats name, and README's complete command list and host-syntax distinctions.
No remaining blocking findings in that scope.

## Limits and next step

These checks prove packaging and synchronization, not reasoning quality or native discovery of
the new names. The earlier framework evaluations remain evidence for the unchanged method
instructions. Native Codex/agy receipts in results.md cover the original toolkit only;
the 25 new names have not been exercised in CLI runtimes. OpenCode remains runtime-untested.
No application build or application typecheck is configured; the generator has targeted Go
tests and vet checks. No global installation or remote push was performed.

Files are mirrored into the existing feat/structured-thinking integration checkout at
/tmp/structured-thinking-integration-KNJQS0. The existing Sila commit-gate blocker remains
unresolved; no hooks were bypassed. Next: install desired named folders in an agent's skill
directory for use, and resolve the separate repository gate before committing the delivery.
