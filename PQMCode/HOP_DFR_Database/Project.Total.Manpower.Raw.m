let
    Source = Table.Combine({Ghatampur_Source, Khurja_Source, Buxar_Source}),
    Filtered_Total_Manpower = Table.SelectRows(Source, each Text.Contains([Item], "Manpower") and Text.Contains([Item], "Total")),
    Removed_Other_Columns = Table.SelectColumns(Filtered_Total_Manpower,{"Data"}),
    Expanded_Total_Manpower_Data = Table.ExpandTableColumn(Removed_Other_Columns, "Data", {"Date", "Project", "Total Manpower"}, {"Date", "Project", "Total Manpower"}),
    Changed_Data_Types = Table.TransformColumnTypes(Expanded_Total_Manpower_Data,{{"Date", type date}, {"Project", type text}, {"Total Manpower", Int64.Type}}),
    #"Renamed Columns" = Table.RenameColumns(Changed_Data_Types,{{"Total Manpower", "Total_Manpower"}})
in
    #"Renamed Columns"