# Abstraction laddering

Use when a requested solution may obscure the actual problem. Supply the initial
problem statement, desired outcome, and constraints that must remain binding.

## Procedure

1. Place the current statement at the center of the ladder.
2. Ask why the outcome matters to move toward a broader purpose. Do not invent the
   user's purpose; propose a framing and label it when unconfirmed.
3. Ask how to achieve that purpose to find concrete alternatives.
4. Compare the levels for usefulness, tractability, and fit with the user's mandate.
5. Recommend the level to work at and one next action within scope.

Output a short why/how ladder and a revised problem statement. Stop climbing when
broader goals cease to change practical choices; stop descending when a useful
action is concrete. Reframing is not permission to replace the user's project.

## Example and boundary

"Build a cache" may become "reduce repeated lookup latency" and then "make checkout
responsive." Alternatives include indexing, fewer calls, or caching. If caching is
an explicit requirement, use the broader goal to choose its design rather than
silently replacing the assignment. Do not assume latency is the issue without evidence.

## Source

[Untools: Abstraction laddering](https://untools.co/abstraction-laddering/).
