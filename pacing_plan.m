let
    Source = fnLoadCsv("pacing_plan.csv"),
    Typed  = Table.TransformColumnTypes(Source, {
        {"year", Int64.Type}, {"asset_class", type text}, {"commitment", type number},
        {"projected_nav", type number}, {"target_nav", type number}, {"total_portfolio", type number}}, "en-US")
in
    Typed
