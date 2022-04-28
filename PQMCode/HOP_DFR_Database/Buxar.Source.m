let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.4 Flash Reports\2.4.0 Database\6. HOP DFR\3. Buxar\2022\2022-04"),
    Filtered_Open_Files = Table.SelectRows(Source, each not Text.Contains([Name], "~")),
    Removed_Other_Columns = Table.SelectColumns(Filtered_Open_Files,{"Content"}),
    Extracted_Workbook = Table.AddColumn(Removed_Other_Columns, "Sheets", each Excel.Workbook([Content])),
    Removed_Content = Table.RemoveColumns(Extracted_Workbook,{"Content"}),
    Expanded_Sheets = Table.ExpandTableColumn(Removed_Content, "Sheets", {"Name", "Data", "Item", "Kind", "Hidden"}, {"Name", "Data", "Item", "Kind", "Hidden"}),
    Filtered_Tables = Table.SelectRows(Expanded_Sheets, each ([Kind] = "Table")),
    Removed_Other_Columns1 = Table.SelectColumns(Filtered_Tables,{"Item", "Data"})
in
    Removed_Other_Columns1