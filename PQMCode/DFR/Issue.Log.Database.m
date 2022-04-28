let
    Source = Excel.Workbook(File.Contents("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.4 Flash Reports\2.4.0 Database\2. Issue Logs\0. All\Issue_Log_Database.xlsx"), null, true),
    #"Filtered Rows" = Table.SelectRows(Source, each ([Kind] = "Table")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Data"}),
    Data = #"Removed Other Columns"{0}[Data],
    #"Changed Type" = Table.TransformColumnTypes(Data,{{"Project_ID", Int64.Type}, {"Project", type text}, {"P1", Int64.Type}, {"Total", Int64.Type}, {"Date modified", type date}})
in
    #"Changed Type"