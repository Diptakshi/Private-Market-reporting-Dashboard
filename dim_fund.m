let
    Source = fnLoadCsv("dim_fund.csv"),
    Typed  = Table.TransformColumnTypes(Source, {
        {"fund_id", type text}, {"fund_name", type text}, {"asset_class", type text},
        {"vintage", Int64.Type}, {"commitment_eur_m", type number}}, "en-US")
in
    Typed
