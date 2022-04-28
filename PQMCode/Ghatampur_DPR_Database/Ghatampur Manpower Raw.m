let
    Source = Ghatampur,
    #"Filtered Rows" = Table.SelectRows(Source, each ([Package_1] = "Manpower Report")),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Filtered Rows", {{"Package_1", each Text.BeforeDelimiter(_, " "), type text}}),
    Custom1 = Table.ColumnNames(Table.Combine(#"Extracted Text Before Delimiter"[Sheets])),
    #"Expanded Custom" = Table.ExpandTableColumn(#"Extracted Text Before Delimiter", "Sheets", Custom1),
    #"Removed Columns3" = Table.RemoveColumns(#"Expanded Custom",{"Column5", "Column6", "Column7"}),
    #"Added Conditional Column" = Table.AddColumn(#"Removed Columns3", "Custom", each if [Column4] = "Remarks" then null else [Column4]),
    #"Filled Down1" = Table.FillDown(#"Added Conditional Column",{"Custom"}),
    #"Filtered Rows1" = Table.SelectRows(#"Filled Down1", each ([Column1] <> null and [Column1] <> "Manpower Report")),
    #"Changed Type" = Table.TransformColumnTypes(#"Filtered Rows1",{{"Custom", type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Changed Type",{"Column4"}),
    #"Promoted Headers" = Table.PromoteHeaders(#"Removed Columns1", [PromoteAllScalars=true]),
    #"Filtered Rows3" = Table.SelectRows(#"Promoted Headers", each ([#"S.N."] <> "S.N." and [#"S.N."] <> "Total ")),
    #"Removed Columns2" = Table.RemoveColumns(#"Filtered Rows3",{"S.N."}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns2",{{Table.ColumnNames(#"Removed Columns2"){0}, "Date"}, {Table.ColumnNames(#"Removed Columns2"){5}, "Package_3"}, {"Ghatampur", "Project"}, {"Manpower", "Parameter"}, {"Category", "Package_1"}, {"Actual deployed", "Value"}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns1",{{"Package_3", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type1",{"Package_3"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Removed Columns",{{"Date", type date}, {"Project", type text}, {"Parameter", type text}, {"Package_1", type text}, {"Value", Int64.Type}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type2",{"Date", "Project", "Package_1", "Parameter", "Value"})
in
    #"Reordered Columns"