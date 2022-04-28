let
    Source = Folder.Files("\\mydata01\02.teamdata\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.4 Flash Reports\2.4.0 Database\1. DPR\3. Buxar\2022\2022-04"),
    FilteredOpenedFiles = Table.SelectRows(Source, each not Text.Contains([Name], "~")),
    FilteredRequiredFile = Table.SelectRows(FilteredOpenedFiles, each ([Name] = "2022-04_Buxar_DPR_Database.xlsx")),
    #"Removed Other Columns" = Table.SelectColumns(FilteredRequiredFile,{"Content"}),
    #"Added Custom" = Table.AddColumn(#"Removed Other Columns", "Data", each Excel.Workbook([Content])),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"Content"}),
    #"Expanded Data" = Table.ExpandTableColumn(#"Removed Columns", "Data", {"Name", "Data", "Item", "Kind", "Hidden"}, {"Name", "Data", "Item", "Kind", "Hidden"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Data", each ([Kind] = "Table")),
    #"Removed Other Columns1" = Table.SelectColumns(#"Filtered Rows",{"Name", "Data"})
in
    #"Removed Other Columns1"