let
    Source = fnLoadCsv("evergreen_tradeoff.csv"),
    Typed  = Table.TransformColumnTypes(Source, {
        {"liquid_target", Percentage.Type}, {"prob_gate_10y", Percentage.Type},
        {"prob_forced_sale_10y", Percentage.Type}, {"median_min_liquidity", Percentage.Type},
        {"p5_min_liquidity", Percentage.Type}, {"expected_return_drag", Percentage.Type}}, "en-US")
in
    Typed
