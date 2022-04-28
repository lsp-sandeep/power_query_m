let
    Source = #"Khurja Source",
    #"Filtered Rows" = Table.SelectRows(Source, each Text.Contains([Unit], "1")),
    #"Expanded Custom" = Table.ExpandTableColumn(#"Filtered Rows", "Custom", {"Name", "Data", "Kind", "Hidden"}, {"Name", "Data", "Kind", "Hidden"}),
    #"Filtered Rows6" = Table.SelectRows(#"Expanded Custom", each ([Hidden] = false) and ([Kind] = "Sheet")),
    #"Removed Columns3" = Table.RemoveColumns(#"Filtered Rows6",{"Kind", "Hidden"}),
    #"Filtered Rows1" = Table.SelectRows(#"Removed Columns3", each not Text.Contains([Name], "Print_Area") and not Text.Contains([Name], "Print_Titles")),
    #"Added Custom1" = Table.AddColumn(#"Filtered Rows1", "Custom", each RemoveNullColumns(RemoveNullsInColumn([Data],"Column1"))),
    #"Added Custom2" = Table.AddColumn(#"Added Custom1", "Custom1", each Table.PromoteHeaders(Table.Skip([Custom],GetIndexInColumn([Custom],"Column1","Month Name"){0}), [PromoteAllScalars=true])),
    #"Added Custom" = Table.AddColumn(#"Added Custom2", "CleanData", each Table.RemoveColumns(Table.RemoveLastN([Custom1],GetLastNinColumn([Custom1], "Month Name", "Note")),{"Column2", "Column3", "Column4"})),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom",{"Data", "Custom", "Custom1"}),
    Custom1 = Table.ColumnNames(Table.Combine(#"Removed Columns1"[CleanData])),
    Custom2 = Table.ExpandTableColumn(#"Removed Columns1", "CleanData", Custom1),
    #"Renamed Columns2" = Table.RenameColumns(Custom2,{{"Month Name", "Parameter"}, {"Name", "Package"}})
in
    #"Renamed Columns2"