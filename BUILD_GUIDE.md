# Build guide: Power BI Desktop (about 1–2 hours)

> Power BI Desktop runs on **Windows only**. On a Mac, use a KEDGE computer-lab PC, a Windows virtual
> machine (Parallels / UTM), or a cloud Windows desktop. Until then, `preview/dashboard.html` shows the
> intended design.

> **Fastest route:** open `pbip/Private_Markets_Dashboard.pbip` and click Refresh: the model, measures and
> four pages are already built. The steps below rebuild everything by hand.

## 1. Load the data (Power Query)
1. **Home → Transform data** opens the Power Query editor.
2. **Manage Parameters → New**: name it `DataFolder`, type *Text*, value = full path to the folder holding the CSVs
   (ending with `\`).
3. **New Source → Blank Query → Advanced Editor**. Paste `fnLoadCsv.m` and rename the
   query `fnLoadCsv`.
4. For each remaining `.m` file, create a blank query, paste the code and name the query
   after the file (`dim_fund`, `dim_date`, `dim_asset_class`, `fact_cashflows`, `fact_benchmark`,
   `pacing_plan`, `evergreen_tradeoff`).
5. **Close & Apply.** `fact_cashflows` includes two data-quality checks (no negative flows, no
   duplicate fund/date rows). If either rule breaks, the refresh fails with a clear message.

## 2. Model (Model view)
| From (one) | To (many) | Column |
|---|---|---|
| dim_fund | fact_cashflows | fund_id |
| dim_date | fact_cashflows | date |
| dim_date | fact_benchmark | date |
| dim_asset_class | dim_fund | asset_class |

All relationships use single-direction filtering. Mark `dim_date` as a date table (**Table tools →
Mark as date table → date**). Hide the foreign-key columns in the fact tables.

## 3. Measures
Create an empty table `_Measures` (**Home → Enter data → OK**). Add every measure from
`measures.dax`. Formats: EUR m measures `#,0`; TVPI/DPI/RVPI/KS-PME `0.00`; Net IRR and the
weights as percentages with one decimal place.

## 4. Pages
**Page 1: Portfolio overview**
- Slicers along the top: `dim_date[year_quarter]` (single select, default 2026-Q2),
  `dim_asset_class[asset_class]`, `dim_fund[vintage]`.
- A row of cards: Committed, Paid In (cum), Distributed (cum), NAV, TVPI, DPI, Net IRR, KS-PME.
- Stacked area: axis `dim_date[date]`, values `[NAV]` broken down by `dim_fund[asset_class]`.
  Add a visual-level filter on dates ≤ the slicer date.
- Clustered bar: `dim_asset_class[asset_class]` × `[NAV Weight]` and `[Target Weight]`.

**Page 2: Fund performance**
- Matrix: fund_name, asset_class, vintage, Committed, Paid In, Distributed, NAV, TVPI, DPI,
  Net IRR, KS-PME. Apply conditional formatting to TVPI and KS-PME (background scale, midpoint 1.0).
- Bar chart: TVPI by fund, coloured by asset class.

**Page 3: Cash flows and J-curve**
- Clustered column: `[Calls (qtr)]` (negative) and `[Distributions (qtr)]` by date.
- Line: `[Cumulative Net Cash Flow]` by date. The J-curve should show on a single vintage
  (filter vintage = 2017).

**Page 4: Pacing and liquidity**
- Stacked column: `pacing_plan[commitment]` by year and asset_class.
- Line: sum of `projected_nav` and `target_nav` by year.
- Line: `evergreen_tradeoff[prob_forced_sale_10y]` by `liquid_target`, plus a table with the return drag.

Theme: one colour per asset class, kept the same on every page. Private Equity `#2a78d6`, Private
Debt `#eb6834`, Real Estate `#1baf7a`, Infrastructure `#eda100`.

## 5. Check your numbers (all funds, as of 30 Jun 2026)
| Measure | Expected |
|---|---|
| Committed | 655 |
| Paid In (cum) | ≈ 614 |
| Distributed (cum) | ≈ 438 |
| NAV | ≈ 386 |
| TVPI / DPI | ≈ 1.34x / 0.71x |
| Net IRR | ≈ 9% (XIRR uses actual dates, so it can differ by a few bp from the Python quarterly IRR) |
| KS-PME | ≈ 1.06 |

Save the file as `private_markets_dashboard.pbix`, export each page as PNG into `screenshots/`, and
commit both.
