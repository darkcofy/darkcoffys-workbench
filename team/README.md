# Team Management

A YAML-driven system for managing a data team, tracking engagements, and building your promotion case. Designed for managers/senior ICs in consulting or enterprise data teams.

**Templates are committed. Your filled-in data should stay private** (separate private repo or `.gitignore`).

---

## Why This Exists

As a data architecture manager, your job isn't just building — it's running engagements, growing people, and bringing in work. Most of this happens in your head, scattered Slack messages, and half-remembered conversations. When review time comes, you can't remember what you did in Q2.

This system gives you a single place to track everything that matters for your career and your team — in plain YAML and markdown that you own, not locked in some SaaS tool.

---

## The 5 Promotion Pillars

In consulting (and most large orgs), promotions from Manager to Senior Manager / Director are evaluated on 5 areas. The `promotion-tracker.yml` tracks evidence against each one.

### 1. Delivery & Revenue

**What it is:** Running client engagements well. Hitting budgets, timelines, and quality.

**What they measure:** Utilization rate (% of your time billed to clients), total revenue you manage, client satisfaction scores, whether projects deliver on time and in scope.

**What good looks like:** 75-85% utilization, managing $1M+ in engagements, clients requesting you back, delivering early or under budget.

**How to track:** Fill in `engagements/` files — budget burn rate, deliverables, client satisfaction, key wins.

### 2. People Development

**What it is:** Growing your team. Making the people under you better, more skilled, more promotable.

**What they measure:** Team size you manage, how many people you've developed for promotion, mentoring impact, knowledge sharing, team retention.

**What good looks like:** Managing 5-10 people, getting 2+ people promoted, running training sessions, being requested as a mentor.

**How to track:** `roster.yml` for skills and development goals, `one-on-ones/` for 1:1 notes and career conversations.

### 3. Business Development (BD)

**What it is:** Bringing in new revenue. This is the biggest differentiator between people who stay at Manager forever and people who get promoted.

BD includes:
- **Writing proposals** — the technical approach, effort estimation, pricing
- **Extending existing work** — "Client X loves what we did, here's a Phase 2 proposal for $200K more"
- **Cross-selling** — "I noticed Client X also needs help with their data quality. Want me to bring in our monitoring team?"
- **Finding new opportunities** — networking at conferences, warm intros, identifying pain points during delivery
- **Supporting pitches** — attending client meetings, presenting your expertise

**What they measure:** Dollar value of pipeline you contributed to, revenue you helped win, proposals written, client relationships that led to new work.

**What good looks like:** Contributing to $500K+ in pipeline, winning $200K+ in new or extended work, having partners bring you into pitches because you add credibility.

**How to track:** `promotion-tracker.yml` → `business_development` section. Log every proposal, extension, and opportunity.

**Reality check:** Early on, you won't be writing proposals solo. Start by:
1. Shadowing a partner on a pitch
2. Writing the technical approach section of a proposal
3. Identifying an upsell at a current client and flagging it to the partner
4. Attending industry events and making connections

Any of these count as BD evidence.

### 4. Thought Leadership

**What it is:** Being visible as an expert — internally and externally.

Includes:
- **Internal:** Leading a community of practice, creating reusable frameworks/accelerators, writing internal playbooks, running training
- **External:** Conference talks, blog posts, whitepapers, published case studies
- **Accelerators:** Building reusable tools or templates that other teams use (this workbench is literally one)

**What they measure:** Visibility, reach, whether your work gets reused, whether you're known for something.

**What good looks like:** 2+ visible contributions per year. Being "the dbt person" or "the data architecture person" that others come to.

**How to track:** `promotion-tracker.yml` → `thought_leadership` section.

### 5. Operational Excellence

**What it is:** Making things run better. Risk management, process improvement, quality standards.

**What they measure:** Did you reduce errors? Standardize something? Prevent incidents? Improve efficiency?

**What good looks like:** "Standardized CI/CD across 3 engagements, reducing deployment errors by 80%" or "Created data quality monitoring framework adopted by 2 other teams."

**How to track:** `promotion-tracker.yml` → `operations` section.

---

## Files & What They're For

### `promotion-tracker.yml`
Your master evidence file. Update weekly (Friday, 10 minutes). Organized by pillar. Includes quarterly self-assessments. **This is the document you bring to your review.**

### `roster.yml`
Your team at a glance:
- Skills matrix (rate each person 1-5 on Python, SQL, dbt, Snowflake, architecture, client-facing, etc.)
- Current engagement allocation
- Development goals and certifications
- Skills gaps across the team

Use this for staffing decisions ("Who knows Snowflake and is available next month?") and development planning.

### `engagements/TEMPLATE.yml`
Copy one per active engagement. Tracks:
- **Budget:** total hours, hours burned, burn rate, runway status (green/amber/red)
- **Deliverables:** what's done, what's in progress, what's blocked
- **Milestones:** key dates and status
- **Risks & issues:** what could go wrong, who owns the mitigation
- **Stakeholders:** client contacts, their role, your relationship quality
- **Scope changes:** what's in SOW vs what the client keeps asking for (change requests = more revenue or scope creep — track both)
- **Weekly notes:** quick journal, feeds into your Friday status report

### `one-on-ones/TEMPLATE.md`
One file per person. Most recent 1:1 at the top. Track:
- What they told you
- What you observed
- Action items (theirs and yours)
- Career/development notes

**Write during the 1:1, not after.** You'll forget the nuance. When review time comes, read the last 6 months and you'll have specific examples ready.

### `weekly-status/TEMPLATE.md`
The Friday one-pager your partner/director wants. Formatted for skimming:
- RAG status per engagement (Red/Amber/Green)
- Budget numbers (exact, not approximate)
- Risks and escalations (red items first — that's what they care about)
- Team utilization
- BD pipeline update

**Tip:** An AI agent can draft this from your engagement YAMLs. Just ask: "Read team/engagements/*.yml and draft this week's status report."

### `personal/first-90-days.md`
Week-by-week acceleration plan:
- **Days 1-30:** Learn the landscape, map the org, meet everyone, assess your team
- **Days 31-60:** Deliver a quick win, start BD activity, build your "signature"
- **Days 61-90:** Lead something visible, set quarterly goals, establish your trajectory

Includes anti-patterns to avoid (spending 80% of time coding, ignoring politics, not tracking evidence) and a weekly rhythm template.

---

## Using the Dashboard

```bash
team-status              # everything
team-status engagements  # burn rates, runway, open risks per client
team-status team         # roster, utilization, skills gaps
team-status promotion    # evidence count per pillar, days to target
team-status 1on1         # last 1:1 date per person
```

Requires `yq` (installed automatically by `./setup`).

---

## Getting Started

All templates are committed. Your data is gitignored. Copy templates to start:

```bash
# 1. Create your promotion tracker (gitignored — private)
cp team/TEMPLATE-promotion-tracker.yml team/my-promotion-tracker.yml
nvim team/my-promotion-tracker.yml
# Set: target_role, target_date, start_date, counselor, sponsor

# 2. Read the 90-day plan
cp team/personal/TEMPLATE-first-90-days.md team/personal/my-first-90-days.md
nvim team/personal/my-first-90-days.md

# 3. Create your team roster (gitignored — private)
cp team/TEMPLATE-roster.yml team/my-roster.yml
nvim team/my-roster.yml

# 4. Create engagement trackers (gitignored — private)
cp team/engagements/TEMPLATE.yml team/engagements/client-x-platform.yml
nvim team/engagements/client-x-platform.yml

# 5. Start 1:1 notes (gitignored — private)
cp team/one-on-ones/TEMPLATE.md team/one-on-ones/sarah-chen.md

# 6. Every Friday
nvim team/engagements/client-x-platform.yml   # update hours, notes
cp team/weekly-status/TEMPLATE.md team/weekly-status/$(date +%Y-%m-%d).md
team-status                                     # check your dashboard
```

## Privacy

**Templates are committed. Your filled-in data is gitignored automatically.**

The `.gitignore` excludes:
- `team/my-*.yml` — your promotion tracker and roster
- `team/engagements/*.yml` (except TEMPLATE)
- `team/one-on-ones/*.md` (except TEMPLATE)
- `team/weekly-status/*.md` (except TEMPLATE)
- `team/personal/my-*.md` — your personal plans

Templates (`TEMPLATE-*`, `TEMPLATE.*`) are safe to share — they only have commented-out examples.
