let
    Source = Excel.Workbook(File.Contents("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.4 Flash Reports\2.4.0 Database\6. HOP DFR\0. All\2022\2022-04\2022-04_HOP_DFR_Database.xlsx"), null, true),
    Project_Progress_Table = Source{[Item="Project_Progress",Kind="Table"]}[Data],
    #"Changed Type" = Table.TransformColumnTypes(Project_Progress_Table,{{"Date", type date}, {"ID", Int64.Type}, {"Project_Progress_ID", Int64.Type}, {"Project", type text}, {"Project_ID", Int64.Type}, {"Unit", type text}, {"Project_Progress_Package_2_ID", Int64.Type}, {"Project_Progress_Unit_ID", Int64.Type}, {"Package_1", type text}, {"Project_Progress_Package_1_ID", Int64.Type}, {"Package_2", type text}, {"UOM", type text}, {"Project_Progress_UOM_ID", Int64.Type}, {"Scope", type number}, {"Actual FTM", type number}, {"Completed", type number}, {"Target FTM", type number}, {"Target FTD", type number}, {"Actual FTD", type number}})
in
    #"Changed Type"