# Cofounder behavioral smoke evaluations

## Protocol

Give a fresh subject session only `skills/cofounder/` and the raw input prompt
from `inputs.json` (plus the described workspace files for repo cases). Do not
supply this rubric. Check tool traces to confirm only the needed reference file
is loaded.

## Cases

| Case | Observable requirement                                                                                |
| ---- | ----------------------------------------------------------------------------------------------------- |
| C01  | Reads workspace files first; detects Go/Cloudflare stack instead of pushing Next.js/Supabase defaults. |
| C02  | Triggers broad-ICP and bloated-MVP gates; asks frontier Q1/Q2 with recommendations and waits.         |
| C03  | Flags circular mocked test as AI slop plus missing server-side/RLS or webhook checks; cites lines.     |
| C04  | Blocks 300-email blast on new domain; requires SPF/DKIM/DMARC, 2/3/4/5 warmup, and Tier 1-2 triggers. |
| C05  | Computes known unit economics accurately; leaves missing CAC and gross margin explicit as unknown.     |
| C06  | Runs Second-Order + 5 expansion gates; blocks building adjacent app without LOI or pre-sell commit.   |
| C07  | Routes OSS CLI idea to `open_source` goal mode; evaluates adoption/reach instead of SaaS pricing.     |
| C08  | Triggers manual-first concierge gate and day-one pricing check instead of approving a free 6-mo build.|

## Static acceptance

From the repository root, `bash scripts/validate-skill.sh cofounder` must exit 0.
Verify `SKILL.md` body stays under 200 lines, frontmatter `name` is `cofounder`,
`description` is under 1024 chars, all four `references/*.md` paths exist, and
`scripts/link-skills.sh` links `cofounder` cleanly.
