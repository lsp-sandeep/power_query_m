let
    Source = #"Ghatampur Source",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Project_ID", "Project", "Data"}),
    #"Expanded Data" = Table.ExpandTableColumn(#"Removed Other Columns", "Data", {"Name", "Data", "Item", "Kind", "Hidden"}, {"Name", "Data", "Item", "Kind", "Hidden"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Data", each ([Kind] <> "DefinedName") and ([Name] = "Issue Log")),
    #"Removed Other Columns1" = Table.SelectColumns(#"Filtered Rows",{"Project_ID", "Project", "Data"}),
    ColumnNamesList = Table.ColumnNames(Table.Combine(#"Removed Other Columns1"[Data])),
    ExpandedTable = Table.ExpandTableColumn(#"Removed Other Columns1", "Data", ColumnNamesList),
    #"Removed Top Rows" = Table.Skip(ExpandedTable,1),
    #"Promoted Headers" = Table.PromoteHeaders(#"Removed Top Rows", [PromoteAllScalars=true]),
    #"Renamed Columns" = Table.RenameColumns(#"Promoted Headers",{{"Ghatampur", "Project"}, {"11010", "Project_ID"}}),
    #"Removed Other Columns2" = Table.SelectColumns(#"Renamed Columns",{"Project_ID", "Project", "Open/#(lf)Closed", "Priority"}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Removed Other Columns2",{{"Open/#(lf)Closed", Text.Proper, type text}}),
    #"Grouped Rows" = Table.Group(#"Capitalized Each Word", {"Project_ID", "Project", "Open/#(lf)Closed", "Priority"}, {{"TotalCount", each Table.RowCount(_), Int64.Type}})
in
    #"Grouped Rows"