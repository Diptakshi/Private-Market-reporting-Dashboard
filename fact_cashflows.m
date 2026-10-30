let
    Source = fnLoadCsv("fact_cashflows.csv"),
    Typed  = Table.TransformColumnTypes(Source, {
        {"fund_id", type text}, {"date", type date}, {"fund_quarter", Int64.Type},
        {"call", type number}, {"distribution", type number}, {"nav", type number},
        {"net_cashflow", type number}}, "en-US"),
    // Data-quality checks: stop the refresh if a rule is broken
    NoNegatives = if Table.RowCount(Table.SelectRows(Typed, each [call] < 0 or [distribution] < 0 or [nav] < -0.001)) > 0
                  then error "fact_cashflows: negative call, distribution or NAV found" else Typed,
    NoDupes     = if Table.RowCount(NoNegatives) <> Table.RowCount(Table.Distinct(NoNegatives, {"fund_id", "date"}))
                  then error "fact_cashflows: duplicate fund_id/date rows" else NoNegatives
in
    NoDupes
