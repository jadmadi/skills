# Chapter IV: Scale (Scaling Loop, Analytics, Support, Unit Economics, Expansion)

Use when instrumenting product analytics, systematizing customer support,
calculating unit economics, or evaluating expansion bets and fundraising.

## The scaling loop

Growth runs as a Feedback Loop:
`Build -> Sell -> Observe -> Support -> Learn -> Iterate`.
Run it manually with early customers first to build intuition, then wire
systems so signal scales past founder bandwidth.

## Product analytics

Default tool: PostHog (funnels, custom events, session replay, retention).
Keep staging and production projects separate; never track PII, passwords,
payment details, private docs, or API keys.

Instrument eight core lifecycle events first (avoid tracking nothing or
everything):
- `signed_up`
- `onboarding_completed`
- `core_action_completed`
- `trial_started`
- `checkout_completed`
- `subscription_upgraded`
- `teammate_invited`
- `support_ticket_opened`

Measure retention at the natural frequency of the problem, not arbitrary DAU.
Run the 6-step analytics loop:
`Find drop-off -> Watch session replays -> Talk to affected users -> Form
hypothesis -> Ship small change -> Measure conversion lift`.

## Customer support and feedback iceberg

Apply the Iceberg Model: repeated tickets signal UX confusion or missing docs,
not just one-off user errors. Feed support themes straight into product/docs.

Automation boundary (e.g. Fin by Intercom or tier-1 AI support):
- Automate: password resets, billing updates, teammate invites, import guides,
  plan changes, basic troubleshooting.
- Escalate to human/engineering immediately: refund disputes, security reports,
  data loss, angry enterprise accounts, bugs hitting multiple users.

Minimum Knowledge Base (write in customer language, not code terms):
1. Getting started
2. Core workflows
3. Billing and plans
4. Troubleshooting
5. Account management
6. Known limitations

Build Support Decision Trees for top categories: Login, Billing, Import
failures, Permissions, Core workflow errors, Cancellations, Blocking bugs.

## Unit economics formulas

Never invent missing numbers. Compute only what supplied inputs support and
label missing inputs `unknown`. Match time periods across churn and lifetime.

- `Revenue churn rate = lost recurring revenue in period / recurring revenue at start of period` (distinguish logo churn vs revenue churn).
- `Average customer lifetime = 1 / churn rate` (same period).
- `ARPU = total revenue / number of customers`.
- `LTV = ARPU * average customer lifetime`.
- `Gross margin LTV = ARPU * gross margin * average customer lifetime`.
- `CAC = sales and marketing cost in period / new customers acquired in period` (note early founder-led sales understates true CAC).
- `LTV/CAC = lifetime value / customer acquisition cost`.
- `Payback period = CAC / monthly gross profit per customer`.

Early numbers are noisy: track directional trend (longer retention, higher
ARPU, lower CAC) before optimizing decimals. If LTV < CAC, fix retention,
pricing, margins, CAC, or ICP before spending on growth.

## Expansion gates (anti-distraction filter)

Two expansion paths:
- Vertical: Serve existing customers deeper (adjacent workflows/products that
  raise retention or ARPU).
- Horizontal: Adapt core product for adjacent segments or markets (raises TAM).

Apply Second-Order Thinking and require all five gates before building:
1. Where is demand already showing up in tickets, sales calls, and inbound?
2. Does it improve retention, ARPU, CAC, or payback period?
3. Does it strengthen the core product rather than splitting engineering focus?
4. Can you pre-sell it (verbal commit or LOI) before writing production code?
5. Does it meaningfully expand TAM (and clarify if fundraising is needed as a
   tool to fund proven expansion, never as a goal)?
