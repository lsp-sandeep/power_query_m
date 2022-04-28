let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\01.IncomingReports\1.4 Khurja 2x660MW\1.7.1 Daily Progress Reports\2022\2022-04\Internal DPR"),
    FilteredOpenFiles = Table.SelectRows(Source, each not Text.Contains([Name], "~")),

    #"ExtractedImmediateFolderName" = Table.TransformColumns(FilteredOpenFiles, {{"Folder Path", each Text.BetweenDelimiters(_, "\", "\", {0, RelativePosition.FromEnd}, {0, RelativePosition.FromEnd}), type text}}),

    #"SelectedCntnNamImmFP" = Table.SelectColumns(#"ExtractedImmediateFolderName",{"Name", "Folder Path", "Content"}),

    #"ExtractedProjectNameDate" = Table.TransformColumns(#"SelectedCntnNamImmFP", {{"Name", each Text.BeforeDelimiter(_, " "), type text}}),

    #"SplitProjectName&Date" = Table.SplitColumn(#"ExtractedProjectNameDate", "Name", Splitter.SplitTextByEachDelimiter({"-"}, QuoteStyle.Csv, true), {"Date", "Project"}),

    AddedWrkbkFromBinary = Table.AddColumn(#"SplitProjectName&Date", "Workbooks", each Excel.Workbook([Content])),

    #"RemovedContent" = Table.RemoveColumns(AddedWrkbkFromBinary,{"Content"}),
    ChangedTypeDate = Table.TransformColumnTypes(RemovedContent,{{"Date", type date}})
in
    ChangedTypeDate