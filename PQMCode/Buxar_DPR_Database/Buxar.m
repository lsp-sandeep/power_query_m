let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\01.IncomingReports\1.3 Buxar 2x660 MW\1.6.1 Daily Progress Reports\2022\2022-04"),
    #"Filtered Rows2" = Table.SelectRows(Source, each not Text.Contains([Name], "~")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows2",{"Name", "Content"}),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Removed Other Columns", {{"Name", each Text.BeforeDelimiter(_, " "), type text}}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Extracted Text Before Delimiter", "Name", Splitter.SplitTextByEachDelimiter({"-"}, QuoteStyle.Csv, true), {"Date", "Project"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Date", type date}, {"Project", type text}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "Custom", each Excel.Workbook([Content])),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"Content"}),
    #"Expanded Custom" = Table.ExpandTableColumn(#"Removed Columns", "Custom", {"Name", "Data", "Kind", "Hidden"}, {"Custom.Name", "Custom.Data", "Custom.Kind", "Custom.Hidden"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Custom", each ([Custom.Kind] = "Sheet")),
    #"Renamed Columns" = Table.RenameColumns(#"Filtered Rows",{{"Custom.Name", "Unit"}, {"Custom.Data", "Data"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns",{"Custom.Kind", "Custom.Hidden"}),
    #"Filtered Rows1" = Table.SelectRows(#"Removed Columns1", each ([Unit] = "Unit-1" or [Unit] = "Unit-2"))
in
    #"Filtered Rows1"