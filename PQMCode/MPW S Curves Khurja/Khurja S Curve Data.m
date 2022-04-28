let
    Source = Table.Combine({#"Khurja Unit 1 Raw", #"Khurja Unit 2 Raw", #"Khurja Common Raw"}),
    ColumnNames = Table.ColumnNames(Source),
    #"Converted to Table" = Table.FromList(ColumnNames, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Filtered Rows" = Table.SelectRows(#"Converted to Table", each not Text.Contains([Column1], "Column")),
    Custom1 = #"Filtered Rows"[Column1],
    SortedColumnNames = List.FirstN(Custom1,5) & SortDateList(List.Skip(Custom1,5)),
    #"Reordered Columns" = Table.ReorderColumns(Source,SortedColumnNames)
in
    #"Reordered Columns"