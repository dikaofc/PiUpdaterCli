---
name: dashboard-design
description: Design effective data dashboards — KPI choice, chart selection, hierarchy, alerting surfaces, performance.
category: Data & AI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Dashboard Design

## Start from decisions
Every chart exists to answer a question someone acts on. Before drawing: who's the audience, what decision, how often. If a chart can't be tied to a decision — cut it (deck principle: fewer, bigger).

## KPI discipline
- Metric = business outcome (ARR, active users, conversion) + context (YoY, vs target, vs forecast) — a bare number is noise.
- Max 5-7 KPIs per screen; a KPI is a trend line with target marker, not a sparkline of vanity.
- Define once: naming, definition, source, lag (data freshness) — documented in tooltip/sidebar; changing definition mid-flight invalidates comparisons (version it).

## Chart choice (match data shape)
- Trend over time → line (one metric per line, max 3 lines/panel); comparison across categories → bar (sorted, horizontal for long labels); share of total → stacked bar (never pie > 4 slices); distribution → histogram/box; relationship → scatter; progress → gauge/bar with threshold line; matrix → heatmap.
- Big numbers with delta: KPI tile (+ sparkline) — delta arrows only with baseline.

## Layout & hierarchy
- Read order top-left: headline KPIs → breakdown (time series) → drill-downs → raw-data table (filterable, capped 100 rows default).
- Grouped by subject, not by tool: "Revenue" cluster (revenue by channel, by plan, by region) instead of "charts-1..6".
- Consistent: same color = same entity across the dashboard; semantic colors (green=good direction, red=alert) per metric direction, not decoration.

## Interactivity & performance
- Global filters: date range + segment (cohort, plan, region); drill-down click-through to detail page/query with context.
- Query cost: pre-aggregated marts (`etl-batch`), cache heavy panels, cap row fetches; dashboard p95 < 3s or people stop using it.

## Alerting surface (when dashboard has alerts)
- SLO-style: burn-rate alerts on the KPI the team owns; threshold with `for:` duration; linked runbook (`monitoring-observability`).

## Checklist
- [ ] Every chart maps to a decision
- [ ] KPIs have context (target/trend/definition)
- [ ] Chart type matches data shape
- [ ] Filters + drill-down present; query perf ok
- [ ] Definitions documented; semantic colors consistent