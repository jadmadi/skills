# Issue trees

Use to decompose a broad question into answerable subquestions. Supply the question,
scope, and evidence available for its branches.

## Procedure

1. Choose a diagnostic tree (why) or a solution tree (how). Do not mix these
   unnoticed within a single split.
2. State the splitting rule at each level, such as elapsed phases or customer groups.
3. Aim for branches that do not overlap and jointly cover the scoped question.
   Where that cannot be shown, acknowledge overlap or retain an other/unknown branch.
4. Break down only until leaves can be answered or tested. Annotate evidence,
   unknowns, and dependencies.
5. Prioritize the leaf most likely to affect the answer, accounting for test cost.

Output an indented tree with splitting rules and next checks. Stop when further
decomposition adds structure without changing the investigation. Do not declare
perfect MECE coverage without a defensible boundary and partition.

## Example and boundary

A sequential job takes 20 minutes: queue 4, setup 3, build 5, test 8. A phase tree
identifies testing as the largest measured branch. If build and tests overlap,
their durations cannot simply be added to explain wall time; inspect the critical
path. Unknown gaps belong in an explicit residual branch, not an invented cause.

## Source

[Untools: Issue trees](https://untools.co/issue-trees/).
