let
    Source = Table.Combine({#"Ghatampur S Curve Data", #"Buxar S Curve Data", #"Khurja S Curve Data"}),
    ColumnNames = Table.ColumnNames(Source),
    #"Converted to Table" = Table.FromList(ColumnNames, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Filtered Rows" = Table.SelectRows(#"Converted to Table", each not Text.Contains([Column1], "Column")),
    Custom1 = #"Filtered Rows"[Column1],
    SortedColumnNames = List.FirstN(Custom1,6) & SortDateList(List.Skip(Custom1,6)),
    #"Reordered Columns" = Table.ReorderColumns(Source,SortedColumnNames),
    #"Inserted Merged Column" = Table.AddColumn(#"Reordered Columns", "KEY", each Text.Combine({[Project], [Unit], [Package], [Parameter]}, " | "), type text)
in
    #"Inserted Merged Column"