let
    Source = Buxar,
    #"Filtered Rows" = Table.SelectRows(Source, each ([Unit] = "Unit-02")),
    #"Added Custom" = Table.AddColumn(#"Filtered Rows", "Custom", each Excel.Workbook([Content])),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"Content"}),
    #"Expanded Custom" = Table.ExpandTableColumn(#"Removed Columns", "Custom", {"Name", "Data", "Kind", "Hidden"}, {"Name", "Data", "Kind", "Hidden"}),
    #"Filtered Rows3" = Table.SelectRows(#"Expanded Custom", each ([Kind] = "Sheet") and ([Hidden] = false) and ([Name] <> "Balance S-Curves")),
    #"Removed Columns3" = Table.RemoveColumns(#"Filtered Rows3",{"Kind", "Hidden"}),
    #"Filtered Rows2" = Table.SelectRows(#"Removed Columns3", each ([Name] <> "Balance S-Curves" and [Name] <> "Contractual" and [Name] <> "Internal-1" and [Name] <> "Internal-2")),
    #"Extracted Text Between Delimiters" = Table.TransformColumns(#"Filtered Rows2", {{"Name", each Text.BetweenDelimiters(_, ". ", " ("), type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Extracted Text Between Delimiters",{{"Name", "Package"}}),
    #"Added Custom1" = Table.AddColumn(#"Renamed Columns", "Custom", each RemoveNullColumns([Data])),
    #"Added Custom3" = Table.AddColumn(#"Added Custom1", "Custom1", each RemoveNullsInColumn([Custom],Table.ColumnNames([Custom]){0})),
    #"Added Custom2" = Table.AddColumn(#"Added Custom3", "CleanData", each Table.PromoteHeaders(Table.Skip([Custom1],GetIndexInColumn([Custom1],Table.ColumnNames([Custom1]){0},"Month Name"){0}), [PromoteAllScalars=true])),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom2",{"Data", "Custom", "Custom1"}),
    Custom1 = Table.ColumnNames(Table.Combine(#"Removed Columns1"[CleanData])),
    Custom2 = Table.ExpandTableColumn(#"Removed Columns1", "CleanData", Custom1),
    #"Renamed Columns2" = Table.RenameColumns(Custom2,{{"Month Name", "Parameter"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns2",{"Column46", "Column39"})
in
    #"Removed Columns2"