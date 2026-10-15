# Inversion

Use to reveal avoidable failure mechanisms by reversing a goal. Supply the actual
goal, constraints, and evidence about the current approach.

## Procedure

1. State the outcome to avoid in concrete terms.
2. Identify plausible choices or conditions that could cause it. Keep these as
   failure hypotheses rather than instructions to cause harm.
3. Compare the failure mechanisms with the current approach and available evidence.
4. Convert relevant mechanisms into prevention, detection, or recovery measures.
5. Prioritize by consequence, plausibility, and practical cost. Include a check
   that would show whether a proposed measure works.

Output failure mechanism → evidence → mitigation → verification. Stop when the
important preventable failures have useful controls. Avoid exhaustive doom lists,
fixed quotas, or promises that a guardrail makes failure impossible.

## Example and boundary

For a data migration, unrehearsed conversion and unverified backups could undermine
recovery. Recommend a representative rehearsal and a restore test. These are
proposals until authorized and run. If a restore has already been tested on the
relevant version, acknowledge the evidence rather than inventing a missing control.

## Source

[Untools: Inversion](https://untools.co/inversion/).
