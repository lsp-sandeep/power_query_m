let
    Source = Buxar_Source,
    #"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "Buxar_Manpower")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Data"}),
    ColumnNames = Table.ColumnNames(Table.Combine(#"Removed Other Columns"[Data])),
    #"Expanded Data" = Table.ExpandTableColumn(#"Removed Other Columns", "Data", ColumnNames),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Data",{{"Date", type date}, {"Project_Manpower_ID", Int64.Type}, {"Project", type text}, {"Project_ID", Int64.Type}, {"Unit", type text}, {"Project_Manpower_Unit_ID", Int64.Type}, {"Package_1", type text}, {"Project_Manpower_Package_1_ID", Int64.Type}, {"Package_2", type text}, {"Project_Manpower_Package_2_ID", Int64.Type}, {"UOM", type text}, {"Project_Manpower_UOM_ID", Int64.Type}, {"Manpower", Int64.Type}})
in
    #"Changed Type"