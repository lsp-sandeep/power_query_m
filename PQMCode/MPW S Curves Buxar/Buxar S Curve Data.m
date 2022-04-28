let
    Source = Table.Combine({#"Buxar Unit 1 Raw", #"Buxar Unit 2 Raw"}),
    #"Inserted Text Between Delimiters" = Table.AddColumn(Source, "UOM2", each Text.BetweenDelimiters([Parameter], "(", ")"), type text),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Inserted Text Between Delimiters", {{"Parameter", each Text.BeforeDelimiter(_, " ("), type text}}),
    #"Merged Columns" = Table.CombineColumns(#"Extracted Text Before Delimiter",{"UOM2", "UOM"},Combiner.CombineTextByDelimiter("", QuoteStyle.None),"UOM"),
    ColumnNames = Table.ColumnNames(#"Merged Columns"),
    SortedColumnNames = List.FirstN(ColumnNames,6) & SortDateList(List.Skip(ColumnNames,6)),
    #"Reordered Columns" = Table.ReorderColumns(#"Merged Columns",SortedColumnNames)
in
    #"Reordered Columns"