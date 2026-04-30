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
-- QUERY 1: The Backlog Crisis Arc
-- Inventory + TS timeliness over time
-- Shows the OPM breach impact and recovery
-- =============================================
SELECT
    p.period_label,
    p.fiscal_year,
    p.quarter,
    q.dcsa_inventory_count,
    q.end_to_end_days_ts,
    q.end_to_end_days_secret,
    -- Inventory change quarter over quarter
    q.dcsa_inventory_count - LAG(q.dcsa_inventory_count)
        OVER (ORDER BY p.fiscal_year, p.quarter)        AS inventory_qoq_change,
    -- Rolling 4-quarter average TS timeliness
    AVG(q.end_to_end_days_ts)
        OVER (ORDER BY p.fiscal_year, p.quarter
              ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS ts_rolling_4q_avg
FROM tw_vetting.fact_qpr_indicators q
JOIN tw_vetting.dim_period p ON q.period_id = p.period_id
WHERE q.dcsa_inventory_count IS NOT NULL
ORDER BY p.fiscal_year, p.quarter;