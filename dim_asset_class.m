let
    Source = fnLoadCsv("dim_asset_class.csv"),
    Typed  = Table.TransformColumnTypes(Source, {
        {"asset_class", type text}, {"target_weight", Percentage.Type}, {"sort_order", Int64.Type}}, "en-US")
in
    Typed
