# Data Modeling Conventions

> Scaffold this into your project and fill in the decisions. These become the
> single source of truth that your team (and AI agents) follow.

## Schema Layers

| Layer | Prefix | Purpose | Example |
|-------|--------|---------|---------|
| Source | `src_` | Raw data, 1:1 with source tables | `src_stripe_payments` |
| Staging | `stg_` | Cleaned, typed, renamed — one model per source | `stg_stripe__payments` |
| Intermediate | `int_` | Business logic joins, aggregations between staging models | `int_payments__pivoted_by_method` |
| Fact | `fct_` | Event/transaction grain tables | `fct_orders` |
| Dimension | `dim_` | Entity/attribute tables | `dim_customers` |
| Metric | `mrt_` | Pre-aggregated metrics for BI consumption | `mrt_revenue__monthly` |
| Utility | `util_` | Date spines, mapping tables, reference data | `util_date_spine` |

<!-- HINT: Adjust prefixes to match your org's conventions. Some teams use
     marts_ instead of mrt_, or don't use int_ at all. The important thing
     is consistency. -->

## Naming Rules

### Models
- **snake_case** everywhere: `stg_stripe__payments` not `StgStripePayments`
- **Double underscore** separates source system from entity: `stg_stripe__payments`
- **Verb prefixes** for intermediate: `int_payments__pivoted_by_method`
- **No abbreviations** unless universally understood: `customer` not `cust`, but `id` is ok

### Columns
- **Primary keys:** `<entity>_id` (e.g., `order_id`, `customer_id`)
- **Foreign keys:** same name as the PK they reference
- **Booleans:** `is_` or `has_` prefix (`is_active`, `has_subscription`)
- **Dates:** `_date` suffix (`created_date`, `shipped_date`)
- **Timestamps:** `_at` suffix (`created_at`, `updated_at`)
- **Amounts/money:** `_amount` suffix, always in lowest denomination or specify `_usd`
- **Counts:** `_count` suffix (`order_count`)
- **Ratios/rates:** `_rate` or `_ratio` suffix (`conversion_rate`)

<!-- HINT: Document any domain-specific naming patterns here.
     e.g., "All Salesforce fields keep their API name in staging" -->

## Grain Documentation

Every model MUST have its grain documented in the YAML schema file:

```yaml
models:
  - name: fct_orders
    description: "One row per order. Grain: order_id."
    columns:
      - name: order_id
        description: "Primary key. Unique per row."
        tests:
          - unique
          - not_null
```

<!-- HINT: For models with composite grain (e.g., user_id + date), document
     it explicitly: "Grain: one row per user per day (user_id, activity_date)" -->

## Slowly Changing Dimensions (SCD)

| Strategy | When to use | Implementation |
|----------|------------|----------------|
| **Type 1** (overwrite) | Non-critical attributes, latest-only is fine | Default — just update the row |
| **Type 2** (versioned) | Need historical tracking (e.g., customer address changes) | Add `valid_from`, `valid_to`, `is_current` columns |
| **Type 3** (previous value) | Only need current + one previous | Add `previous_<column>` alongside current |

<!-- HINT: Document your default SCD strategy here.
     Most teams default to Type 1 and only use Type 2 where explicitly needed.
     If using dbt snapshots, reference the snapshot naming pattern. -->

Default strategy: **Type 1** unless the ADR for that entity specifies otherwise.

Snapshot naming: `snp_<source>__<entity>` (e.g., `snp_app__customers`)

## Materialization Strategy

| Layer | Default Materialization | Override When |
|-------|------------------------|---------------|
| Source | `source` (not materialized) | — |
| Staging | `view` | Table if query is expensive |
| Intermediate | `ephemeral` | View/table if reused by 3+ downstream models |
| Fact/Dimension | `table` | Incremental if >10M rows or append-only source |
| Metric | `table` | Incremental if time-partitioned |

<!-- HINT: Adjust thresholds based on your warehouse. Snowflake handles
     large views differently than Postgres. -->

## Testing Requirements

### Minimum per model
- Primary key: `unique` + `not_null`
- Foreign keys: `relationships` test
- Known enums: `accepted_values`

### Recommended per layer
| Layer | Required Tests | Recommended Tests |
|-------|---------------|-------------------|
| Staging | PK unique/not_null, critical columns not_null | Source freshness |
| Intermediate | PK unique/not_null | Row count comparison |
| Fact | PK, FK relationships, not_null on measures | Volume anomaly, freshness |
| Dimension | PK, not_null on key attributes | Uniqueness on business keys |

<!-- HINT: If using dbt-expectations or dbt-utils, add your standard
     patterns here. e.g., "All fact tables must have
     expect_table_row_count_to_be_between" -->

## Source Freshness

```yaml
sources:
  - name: stripe
    freshness:
      warn_after: {count: 12, period: hour}
      error_after: {count: 24, period: hour}
    loaded_at_field: _loaded_at
```

<!-- HINT: Set thresholds per source based on your SLAs.
     Real-time sources: warn 1h, error 4h
     Daily batches: warn 24h, error 48h
     Weekly: warn 7d, error 14d -->
