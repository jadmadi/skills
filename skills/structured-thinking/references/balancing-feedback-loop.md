# Balancing feedback loop

Use to examine a closed mechanism that counteracts change. Supply changing
variables, observed responses, system boundaries, and any target or constraint.

## Procedure

1. Identify the state and the mechanism responding to it. If goal-seeking, name
   the target, sensed state, gap, and corrective action. Not all balancing loops
   have an explicit controller or intentional goal.
2. Draw directed links with mechanisms and signs: positive means same-direction
   change, negative means opposite-direction, other conditions held constant.
3. Verify a closed path with an odd number of negative links. A one-way reduction
   is not feedback. Label unverified links as hypotheses.
4. Include delays, saturation, measurement limits, and competing loops. Balancing
   feedback can oscillate or destabilize with delays; it does not guarantee stability.
5. Suggest an observation or intervention that tests the mechanism.

Output the loop, signs, relevant limits, and a check. Stop when the response and
uncertainty are clear; do not infer an optimal controller setting from a sketch.

## Example and boundary

Queue length → added capacity (+); added capacity → queue length (-) is a proposed
balancing loop if the capacity actually responds to queue length. A ten-minute
startup delay may produce overshoot. A fixed rate limit with no returning effect
on its setting is not automatically a feedback controller.

## Source

[Untools: Balancing feedback loop](https://untools.co/balancing-feedback-loop/).
