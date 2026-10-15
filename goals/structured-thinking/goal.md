# Goal: Portable structured thinking toolkit

## Goal Description
Deliver the approved 25-method portable skill, evaluations and installation guidance. ST-01 through ST-04; evidence ST-AC-01 through ST-AC-06.

User-approved extension: ST-05 adds 25 self-contained named method skills, a source-sync
generator, and invocation documentation. ST-AC-07 and ST-AC-08 are recorded in
evals/structured-thinking/named-skills.md.

## Dependencies & Execution Order
- **Mode**: Independent (disjoint, parallelizable)
- **Depends On**: none
- **Sequence**: -
- **Shape**: ship
- **Tier**: roadmap

## References
- **Shared Understanding & Fact Sheet**: [`goals/structured-thinking/facts.md`](facts.md)
- **Execution Plan**: [`goals/structured-thinking/plan.md`](plan.md)

## Done Condition
1. ST-01 through ST-04 deliver the entrypoint, all 25 guides, evaluations, and install guidance.
2. ST-AC-01 through ST-AC-06 have explicit results and evidence in evals/structured-thinking/results.md.
3. No claim of native compatibility without a runtime receipt; unavailable hosts remain not tested.
4. An independent reviewer accepts the candidate content and evidence, or remaining blockers stay open.
5. A scoped local implementation commit attributes this goal only when its required checks are satisfied.
   This documentation-only package has no application build or typecheck; the skill validator and
   behavioral cases are the relevant checks. Do not invent a Go application test requirement.
