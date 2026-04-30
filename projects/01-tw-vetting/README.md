# Project 01 — Trusted Workforce 2.0 Vetting Analysis

## Overview
SQL and Power BI analysis of the federal personnel vetting system using 
congressionally mandated public data sources. Covers FY2015–FY2026 across 
three legally required reporting series.

## Key Findings

| Metric | Peak | Latest | Change |
|--------|------|--------|--------|
| TS Processing Time | 414 days (FY2019 Q1) | 220 days (FY2025 Q4) | -47% |
| Investigation Inventory | 710,759 (FY2018 Q2) | 114,993 (FY2026 Q1) | -84% |
| NS Periodic Reinvestigations | 99,486 (FY2020 Q1) | 2,756 (FY2025 Q4) | -97% |
| Transfer of Trust | 40 days avg (FY2019 Q3) | 1 day (FY2021 Q3+) | -98% |

## Data Sources

| Source | Series | Coverage | Mandate |
|--------|--------|----------|---------|
| ODNI Annual Reports | Clearance population, timeliness, denials | FY2015, FY2017, FY2019 | 50 U.S.C. § 3104 |
| PAC QPR Legacy Metrics | 12 KPI series | FY2016 Q1 – FY2026 Q1 | President's Management Agenda |
| DCSA Adjudications YIR | DoD adjudication volume | FY2021 | NDAA FY2018 |

## Schema
8-table star schema in SQL Server 2025:
- `tw_vetting.dim_period` — 49 fiscal periods across all report series
- `tw_vetting.fact_qpr_indicators` — 41 quarters of QPR KPI time series
- `tw_vetting.fact_clearance_population` — clearance counts by level and type
- `tw_vetting.fact_clearance_approvals` — annual approval volumes
- `tw_vetting.fact_agency_timeliness` — IC agency processing times
- `tw_vetting.fact_investigation_age` — pending case age distribution
- `tw_vetting.fact_denials_revocations` — denial and revocation rates
- `tw_vetting.fact_adjudicative_delays` — delay causes by adjudicative category

## SQL Skills Demonstrated
- Star schema design with computed columns
- BULK INSERT with staging table ETL pipeline
- CASE-based pivot (wide to narrow transformation)
- Window functions: LAG(), LEAD(), AVG() OVER(), RANK()
- CTEs and multi-table JOINs
- NULL handling for redacted and unavailable government data

## Dashboard
3-page Power BI report covering:
- Executive Overview — KPI cards and the backlog crisis arc
- TW 2.0 Reform Progress — CV enrollment vs reinvestigation decline
- IC Agency Performance — timeliness, denial rates, adjudicative delays

## Data Limitations Noted
- FY2019 IC agency performance data redacted under 50 U.S.C. § 3104 (b)(3)
- FY2017 report uses anonymized Agency #1-#10 labels (CVS system limitation)
- FY2015 denials/revocations reported as percentages, not absolute counts
- State Department unable to provide investigation age data in FY2015

![Executive Overview](assets/screenshots/page1_executive_overview.png)