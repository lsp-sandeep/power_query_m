let
    Source = Table.Combine({Ghatampur_Source, Khurja_Source, Buxar_Source}),
    Filtered_Progress = Table.SelectRows(Source, each Text.Contains([Item], "Progress")),
    Removed_Other_Columns = Table.SelectColumns(Filtered_Progress,{"Data"}),
    Expanded_Progress_Data = Table.ExpandTableColumn(Removed_Other_Columns, "Data", {"Date", "Project", "Package", "Unit", "Description", "UOM", "Total Scope", "Total Completed Till Date", "FTM Target", "FTM Actual", "FTD Target", "FTD Actual"}, {"Date", "Project", "Package", "Unit", "Description", "UOM", "Total Scope", "Total Completed Till Date", "FTM Target", "FTM Actual", "FTD Target", "FTD Actual"}),
    Changed_Data_Types = Table.TransformColumnTypes(Expanded_Progress_Data,{{"Date", type date}, {"Project", type text}, {"Package", type text}, {"Unit", type text}, {"Description", type text}, {"UOM", type text}, {"Total Scope", type number}, {"Total Completed Till Date", type number}, {"FTM Target", type number}, {"FTM Actual", type number}, {"FTD Target", type number}, {"FTD Actual", type number}}),
    #"Renamed Columns" = Table.RenameColumns(Changed_Data_Types,{{"Package", "Package_1"}, {"Description", "Package_2"}, {"Total Scope", "Scope"}, {"Total Completed Till Date", "Completed"}, {"FTM Target", "Target FTM"}, {"FTM Actual", "Actual FTM"}, {"FTD Target", "Target FTD"}, {"FTD Actual", "Actual FTD"}})
in
    #"Renamed Columns"