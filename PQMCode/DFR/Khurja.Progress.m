let
    Source = Excel.Workbook(File.Contents("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.4 Flash Reports\2.4.0 Database\1. DPR\2. Khurja\2022\2022-04\2022-04_Khurja_DPR_Database.xlsx"), null, true),
    Khurja_Progress_Table = Source{[Item="Khurja_Progress",Kind="Table"]}[Data],
    #"Changed Type" = Table.TransformColumnTypes(Khurja_Progress_Table,{{"Date", type date}, {"Project_Progress_ID", Int64.Type}, {"Project", type text}, {"Project_ID", Int64.Type}, {"Package_3", type text}, {"Package_1", type text}, {"Project_Progress_Package_1_ID", Int64.Type}, {"Package_2", type text}, {"Project_Progress_Package_2_ID", Int64.Type}, {"Project_Progress_Package_3_ID", Int64.Type}, {"UOM", type text}, {"Project_Progress_UOM_ID", Int64.Type}, {"Scope", type number}, {"Completed LM", type number}, {"Target FTM", type number}, {"Actual FTM", type number}, {"Completed TD", type number}})
in
    #"Changed Type"