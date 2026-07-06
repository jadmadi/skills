# adoo: no Stage 5, no via-negativa tie-break

A round of feedback (philosophy-flavored: mapping ADOO's stages to epistemological
lineages) proposed two additions to `skills/engineering/adoo/SKILL.md`. Both were
evaluated on whether they'd actually change agent behavior, not on how the proposal
was framed. Recorded here so the reasoning doesn't have to be re-derived if it comes
up again.

## Rejected: formal Stage 5 ("Reflect")

Proposed adding a 5th stage for converting a local fix into systemic knowledge
(regression test, doc correction, "architectural invariant" comment, a takeaway
lesson for future agents).

**Why rejected as proposed:** it breaks the acronym. ADOO is invoked by name
("use ADOO", `/adoo`) — a 5th stage means it's no longer ADOO, and that costs the
thing that makes the skill memorable and easy to trigger, for a proposal that
didn't weigh that cost at all.

**What survived anyway:** the durable, concrete parts (promote a manual
reproduction to an automated regression test; correct documentation that stated
the actual wrong assumption) were folded into the existing Stage 4 (Optimize)
instead — see the "Verify" bullet and the doc-correction bullet there. The vaguer
parts ("leave an architectural invariant comment", "write a one-sentence takeaway
lesson for future agents") were dropped: neither is anchored to a durable location,
so neither would reliably survive past the current session — the "amnesia" problem
they were supposedly fixing.

## Rejected: via-negativa tie-break ("prefer removing/simplifying over adding a guard")

Proposed adding: when multiple small fixes are possible, prefer the one that
removes or simplifies faulty logic over one that adds a new guard/branch.

**Why rejected:** Stages 1-3 already force the fix to target the *root cause*
(Assess explicitly separates symptom from root cause; Optimize fixes "the
candidate root cause from stage 3", not the symptom site). A separate
subtraction-over-addition rule doesn't add anything stages 1-3 don't already
enforce by a different, more direct mechanism — and it actively risks biasing
the agent away from a *correct* additive fix (e.g. a null check that should have
existed at the root cause) toward deletion for its own sake. That's a new
anti-pattern risk, not an improvement.

## Also rejected: importing the philosophical vocabulary into the file

Terms like "Occam's Razor," "pre-mortem," "Hegelian antithesis" were suggested as
in-file labels for instructions ADOO already states in plain language
("smallest blast radius", etc.). Naming a philosophy behind an instruction that
already exists doesn't change what the agent does — it's a no-op by definition,
and it would have been the file's first departure from otherwise avoiding jargon
entirely.
