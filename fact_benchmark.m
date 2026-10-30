let
    Source = fnLoadCsv("fact_benchmark.csv"),
    Typed  = Table.TransformColumnTypes(Source, {{"date", type date}, {"index_level", type number}}, "en-US")
in
    Typed
