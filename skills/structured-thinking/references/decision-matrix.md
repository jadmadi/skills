# Decision matrix

Use to compare feasible options against criteria the decision-maker can explain.
Supply options, hard constraints, preferences, and evidence for ratings.

## Procedure

1. Eliminate options violating hard constraints before scoring. A high total cannot
   compensate for an unacceptable constraint violation.
2. Use supplied criteria and weights. Otherwise propose a small set, label it as
   provisional, and ask only if the preference could materially change the decision.
3. Define a common rating direction, with higher meaning better. Unless supplied,
   use anchored 1–5 ratings and weights totaling 100%. Explain qualitative estimates.
4. Show each rating's evidence. Keep missing ratings unknown, not zero or midpoint.
   Do not silently renormalize weights around missing data and compare unequal totals.
5. For complete rows, compute total = sum(weight fraction × rating). Check arithmetic.
   For incomplete rows, show a justified range or withhold an overall ranking.
6. Test plausible weight or rating changes. State when the winner changes, or why
   tested changes do not alter it. Do not force a winner in a tie or fragile result.

Output the matrix, evidence notes, sensitivity result, and recommendation or missing
information. Stop when the comparison supports a choice or a discriminating check.

## Example and boundary

For fit and ease, weights are 60% and 40%. A scores 5 and 2; B scores 3 and 5.
A totals 3.8; B totals 3.8. With fit weight w, A = 2 + 3w and B = 5 - 2w;
the tie is w = 0.6. Above that A wins, below it B wins. Report preference sensitivity,
not a decisive winner. If B's ease rating is unknown, its total is unknown too.

## Source

[Untools: Decision matrix](https://untools.co/decision-matrix/). Rating defaults,
missing-data handling, and the arithmetic example are adaptations for agent use.
