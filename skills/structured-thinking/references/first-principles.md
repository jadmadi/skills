# First principles

Use when inherited assumptions constrain a solution unnecessarily. Supply the
desired outcome, known facts, and constraints with their reasons or owners.

## Procedure

1. Separate observed facts, necessary constraints, policy choices, and customary
   implementation choices. Do not call an untested assumption a fundamental truth.
2. Challenge conventions by asking what requirement they serve and whether a
   different mechanism could serve it. Preserve explicit requirements and binding rules.
3. Construct a small set of alternatives from the verified requirements and constraints.
4. Compare with the existing approach, including migration, operational cost, and
   evidence needed to establish feasibility.
5. Recommend the smallest useful change or test. Keeping the current approach is
   a valid conclusion when it already meets the requirements.

Output the facts/constraints/assumptions split, alternatives, and next verification.
Stop when challenging more assumptions no longer changes feasible choices. First
principles is not an instruction to rewrite everything or discard domain expertise.

## Example and boundary

"We need a message broker" may conceal a requirement to process work after a
request finishes. A database-backed queue could be an option if its delivery and
load requirements fit. Do not replace the broker without checking those requirements,
or discard a contractual retention rule because it is not a physical law.

## Source

[Untools: First principles](https://untools.co/first-principles/).
