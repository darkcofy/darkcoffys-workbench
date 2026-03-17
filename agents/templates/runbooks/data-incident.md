# Runbook: Data Incident Response

> When data is wrong, missing, or late — follow this playbook.

## Severity Levels

| Level | Definition | Response Time | Example |
|-------|-----------|---------------|---------|
| **P1** | Revenue-impacting or customer-facing data is wrong | 30 min | Dashboard shows wrong revenue, billing data incorrect |
| **P2** | Internal reports/models are broken or stale | 2 hours | dbt run failing, source freshness SLA missed |
| **P3** | Data quality degradation, non-blocking | 24 hours | Null rates increasing, minor column issues |
| **P4** | Cosmetic / low-impact | Next sprint | Naming inconsistency, documentation gap |

<!-- HINT: Adjust severity definitions and response times to your org.
     Link to your PagerDuty/Opsgenie escalation policy if you have one. -->

## Step 1: Assess (5 minutes)

```
[ ] What is broken? (model name, dashboard, report)
[ ] Who reported it? When was it first noticed?
[ ] What is the blast radius? (who/what is downstream)
[ ] What is the severity? (P1-P4 using table above)
[ ] Is this a data issue or an infrastructure issue?
```

Quick checks:
```bash
# Check if dbt ran successfully
dbt run --select <model> --target prod

# Check source freshness
dbt source freshness --select <source>

# Check recent row counts (adjust for your warehouse)
sqlprism status

# Check if the source system is up
# HINT: Add your source system health check URLs here
# curl -s https://status.stripe.com/api/v2/status.json | jq .status
```

## Step 2: Diagnose (15 minutes)

### Data is missing or late
```
[ ] Check source freshness: dbt source freshness
[ ] Check ETL/pipeline status (Airflow, Fivetran, Airbyte, etc.)
    # HINT: Add your pipeline monitoring URLs here
    # Fivetran: https://fivetran.com/dashboard/connectors/<id>
    # Airflow: https://airflow.example.com/dags/<dag_id>
[ ] Check source system status
[ ] Check warehouse status / query queue
```

### Data is wrong
```
[ ] Identify the first model where data goes wrong (trace upstream)
    sqlprism query "show lineage for <model>"
[ ] Check if source data changed (schema drift, new values)
    # Compare recent vs historical:
    # SELECT column, COUNT(*) FROM model GROUP BY 1 ORDER BY 2 DESC
[ ] Check if business logic changed (recent PRs/commits)
    git log --oneline --since="3 days ago" -- models/
[ ] Check if a dependency changed
    sqlprism query "show upstream of <model>"
```

### dbt run is failing
```
[ ] Read the error message carefully
[ ] Check if it's a compile error (code) or runtime error (data/infra)
[ ] Check if the source table exists and is accessible
[ ] Check if a dependent model failed first
    dbt run --select +<model>  # run with all upstream deps
[ ] Check warehouse permissions
```

## Step 3: Communicate (immediately for P1/P2)

### Notification template
```
🚨 Data Incident: [brief description]
Severity: P[1-4]
Impact: [what's affected — dashboards, reports, pipelines]
Status: Investigating / Root cause identified / Fix deployed
ETA: [when you expect resolution]

Tracking in: [link to issue]
```

<!-- HINT: Fill in your notification channels:
     - P1: #data-incidents Slack channel + page on-call
     - P2: #data-incidents Slack channel
     - P3: Create ticket, notify in standup
     - P4: Create ticket -->

### Stakeholder contacts

| Domain | Owner | Notify on |
|--------|-------|-----------|
| Revenue data | <!-- HINT: name --> | P1, P2 |
| Product analytics | <!-- HINT: name --> | P1, P2 |
| Marketing data | <!-- HINT: name --> | P1, P2 |
| Executive dashboards | <!-- HINT: name --> | P1 |
| Data engineering | <!-- HINT: name --> | All |

## Step 4: Fix

### Quick fixes (apply if appropriate)
```bash
# Rerun a specific model
dbt run --select <model> --full-refresh

# Rerun a model and everything downstream
dbt run --select <model>+

# Backfill incremental model
dbt run --select <model> --full-refresh --target prod

# Reindex sqlprism after fix
sqlprism reindex
```

### Fix requires code change
```bash
git cb fix-data-<brief-description>   # create branch
# ... fix the issue ...
make lint                              # validate
dbt build --select <model>+           # test locally
# ... commit, push, create PR ...
```

## Step 5: Verify

```
[ ] Model runs successfully: dbt build --select <model>+
[ ] Row counts are reasonable: compare to yesterday/last week
[ ] Key metrics match expectations: spot-check in dashboard
[ ] Downstream consumers confirmed data looks correct
[ ] Source freshness is back to normal: dbt source freshness
```

## Step 6: Post-mortem (P1 and P2 only)

Create an ADR or incident report:

```
## Incident: [title]
**Date:** YYYY-MM-DD
**Duration:** X hours
**Severity:** P[1-2]
**Impact:** [what was affected and for how long]

### Timeline
- HH:MM — Issue detected by [who/what]
- HH:MM — Investigation started
- HH:MM — Root cause identified: [what]
- HH:MM — Fix deployed
- HH:MM — Verified resolved

### Root Cause
[What actually went wrong — be specific]

### What Went Well
- ...

### What Could Be Improved
- ...

### Action Items
- [ ] [preventive measure] — owner: [name] — due: [date]
- [ ] [monitoring improvement] — owner: [name] — due: [date]
```

<!-- HINT: Store post-mortems in .artifacts/reports/ or your team wiki.
     The goal isn't blame — it's making the system more resilient. -->
