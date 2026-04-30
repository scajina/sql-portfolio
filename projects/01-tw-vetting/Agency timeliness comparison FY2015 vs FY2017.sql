-- Preview: Agency timeliness comparison FY2015 vs FY2017
-- Shows which named agencies improved or worsened
SELECT
    t17.agency_name,
    t17.clearance_level,
    t17.percentile_80_days                          AS fy2017_p80,
    t17.percentile_90_days                          AS fy2017_p90,
    t17.range_longest_days                          AS fy2017_longest,
    t17.range_shortest_days                         AS fy2017_shortest,
    -- Gap between 80th and 90th percentile
    -- reveals how many outlier cases exist
    (t17.percentile_90_days - t17.percentile_80_days) AS p80_to_p90_gap_days,
    -- Rank agencies by TS processing speed
    RANK() OVER (
        PARTITION BY t17.clearance_level 
        ORDER BY t17.percentile_80_days ASC
    )                                               AS speed_rank
FROM tw_vetting.fact_agency_timeliness t17
JOIN tw_vetting.dim_period p ON t17.period_id = p.period_id
WHERE p.fiscal_year = 2017
AND t17.percentile_80_days IS NOT NULL
ORDER BY t17.clearance_level, speed_rank;