let
    Source = Excel.Workbook(File.Contents("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.4 Flash Reports\2.4.0 Database\6. HOP DFR\0. All\2022\2022-04\2022-04_HOP_DFR_Database.xlsx"), null, true),
    Project_Total_Manpower_Table = Source{[Item="Project_Total_Manpower",Kind="Table"]}[Data],
    #"Changed Type" = Table.TransformColumnTypes(Project_Total_Manpower_Table,{{"Date", type date}, {"ID", Int64.Type}, {"Project_Total_Manpower_ID", Int64.Type}, {"Project", type text}, {"Project_ID", Int64.Type}, {"UOM", type text}, {"Project_Manpower_UOM_ID", Int64.Type}, {"Total_Manpower", Int64.Type}})
in
    #"Changed Type"