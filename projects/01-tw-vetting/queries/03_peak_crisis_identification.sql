-- ============================================================
-- Query: Backlog Crisis Arc
-- Project: TW 2.0 Personnel Vetting Analysis
-- Author: Salomon Cajina
-- Description: DCSA investigation inventory and TS timeliness
--              trends showing the OPM breach impact (FY2017-FY2019)
--              and recovery through TW 2.0 reform (FY2020-FY2022).
--              Uses LAG() for QoQ change and rolling 4-quarter
--              average window function.
-- Source: PAC QPR Legacy Metrics, FY26 Q1 publication
-- ============================================================
-- =============================================
-- QUERY 3: Peak crisis identification
-- Find the worst quarters by metric
-- =============================================
SELECT
    'Highest TS Backlog'        AS metric,
    p.period_label,
    q.end_to_end_days_ts        AS value,
    'days end-to-end'           AS unit
FROM tw_vetting.fact_qpr_indicators q
JOIN tw_vetting.dim_period p ON q.period_id = p.period_id
WHERE q.end_to_end_days_ts = (SELECT MAX(end_to_end_days_ts) FROM tw_vetting.fact_qpr_indicators)

UNION ALL

SELECT
    'Largest Investigation Inventory',
    p.period_label,
    q.dcsa_inventory_count,
    'open cases'
FROM tw_vetting.fact_qpr_indicators q
JOIN tw_vetting.dim_period p ON q.period_id = p.period_id
WHERE q.dcsa_inventory_count = (SELECT MAX(dcsa_inventory_count) FROM tw_vetting.fact_qpr_indicators)

UNION ALL

SELECT
    'Fastest TS Processing',
    p.period_label,
    q.end_to_end_days_ts,
    'days end-to-end'
FROM tw_vetting.fact_qpr_indicators q
JOIN tw_vetting.dim_period p ON q.period_id = p.period_id
WHERE q.end_to_end_days_ts = (SELECT MIN(end_to_end_days_ts)
    FROM tw_vetting.fact_qpr_indicators
    WHERE end_to_end_days_ts IS NOT NULL)

UNION ALL

SELECT
    'Peak Reinvestigation Volume',
    p.period_label,
    q.periodic_reinvest_ns_count,
    'reinvestigations'
FROM tw_vetting.fact_qpr_indicators q
JOIN tw_vetting.dim_period p ON q.period_id = p.period_id
WHERE q.periodic_reinvest_ns_count = (SELECT MAX(periodic_reinvest_ns_count)
    FROM tw_vetting.fact_qpr_indicators)

UNION ALL

SELECT
    'Peak CV Alert Volume',
    p.period_label,
    q.cv_alerts_count,
    'alerts triaged'
FROM tw_vetting.fact_qpr_indicators q
JOIN tw_vetting.dim_period p ON q.period_id = p.period_id
WHERE q.cv_alerts_count = (SELECT MAX(cv_alerts_count)
    FROM tw_vetting.fact_qpr_indicators);