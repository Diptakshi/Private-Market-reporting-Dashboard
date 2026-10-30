// Function: fnLoadCsv(fileName as text) - loads a UTF-8 CSV from DataFolder and promotes headers.
(fileName as text) as table =>
let
    Source   = Csv.Document(File.Contents(DataFolder & fileName),
                            [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true])
in
    Promoted
