# Connection circles

Use to explore causal hypotheses among variables that can change. Supply a bounded
system, observations, and a question about its behavior. For entities connected by
noncausal relationships, use a concept map instead.

## Procedure

1. Choose variables with clear meanings, such as queue length or available capacity.
2. For each proposed directed link, explain the mechanism and evidence status.
   A positive sign means same-direction change, negative means opposite-direction
   change, with other relevant conditions held constant. Signs do not mean good or bad.
3. Trace closed paths. A path without a return link is not a feedback loop.
4. Classify a loop by sign parity: an even number of negative links is reinforcing;
   an odd number is balancing. Include material delays and boundary conditions.
5. Identify a test or intervention and possible side effects. Do not infer a
   numerically strongest influence from a qualitative diagram alone.

Output a variable list, signed edges with mechanisms, closed loops if supported,
and unknowns. A plain edge list is enough. Stop when the map explains a useful
hypothesis; do not invent return edges to ensure the diagram contains a loop.

## Example and boundary

Backlog → overtime (+), overtime → fatigue (+), fatigue → mistakes (+), and
mistakes → rework backlog (+) form a hypothesized reinforcing loop. Each link
needs evidence, and overtime can also reduce backlog directly, a competing effect.
If only backlog and overtime were observed together, the complete loop is not proven.

## Source

[Untools: Connection circles](https://untools.co/connection-circles/).
