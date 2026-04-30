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
-- QUERY 2: Continuous Vetting vs Reinvestigation
-- The TW 2.0 reform tradeoff in one query
-- =============================================
SELECT
    p.period_label,
    p.fiscal_year,
    p.quarter,
    q.periodic_reinvest_ns_count,
    q.cv_alerts_count,
    q.eapp_utilization_pct                              AS ns_cv_enrollment_pct,
    -- Reinvestigation decline rate vs prior year same quarter
    ROUND(
        100.0 * (q.periodic_reinvest_ns_count -
            LAG(q.periodic_reinvest_ns_count, 4)
                OVER (ORDER BY p.fiscal_year, p.quarter))
        / NULLIF(LAG(q.periodic_reinvest_ns_count, 4)
                OVER (ORDER BY p.fiscal_year, p.quarter), 0)
    , 1)                                               AS reinvest_yoy_pct_change
FROM tw_vetting.fact_qpr_indicators q
JOIN tw_vetting.dim_period p ON q.period_id = p.period_id
WHERE q.periodic_reinvest_ns_count IS NOT NULL
   OR q.cv_alerts_count IS NOT NULL
ORDER BY p.fiscal_year, p.quarter;