let
    Source = Excel.Workbook(File.Contents("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.4 Flash Reports\2.4.0 Database\4. MPW S-Curves\1. Ghatampur\2022\2022-02\2022-02 MPW S Curves Ghatampur.xlsx"), null, true),
    #"Filtered Rows" = Table.SelectRows(Source, each ([Kind] = "Table")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Data"}),
    Data = #"Removed Other Columns"{0}[Data]
in
    Data