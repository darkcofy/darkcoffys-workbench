# Team Management

Private management files. **Templates are committed, your data is not.**

After cloning, copy templates and fill in:

```bash
# Engagement tracking
cp engagements/TEMPLATE.yml engagements/client-x-platform.yml

# 1:1 notes
cp one-on-ones/TEMPLATE.md one-on-ones/sarah-chen.md

# Weekly status
cp weekly-status/TEMPLATE.md weekly-status/2026-04-07.md

# Dashboard
team-status              # show all
team-status engagements  # burn rates
team-status team         # utilization
team-status promotion    # pillar progress
team-status 1on1         # 1:1 history
```

## Files

| File | Purpose |
|------|---------|
| `promotion-tracker.yml` | Track evidence against 5 promotion pillars |
| `roster.yml` | Team skills matrix, capacity, development goals |
| `engagements/` | Per-client budget, deliverables, risks, stakeholders |
| `one-on-ones/` | Per-person 1:1 notes (most recent at top) |
| `weekly-status/` | Friday status reports for leadership |
| `personal/first-90-days.md` | Acceleration plan for first 3 months |

## Privacy

Add filled-in files to `.gitignore` or keep in a **private** repo.
Templates (TEMPLATE.yml, TEMPLATE.md) are safe to share.
