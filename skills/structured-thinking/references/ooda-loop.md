# OODA loop

Use to adapt under time pressure with incomplete evidence. Supply observations,
constraints, allowed actions, and a practical time budget if one exists.

## Procedure

1. Observe: distinguish actual signals from reports, noise, and missing data.
2. Orient: identify plausible interpretations, context, and assumptions shaping them.
3. Decide: choose a bounded action that addresses the situation or usefully
   distinguishes explanations. Prefer reversibility where it is available.
4. Act within existing authorization. Otherwise propose the action explicitly;
   do not imply it occurred. State what signal and time window would trigger the
   next cycle, escalation, or stopping.

Output a compact cycle and an observation trigger. Stop after one cycle unless
continuing is requested or already authorized. Do not silently start a polling
loop, invent a time budget, or let analysis delay an authorized urgent response.

## Example and boundary

A service has elevated errors after deployment. Logs show timing but no confirmed
cause. If rollback is authorized and safe, it may restore service while creating
evidence; compare error rates afterward. If the user requested analysis only,
recommend the rollback and observation criteria without running it. A decline in
errors supports the deployment link but does not isolate the precise defect.

## Source

John Boyd's Observe–Orient–Decide–Act cycle, summarized by
[Untools](https://untools.co/ooda-loop/).
