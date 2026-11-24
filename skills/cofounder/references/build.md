# Chapter II: Build (MVP Spec, Stack, Security, Anti-Slop QA, Scaling)

Use when scoping an MVP, bootstrapping a repo/pipeline, auditing codebase
quality and security, debugging production, or scaling infra. Adapt to the
repo's existing stack when present; use defaults below for greenfield builds.

## Come up with a spec (MVP boundary)

First run the manual-first check: can you deliver the core outcome by hand for
3 to 5 paying customers this week (concierge service, spreadsheet, one-off
script, or manual invoice)? If yes, do it manually first, write down every
step, charge for it, and automate only the bottleneck that repeats. Skip the
manual step only when software itself is the product (such as a developer CLI,
real-time API, or open-source library).

When software is required, an MVP is the smallest working software that
delivers real value to a real user, not a landing page or static demo. Answer
three questions:
1. Core problem: Ruthlessly specific ("Freelancers lose track of quarterly tax
   estimates because tools assume W-2 pay", not "help manage finances").
2. Minimum features: List everything, cut half via Impact-Effort. If >3-5 core
   features remain, cut again.
3. Platform: Default web-first (fastest to build, deploy, and iterate). Reject
   native mobile/desktop early unless a hardware/OS constraint requires it.

## Repo, deploy, and secrets (before feature code)

1. Repository hygiene: Sensible folder layout, `README.md`, `.gitignore`,
   branch-and-PR workflow, and branch protection on `main` (no direct 2 AM
   pushes to production).
2. Deployment pipeline first (prevents "works on my machine"):
   - Preview environments per PR (essential for agent-native development: review
     live URLs in parallel rather than pulling every branch locally).
   - Staging mirroring production from the main integration branch.
   - Production receiving only staging-verified merges.
3. Secret management:
   - Never hardcode keys or commit `.env` files, even in private repos.
   - Separate keys per environment (dev, staging, prod).
   - Rotate exposed or departed-teammate keys; restrict prod secret access.

## Architecture and backend minimums

Default greenfield stack: Next.js (TypeScript + React + API routes in one repo)
+ Supabase (Postgres, Auth, Storage) + Vercel (free/low tier under ~$50/mo
early). Optimize for founder speed early (Confidence vs Speed/Quality); optimize
for unit cost at scale.

Layered flow: `route renders screen -> form calls action -> API validates ->
database/storage updates -> UI refreshes`.

Four non-optional backend pillars:
1. Authentication: Never roll custom auth. Use proven auth (e.g. Supabase Auth:
   email/password, magic links, OAuth) tied to database access rules.
2. Database: Model core entities and relationships for the MVP; evolve schemas
   via explicit, reversible migrations rather than ad-hoc edits on live data.
3. API layer: Validate every payload server-side, run business logic, return
   clear errors, and keep routes organized.
4. Integrations:
   - Payments (e.g. Stripe, 2.9% + 30c): Checkout + verified webhooks confirming
     payment/cancellation/failure before granting or revoking access.
   - Transactional email (e.g. Postmark): Triggered reliably by product state
     (signup, reset, receipts) on a high-deliverability provider.
   - Durable background jobs (e.g. Vercel Workflows): Offload batch emails,
     large uploads, multi-step AI pipelines, and webhook chains past normal
     request timeouts.

Security audit checklist (non-optional):
- Return only the fields the caller needs (no leaking other users' records).
- Validate all browser input server-side.
- Enforce Row-Level Security (RLS) or equivalent tenant isolation in the DB.
- Keep all credentials in environment variables; enforce HTTPS everywhere.

## Frontend loop (code-first UX)

Map core paths before coding (signup -> first value -> ongoing usage, plus
empty/loading/error states). Generate working clickable code directly rather
than static mockups, then loop:
1. Click through the live preview like a first-time customer.
2. Spot confusing copy, dead ends, and awkward states.
3. Ship the smallest fix and repeat until the core flow feels obvious.

## Testing and quality (avoiding AI slop)

Every change must clear three checks:
1. Behavior tests (unit, integration, E2E on critical paths):
   Inspect tests manually. Reject AI test slop: circular tests that mirror
   implementation details, mock away the component under test, or pass no
   matter what user outcome occurs.
2. Code hygiene: Automated lint + formatting (e.g. ESLint + Prettier) on save
   or commit so multiple agent runs never drift in style.
3. Agent rules and human check: Maintain repo rules (`AGENTS.md` /
   `.cursorrules`) covering stack, versions, conventions, banned/preferred
   libraries, examples, and pitfalls. Test on a phone and slow connection.

## Production debugging and scaling

Triage bugs using Issue Trees or Ishikawa across four surfaces:
1. API/serverless logs (runtime exceptions, status codes, timeouts).
2. Database/auth logs (slow queries, constraint/RLS errors, auth events).
3. Browser DevTools (Console errors + Network request/response payloads).
4. Error tracking (e.g. Sentry) for grouped stack traces.

Most prod bugs trace to a typo, missing env var, changed API response, or
unhandled DB edge case.

Post-launch scaling levers:
- Database: Add indexes for slow lookups; add retention/archiving for cold
  data; monitor connection limits.
- Compute: Cache aggressively, rate-limit public APIs against bots/spikes,
  set billing alerts, and trim slow serverless execution paths.
