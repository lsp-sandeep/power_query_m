let
    Source = Khurja_Source,
    #"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "Khurja_Progress")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Data"}),
    ColumnNames = Table.ColumnNames(Table.Combine(#"Removed Other Columns"[Data])),
    #"Expanded Data" = Table.ExpandTableColumn(#"Removed Other Columns", "Data", ColumnNames),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Data",{{"Date", type date}, {"Project_Progress_ID", Int64.Type}, {"Project", type text}, {"Project_ID", Int64.Type}, {"Package_3", type text}, {"Package_1", type text}, {"Project_Progress_Package_1_ID", Int64.Type}, {"Package_2", type text}, {"Project_Progress_Package_2_ID", Int64.Type}, {"Project_Progress_Package_3_ID", Int64.Type}, {"UOM", type text}, {"Project_Progress_UOM_ID", Int64.Type}, {"Scope", type number}, {"Completed LM", type number}, {"Target FTM", type number}, {"Actual FTM", type number}, {"Completed TD", type number}})
in
    #"Changed Type"