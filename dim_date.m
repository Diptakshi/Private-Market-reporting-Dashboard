let
    Source = fnLoadCsv("dim_date.csv"),
    Typed  = Table.TransformColumnTypes(Source, {
        {"date", type date}, {"year", Int64.Type}, {"quarter", type text},
        {"year_quarter", type text}, {"quarter_index", Int64.Type}}, "en-US")
in
    Typed
