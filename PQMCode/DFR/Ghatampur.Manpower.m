let
    Source = Excel.Workbook(File.Contents("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.4 Flash Reports\2.4.0 Database\1. DPR\1. Ghatampur\2022\2022-04\2022-04_Ghatampur_DPR_Database.xlsx"), null, true),
    Ghatampur_Manpower_Table = Source{[Item="Ghatampur_Manpower",Kind="Table"]}[Data],
    #"Changed Type" = Table.TransformColumnTypes(Ghatampur_Manpower_Table,{{"Date", type date}, {"Project_Manpower_ID", Int64.Type}, {"Project", type text}, {"Project_ID", Int64.Type}, {"Package_1", type text}, {"Project_Manpower_Package_1_ID", Int64.Type}, {"UOM", type text}, {"Project_Manpower_UOM_ID", Int64.Type}, {"Manpower", Int64.Type}})
in
    #"Changed Type"