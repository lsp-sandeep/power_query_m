let
    Source = Excel.Workbook(File.Contents("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.4 Flash Reports\2.4.0 Database\1. DPR\3. Buxar\2022\2022-04\2022-04_Buxar_DPR_Database.xlsx"), null, true),
    Buxar_Progress_Table = Source{[Item="Buxar_Progress",Kind="Table"]}[Data],
    #"Changed Type" = Table.TransformColumnTypes(Buxar_Progress_Table,{{"Date", type date}, {"Project_Progress_ID", Int64.Type}, {"Project", type text}, {"Project_ID", Int64.Type}, {"Unit", type text}, {"Project_Progress_Unit_ID", Int64.Type}, {"Package_1", type text}, {"Project_Progress_Package_1_ID", Int64.Type}, {"Package_2", type text}, {"Project_Progress_Package_2_ID", Int64.Type}, {"UOM", type text}, {"Project_Progress_UOM_ID", Int64.Type}, {"Scope", type number}, {"Completed TD", type number}, {"Target FTM", Int64.Type}, {"Actual FTM", type number}})
in
    #"Changed Type"