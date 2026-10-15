# Facts: Portable structured thinking toolkit

## Approved design choices

- One skill, 25 individually loaded guides; general use with engineering examples.
- Skills and install guidance only; no installer, new CLI, adapters, or global installation.
- English authoring; output follows the user's language and requested format.
- User authorization persists. No extra APPLY keyword or forced planning barrier.

## Source reconciliation

Read ideas/Structured-Thinking-Agent/structured-thinking.md first, then Astra.md, claude.md,
Deepseekv4.1-flash.md, GLM5.3.md, and gemini4-argon.md in that directory. These ignored local
files are preserved unchanged. Astra supplied selective routing; Claude and GLM supplied practical
examples; Gemini supplied per-method output ideas. None is treated as factual authority.

Correct hard-choice axes to impact/comparability; keep reversibility separate. Preserve Productive
Thinking's six stages. Reject deterministic-engine claims, invented CLI flags, rigid idea quotas,
unsupported causality, and shortcuts that sacrifice essential correctness or privacy.

## Grounded environment

The initial branch is master at 3d12d0f. Existing changes include .gitignore and untracked AGENTS.md,
agent wiring and goals/sila-onboarding/. They are not this task's authored content.
The fetched origin/main has a different repository layout and a tracked AGENTS.md; checkout from
this working tree failed because it would overwrite that existing untracked file. Do not force it.
Integration therefore uses /tmp/structured-thinking-integration-KNJQS0 on feat/structured-thinking,
based on origin/main 011b8b13fcf50b4976368031a617c7a1ac5b6b71. Package bytes match the original
checkout; each README retains its existing catalog. The approved skills/structured-thinking/ path
is preserved rather than forcing a single general toolkit into an engineering-only bucket.

The existing scripts/validate-skill.sh passes for codebase-artifact but is a shallow structural
check, not a YAML parser or behavioral test. No application build or typecheck is configured.
Codex and agy native discovery and selected-reference loading passed. OpenCode was not found on
PATH and remains documentation-verified only. All 33 specified cases passed independent review;
six controlled same-model comparisons showed no demonstrated uplift. Full evidence and candidate
hashes are recorded in evals/structured-thinking/results.md.

The test command was added to AGENTS.md, satisfying Sila's runbook detection.
The full pre-commit Sila gate now passes cleanly.

