let
    Source = Table.Combine({Ghatampur_Source, Khurja_Source, Buxar_Source}),
    Filtered_Manpower = Table.SelectRows(Source, each Text.Contains([Item], "Manpower") and not Text.Contains([Item], "Total")),
    Removed_Other_Columns = Table.SelectColumns(Filtered_Manpower,{"Data"}),
    #"Expanded Data" = Table.ExpandTableColumn(Removed_Other_Columns, "Data", {"Date", "Project", "Package", "Unit", "Description", "Manpower"}, {"Date", "Project", "Package", "Unit", "Description", "Manpower"}),
    Changed_Data_Types = Table.TransformColumnTypes(#"Expanded Data",{{"Date", type date}, {"Project", type text}, {"Package", type text}, {"Unit", type text}, {"Description", type text}, {"Manpower", Int64.Type}}),
    #"Renamed Columns" = Table.RenameColumns(Changed_Data_Types,{{"Package", "Package_1"}, {"Description", "Package_2"}})
in
    #"Renamed Columns"