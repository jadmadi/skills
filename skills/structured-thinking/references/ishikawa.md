# Ishikawa diagram

Use for a defined undesirable effect with several possible causes. Supply the
effect, boundaries, timing, and available observations or logs.

## Procedure

1. State the effect precisely; separate its frequency from guesses about its cause.
2. Choose categories suited to the context, such as data, process, environment,
   tools, or measurement. Do not force a manufacturing category list onto software.
3. Add candidate causes and mechanisms under the relevant branches. Follow a
   branch deeper only when it yields a distinguishable explanation.
4. Mark each candidate supported, contradicted, or untested using available evidence.
5. Rank the next checks by their ability to distinguish causes and their practical cost.

Output a text fishbone or grouped cause table with evidence and next checks. Stop
when the most useful diagnostic action is identified, or a cause is demonstrated.
The diagram itself does not establish a root cause or a probability ranking.

## Example and boundary

Uploads fail only above 10 MB after a proxy change. Branches include client limits,
proxy limits, server parsing, and measurement errors. The timing supports inspecting
proxy configuration; it does not prove causality. Compare requests just below and
above the limit in an authorized test before recommending a configuration change.
Do not claim the test ran if only a log excerpt was supplied.

## Source

Kaoru Ishikawa's cause-and-effect method, summarized by
[Untools](https://untools.co/ishikawa-diagram/).
