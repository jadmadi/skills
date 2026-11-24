---
name: us-incorporation
description: >-
  Guide U.S. Delaware LLC or C-corporation formation and AI agent governance
  setup using upstream General-Legal/agent-operated-company templates, filing
  checklists, and optional attorney-reviewed MCP workflow. Use on
  /us-incorporation or when forming a U.S. LLC, Delaware C-corp, drafting an AI
  governance policy, obtaining an IRS EIN, or preparing incorporation documents.
license: MIT
metadata:
  author: jadmadi
  version: "1.0.0"
---

# US Incorporation

Guide founders through forming a U.S. LLC or C-corporation (including optional
AI agent governance policies) using live upstream templates from
`General-Legal/agent-operated-company` without vendoring stale legal forms.

## Mandatory disclaimer

State clearly at the start of every session:
- These materials and checklists are informational only, not legal, tax, or
  accounting advice.
- Using them does not create an attorney-client relationship.
- Complex setups (multi-founder vesting, non-U.S. founders, custom equity
  classes, regulated industries) require a U.S. attorney and CPA before filing.

## Command usage

```text
/us-incorporation                 # Triage entity (LLC vs C-corp), state, and path
/us-incorporation checklist       # Output the 7-step filing and shield checklist
/us-incorporation draft <entity>  # Fetch upstream manifest and map {Field Name}s
/us-incorporation mcp             # Guide setup for General Legal's attorney MCP
```

## Five hard safety gates

1. Never invent legal language or file on behalf of the user: Fetch upstream
   templates live from https://github.com/General-Legal/agent-operated-company
   before drafting. If offline, state what cannot be fetched and stop.
2. Human approval before any filing or signature: Never submit state charters,
   IRS EIN forms, or signing packets without explicit human review.
3. Free EIN only: Direct users to `irs.gov` for EIN registration. Block paying
   third-party EIN-filing sites.
4. Liability shield is non-optional: Require a separate business bank account
   (25%+ human owners must complete bank KYC), initial capitalization, and
   corporate formalities. Warn that commingling funds pierces the veil.
5. Vesting and cross-border escalation: Upstream templates issue fully vested
   ownership by design. If the user asks for vesting, warn about the strict
   30-day IRS 83(b) election deadline and require counsel. For non-U.S. founders
   or restricted jurisdictions, flag tax/OFAC review before filing.

## Execution workflow

### 1. Triage unsettled decisions (frontier grilling)

Ask only missing decisions in one tight round (max 3-4 questions, `yes` accepts
the recommendation):

- Entity type: `LLC` (default for bootstrapped / pass-through tax) vs
  `C-Corporation` (required for VC fundraising, stock options, QSBS / IRC 1202).
- Jurisdiction: Delaware (default in upstream kit) vs founder's home state.
- Founder setup: Solo U.S. founder (standard DIY path) vs multi-founder or
  non-U.S. founder (flag counsel + CPA review).
- Execution path:
  - DIY using upstream `.docx` / `.md` templates.
  - Attorney-reviewed filing via General Legal ($500 standard fee + state and
    registered-agent fees; human accepts clickthrough Limited Engagement Letter
    at https://portal.general.legal and can then connect the MCP endpoint at
    https://mcp.general.legal/mcp using Streamable HTTP + OAuth 2.1).

### 2. Fetch upstream manifest and templates

Read `manifest.json` from `General-Legal/agent-operated-company` first to get
the current version, template list for the chosen entity, and required
`{Field Name}` placeholders:

```bash
gh api repos/General-Legal/agent-operated-company/contents/manifest.json --jq .content | base64 -d
```

Fetch only the relevant files for the chosen entity (`-llc` or `-ccorp`) and
matching filing guide from `filing-instructions/` (`README.md`, `delaware.md`
or `home-state.md`, and the matching EIN walkthrough).

### 3. Map placeholders without guessing

List every required `{Field Name}` from `manifest.json` for the selected packet:
- Fill only facts explicitly provided by the user.
- Mark missing inputs `[UNKNOWN]` and ask for them; never invent legal names,
  registered-agent addresses, share counts, or ownership percentages.
- Respect upstream format rules from `manifest.json`: `.md` files are for agent
  review only; `.docx` files are the authoritative signing source. Before
  signing, strip `GLInstructionBlock` / `GLInstructionInline` notes and Word
  comments, resolve every `{Field Name}` and `[[GL-SIGNATURE:{capacity}]]`, and
  reject tracked changes.

### 4. Output the 7-step filing checklist and next action

Deliver:
1. Entity & path decision summary (facts, assumptions, unknowns, escalation
   flags).
2. Required document packet from `manifest.json` (charter, Action of
   Incorporator, bylaws/operating agreement, AI Governance Policy, ownership
   issuance, organizational resolutions, stockholder consent for C-corp,
   indemnification).
3. Ordered 7-step checklist:
   - File charter with state and pay state filing fee.
   - Appoint registered agent (~$100-$150/yr).
   - Apply for free EIN directly at `irs.gov`.
   - Adopt internal governance and ownership documents.
   - Open a separate business bank account (human KYC required for 25%+ owners).
   - Fund initial capitalization and maintain formalities/audit logs.
   - If vesting was added with counsel, file IRS 83(b) election within 30 days.
4. One concrete next action for the founder today.
