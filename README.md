# Private Markets Reporting Dashboard (Power BI)

A fund-reporting dashboard for a multi-asset private markets programme (private equity, private
debt, real estate, infrastructure). It covers the figures an LP reporting or investment team
produces every quarter: **paid-in, distributions, NAV, unfunded commitments, TVPI / DPI / RVPI,
net IRR (XIRR), Kaplan–Schoar PME**, allocation against target, the commitment pacing plan and the
liquidity of an evergreen fund.

**Interactive preview:** `preview/dashboard.html` (open it in a browser, or enable GitHub Pages on `/preview`)

![Dashboard preview](screenshots/html_preview.png)

> Data is **simulated** by the companion Python project
> [private-markets-allocation](../private-markets-allocation) (Takahashi–Alexander cash-flow model).
> Fund names are fictional.

## Contents
```
data/          star-schema CSVs: dim_fund, dim_date, dim_asset_class, fact_cashflows, fact_benchmark,
               plus pacing_plan and evergreen_tradeoff
powerquery/    M code for every query: a DataFolder parameter, a reusable fnLoadCsv function,
               explicit column types and data-quality checks that stop the refresh if a rule breaks
dax/           all measures, including XIRR-based Net IRR and KS-PME
docs/          BUILD_GUIDE.md: model, pages, formatting and expected values to check against
preview/       HTML preview of the dashboard design (Chart.js)
```

## Data model
```
dim_asset_class (target weights)
        │ 1:*
     dim_fund ──1:*── fact_cashflows ──*:1── dim_date ──1:*── fact_benchmark
```

## Key measures
| Measure | Logic |
|---|---|
| TVPI | (cumulative distributions + NAV at the as-of date) / cumulative paid-in |
| DPI / RVPI | realised / unrealised part of TVPI |
| Net IRR | `XIRR` on net LP flows, with as-of NAV as terminal value |
| KS-PME | flows compounded with the listed index to the as-of date; above 1 = outperformance |
| NAV Weight vs Target | allocation drift by asset class |

*Author: Diptakshi Sen.*
