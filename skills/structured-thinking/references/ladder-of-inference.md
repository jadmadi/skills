# Ladder of inference

Use to inspect the leap from observations to a conclusion or proposed action.
Supply the claim, actual observations, context, and any already chosen action.

## Procedure

1. State the conclusion or action under examination without endorsing it.
2. Trace its supporting belief, assumptions, interpreted meanings, selected data,
   and original observations. Label gaps rather than inventing missing rungs.
3. Ask what relevant observations were left out or could contradict the conclusion.
4. Offer alternative explanations consistent with the same facts.
5. Choose a check that distinguishes explanations, rather than merely confirming
   the favored one. Revise the conclusion to match the current evidence.

Output a compact evidence-to-claim trace and next check. Stop when the weakest
material inference is identified. This is a review of stated evidence and rationale,
not a demand for an agent's hidden internal reasoning or a person's private motives.

## Example and boundary

"The library is broken" follows one timeout after an upgrade. The observed timeout
is real; attributing it to the library is untested. Network failure and configuration
changes also fit. Compare old and new versions under the same controlled conditions.
Do not conclude the upgrade is innocent either: that also exceeds the evidence.

## Source

Chris Argyris's model, summarized by
[Untools](https://untools.co/ladder-of-inference/).
