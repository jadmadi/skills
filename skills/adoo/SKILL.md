---
name: adoo
description: Structured problem-solving via the ADOO method (Assess, Deconstruct, Organize, Optimize). Invoke with /adoo followed by a task, bug report, feature request, or problem description. Use when the user types "/adoo", or when tackling complex bugs, multi-step refactors, unclear requirements, production incidents, performance investigations, or any task where jumping straight to implementation feels risky. Also triggers on "use ADOO", "assess first", "deconstruct this", "break this down systematically", or when a problem spans multiple files/systems and the root cause is unknown.
license: MIT
metadata:
  author: jadmadi
  version: "1.0.0"
---

# ADOO: Assess, Deconstruct, Organize, Optimize

A four-stage problem-solving framework. Run stages in order. Do not skip ahead. Each stage produces an artifact the next stage depends on.

## Command usage

```
/adoo {task or bug report or feature request or problem description}
```

When invoked with a task, treat the user's input as the problem statement seed. Start at stage 1 (Assess) immediately. Do not ask for permission to begin. Do not restate the framework. Just run it.

If invoked without a task (`/adoo` alone), ask the user what they want to work on.

At each stage transition, print a brief summary of findings before proceeding. This gives the user a chance to correct course before you commit to the next stage.

## When NOT to use

- Single-file change with obvious solution
- Trivial formatting or rename
- Task you've done identically before in this codebase

## The four stages

### 1. Assess

Gather data before forming opinions. Output: a written problem statement.

- Reproduce the issue reliably. If you can't reproduce, say so.
- Read the actual code, logs, and error messages. Do not rely on summaries from others or prior context.
- Identify symptoms (what the user sees) vs root cause (what's actually broken). They are rarely the same.
- State assumptions explicitly. Mark each as "verified" or "unverified."
- Write a one-sentence problem statement: "X happens because Y, confirmed by Z."

Print the problem statement before moving to stage 2.

Checklist before moving on:
- [ ] Problem reproduced or reproduction attempted with documented results
- [ ] Read the actual source files involved (not summaries)
- [ ] Symptoms distinguished from root cause
- [ ] Problem statement written

### 2. Deconstruct

Break the problem into independent parts you can analyze separately. Output: a list of components.

- Split by system boundary (frontend, backend, database, external API).
- Split by lifecycle (load, parse, validate, persist, respond).
- For each component, ask: could this be the failure point? What would prove or disprove it?
- Identify what you don't know. Those are investigation tasks, not guesses.

Print the component list before moving to stage 3.

Checklist before moving on:
- [ ] Problem split into 3+ components (or documented why fewer)
- [ ] Each component has a yes/no test ("could this be the failure?")
- [ ] Unknowns listed explicitly

### 3. Organize

Map how the components interact. Output: a dependency graph or ordered sequence.

- Order components by data flow: what happens first, what depends on what.
- Identify the critical path: the minimum chain of components that must all work for the feature to work.
- Mark each component as: working, broken, or unknown.
- The bug lives in a "broken" or "unknown" component on the critical path. Components off the critical path or marked "working" are not the issue.

Print the ordered component map with labels before moving to stage 4.

Checklist before moving on:
- [ ] Components ordered by data flow
- [ ] Critical path identified
- [ ] Each component labeled working/broken/unknown
- [ ] Root cause narrowed to one or two components

### 4. Optimize

Implement and verify. Output: the fix plus evidence it works.

- For each candidate root cause from stage 3, propose the smallest fix that addresses it. No speculative refactors.
- If multiple fixes are possible, pick the one with the smallest blast radius.
- Implement the fix.
- Verify: reproduction case now passes, existing tests pass, no new errors introduced.
- If the fix doesn't work, return to stage 3 with the new information. Do not pile on more changes hoping one sticks.

Checklist before done:
- [ ] Smallest sufficient fix implemented
- [ ] Reproduction case verified fixed
- [ ] Existing tests pass
- [ ] No unrelated changes introduced
- [ ] If fix failed, returned to stage 3 instead of patching forward

## Anti-patterns

- Skipping Assess to jump to a fix. You'll fix the symptom, not the cause.
- Deconstructing without reading the actual code. You'll invent components that don't exist.
- Implementing multiple fixes at once. If it works you won't know which one mattered, and if it breaks you won't know which one caused it.
- Moving to Optimize with "unknown" components on the critical path. Investigate first.
- Asking permission between every stage. Print findings and proceed unless the user interrupts.
