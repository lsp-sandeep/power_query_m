let
    Source = #"Ghatampur Mech & Civil",
    #"Filtered Rows" = Table.SelectRows(Source, each Text.Contains([Package], "critical")),
    #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows",{"Package"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Name", "Package"}}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Renamed Columns", "Package", Splitter.SplitTextByEachDelimiter({" "}, QuoteStyle.Csv, false), {"Unit", "Package"}),
    #"Replaced Value" = Table.ReplaceValue(#"Split Column by Delimiter","U","Unit",Replacer.ReplaceText,{"Unit"}),
    #"Added Custom1" = Table.AddColumn(#"Replaced Value", "Custom", each RemoveNullsInColumn(RemoveNullColumns([Data]),"Column1")),
    #"Added Custom2" = Table.AddColumn(#"Added Custom1", "CleanData", each Table.PromoteHeaders(Table.Skip([Custom],GetIndexInColumn([Custom],"Column1","Month"){0}), [PromoteAllScalars=true])),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom2",{"Data", "Custom"}),
    Custom1 = Table.ColumnNames(Table.Combine(#"Removed Columns1"[CleanData])),
    Custom2 = Table.ExpandTableColumn(#"Removed Columns1", "CleanData", Custom1),
    #"Renamed Columns2" = Table.RenameColumns(Custom2,{{"Month Name", "Parameter"}})
in
    #"Renamed Columns2"