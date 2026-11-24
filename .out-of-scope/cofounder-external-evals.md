# Cofounder external evaluation dependencies

Two external repositories were evaluated alongside `skills/cofounder/` on
2026-11-24 and deliberately kept out of this repository as dependencies or
vendored copies:

## monteduro/killmyidea (hosted MCP API and synthetic scoring)

We adopted two portable rubric ideas directly into
`skills/cofounder/references/start.md`: goal-mode routing (`money`,
`open_source`, `fun`) and a three-fact clarity gate before scoring.

We did NOT couple `cofounder` to `https://killmyidea.biz/api/mcp` or adopt its
0-100 weighted scoring model because:
1. Third-party archiving: `killmyidea` archives submitted idea text in a remote
   SQLite database unless callers remember to pass `do_not_archive: true`.
2. Portability: skills in this repo must run offline and across agents without
   relying on an external hosted classifier.
3. Evidence discipline: synthetic 0-100 averages derived from pitch prose alone
   mask missing customer evidence; `cofounder` keeps unknown inputs explicit
   and uses observable situation anchors instead.

## jadmadi/skills-1 (fork of slavingia/skills)

`jadmadi/skills-1` is an unmodified fork (`ahead_by: 0`) of `slavingia/skills`
(10 skills based on The Minimalist Entrepreneur).

We did NOT vendor those 10 skills into `jadmadi/skills` because:
1. Licensing: upstream `slavingia/skills` has no `LICENSE` file (HTTP 404 on
   `/license`), so all rights are reserved and republishing it under this
   repo's MIT license would violate copyright.
2. Overlap: 8 of the 10 skills overlap with `cofounder` (`Start`, `Build`,
   `Sell`, `Scale`). Instead of vendoring, we wrote our own concise
   manual-first concierge check (`references/build.md`) and day-one pricing
   check (`references/sell.md`) to close the two real gaps while leaving
   `slavingia/skills` separately installable for users who want it.
