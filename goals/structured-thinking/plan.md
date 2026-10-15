# Plan: Portable structured thinking toolkit

## Shared implementation contract

Cwd: /mnt/Jad/github/lab/jadmadi-skills. Goal: one portable skill that applies all 25
methods without inventing evidence or imposing a new CLI. Why: turn the model proposals
into reusable task guidance. Implementer: root agent. Reviewer: independent review agent.
Read skills/structured-thinking/SKILL.md and ideas/Structured-Thinking-Agent/structured-thinking.md.
The latter is locally ignored source material, not a runtime dependency.

Keep scope to the files assigned below. No runtime dependencies, installer, global configuration
changes, command adapters, remote publication, or unrelated cleanup. Preserve existing dirty files.
Every guide needs purpose, inputs, procedure, output, stop condition, pitfalls, example, and source.
Every material claim must distinguish observations from assumptions. No forced scoring of unknowns.
Stop affected work if blocked. After two failed attempts, return evidence to the planner.

Return fields: status (ready_for_review or blocked), summary, changed_paths, case_results,
commands_and_exits, evidence_paths, candidate_revision_or_sha256, blockers. No self-approval.

## ST-01: Author routing and scope contract

Dependencies: none. Create skills/structured-thinking/SKILL.md, at most 200 body lines.
Interface: ordinary-language task plus optional named method; concise Markdown result by default.
Use one primary method and at most one useful complement unless more are requested. Skip routine tasks.
Example: unknown venue costs remain unknown in a decision matrix; a typo request needs no framework.
ST-AC-01: bash scripts/validate-skill.sh structured-thinking exits 0; inspect YAML, names, and links.

## ST-02: Author complete method guides

Depends on ST-01. Each row is a bounded file batch under
skills/structured-thinking/references/; filenames in a row are the only guide edits for that batch.

| Batch | Files |
| --- | --- |
| ST-02a | six-thinking-hats.md, ishikawa.md, eisenhower-matrix.md, second-order-thinking.md |
| ST-02b | iceberg-model.md, abstraction-laddering.md, decision-matrix.md, impact-effort-matrix.md |
| ST-02c | connection-circles.md, ladder-of-inference.md, conflict-resolution.md, situation-behavior-impact.md |
| ST-02d | hard-choice-model.md, zwicky-box.md, ooda-loop.md, minto-pyramid.md |
| ST-02e | concept-map.md, cynefin.md, productive-thinking.md, inversion.md |
| ST-02f | issue-trees.md, confidence-speed-quality.md, first-principles.md, balancing-feedback-loop.md |
| ST-02g | reinforcing-feedback-loop.md |

Each batch depends on ST-01, not other batches. Acceptance ST-AC-02: its corresponding F01–F25
cases in evals/structured-thinking/cases.md meet behavioral criteria. Example boundary: a causal
chain without a return edge is not a feedback loop. Verify source fidelity independently.

## ST-03: Evaluate behavior and compatibility

Depends on ST-02a through ST-02g. Create evals/structured-thinking/cases.md and results.md.
Raw output receipts belong in evals/structured-thinking/receipts/. These evaluation artifacts are
not installed with the skill. Tests use isolated temporary workspaces and supplied synthetic data.

- ST-AC-02: one case per framework, judged by behavior rather than heading matches.
- ST-AC-03: automatic routing, explicit choice, routine bypass, missing evidence, uncertain weights,
  unsupported causality, analysis-only scope, and already-authorized execution all have cases.
- ST-AC-04: attempt native discovery and selective reference loading in Codex and agy. OpenCode is
  documentation-verified unless an installed runtime is available. Record actual failures.
- ST-AC-05: six identical case inputs with and without the skill on the same identified model.
  Grade evidence, method correctness, usefulness, unnecessary work, and permission compliance.
- ST-AC-06: independent reviewer checks guides and receipts, with findings resolved or reported.

Do not give expected answers to the subject agent. Negative cases must remain genuine negatives.
Do not equate an agent's claim that it read a file with a tool trace showing the read.

## ST-04: Document installation and invocation

Depends on ST-03. Edit README.md only. Explain complete-folder copying, native discovery paths,
plain-language invocation, no-file-access fallback, and compatibility evidence per host.
Example: read the installed SKILL.md, then use a named method on supplied data.
Acceptance: documented install commands work in a disposable directory without overwriting an
existing installation, and each relative documentation link resolves. No global install is performed.

## ST-05: Add independently installable named methods

2026-10-15 user-approved naming update: use `st-*` for all 25 method skill folders and names,
including `st-six-hats`. Keep the general selector's name. Update the generator, tests, README,
and existing local installation links. The long names in the original contract below are
historical; evals/structured-thinking/named-skills.md records migration and current checks.

User-approved extension on 2026-10-14. Depends on ST-01 through ST-04. Cwd remains this
repository. Keep the 25 canonical guides and existing toolkit unchanged. Generate 25 standalone
`skills/structured-thinking-*/SKILL.md` files from those sources. Use the reference basename as
the suffix except `six-thinking-hats` becomes `six-hats`, as requested. Each output embeds its
method and shared evidence/output rules, with no sibling skill dependency.

Allowed edits: scripts/generate-structured-thinking.go and its test; README.md; this goal's
documents; evals/structured-thinking/named-skills.md; the 25 generated entrypoints. Mirror these
changes into the existing integration checkout, preserving its README catalog and changelog.
This batch exceeds four output files because all 25 are deterministic products of one generator.
No global installation, custom command adapter, changed method semantics, push, or hook bypass.
The generator stays in this repository as a maintained source-sync tool, not a go-tools promotion.

Example: `structured-thinking-six-hats` contains all six perspectives and does not invent reported
feelings. An isolated decision-matrix package retains unknown-score handling without reading the
general toolkit. Existing method behavior receipts do not prove native discovery of new names.

ST-AC-07: generator `-check` exits 0 for all 25 outputs; unit tests reject missing/stale outputs,
unmanaged overwrites and malformed source without partial generation. Each method body remains
verbatim and packages have no relative guide dependencies. Existing skill validator passes all 25.
ST-AC-08: README lists each actual name, distinguishes host syntax, and documents source maintenance.
Record validation and independent review in evals/structured-thinking/named-skills.md. Return files,
commands/exits, evidence and blockers. Preserve the existing commit-gate blocker until resolved.

- [x] ST-05: all 25 named packages, generator checks, and independent review accepted.
  Evidence: evals/structured-thinking/named-skills.md. New-name native runtime checks are not claimed.

## Execution state (original delivery)

- [x] ST-01: entrypoint and static checks accepted.
- [x] ST-02: all guides and method cases accepted.
- [x] ST-03: evaluations and independent review recorded.
- [x] ST-04: installation guide and scoped handoff accepted.

Independent reviewer accepted content and bounded evidence in
evals/structured-thinking/receipts/review-final.md. No quality uplift over baseline is claimed.
Local commit remains blocked by the existing Sila hook, whose full gate finds no application test
command and reports clean=false. Do not bypass the hook or claim commit attribution is complete.
The goal stays open for that integration step; package implementation and acceptance are recorded
separately in evals/structured-thinking/results.md.
