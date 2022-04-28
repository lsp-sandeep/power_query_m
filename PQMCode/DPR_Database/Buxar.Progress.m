let
    Source = Buxar_Source,
    #"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "Buxar_Progress")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Data"}),
    ColumnNames = Table.ColumnNames(Table.Combine(#"Removed Other Columns"[Data])),
    #"Expanded Data" = Table.ExpandTableColumn(#"Removed Other Columns", "Data", ColumnNames),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Data",{{"Date", type date}, {"Project_Progress_ID", Int64.Type}, {"Project", type text}, {"Project_ID", Int64.Type}, {"Unit", type text}, {"Project_Progress_Unit_ID", Int64.Type}, {"Package_1", type text}, {"Project_Progress_Package_1_ID", Int64.Type}, {"Package_2", type text}, {"Project_Progress_Package_2_ID", Int64.Type}, {"UOM", type text}, {"Project_Progress_UOM_ID", Int64.Type}, {"Scope", type number}, {"Completed TD", type number}, {"Target FTM", Int64.Type}, {"Actual FTM", type number}})
in
    #"Changed Type"