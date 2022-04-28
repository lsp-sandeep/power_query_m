let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\05.MinutesofMeetings\5.2 Internal Meetings\5.2.6 Buxar 2x660 MW\Issue Log"),
    #"Filtered Rows" = Table.SelectRows(Source, each not Text.Contains([Name], "~")),
    // Selected the Date, Name and Data columns and removed others
    RemoveUselessColumns = Table.SelectColumns(#"Filtered Rows",{"Date created", "Date modified", "Name", "Content"}),
    // Extracted Date and Project Name from the Name Column using Text Before delimiter ' '
    #"ExtractedDate&ProjectName" = Table.TransformColumns(RemoveUselessColumns, {{"Name", each Text.BeforeDelimiter(_, " "), type text}}),
    // Split the File name into Date and project name column
    #"SplitNameIntoDate&Project" = Table.SplitColumn(#"ExtractedDate&ProjectName", "Name", Splitter.SplitTextByEachDelimiter({"-"}, QuoteStyle.Csv, true), {"Date on file", "Project"}),
    // Change type of date columns into date type
    ChangeTypeOfDateColumns = Table.TransformColumnTypes(#"SplitNameIntoDate&Project",{{"Date on file", type date}, {"Project", type text}, {"Date created", type date}, {"Date modified", type date}}),
    #"Sorted Rows" = Table.Sort(ChangeTypeOfDateColumns,{{"Date created", Order.Ascending}, {"Date modified", Order.Ascending}, {"Date on file", Order.Ascending}}),
    #"Kept Last Rows" = Table.LastN(#"Sorted Rows", 1),
    #"Added Custom" = Table.AddColumn(#"Kept Last Rows", "Data", each Excel.Workbook([Content])),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"Content"}),
    Project_ID = Table.AddColumn(#"Removed Columns", "Project_ID", each 51007),
    ChangedTypeOfProjectID = Table.TransformColumnTypes(Project_ID,{{"Project_ID", type text}})
in
    ChangedTypeOfProjectID