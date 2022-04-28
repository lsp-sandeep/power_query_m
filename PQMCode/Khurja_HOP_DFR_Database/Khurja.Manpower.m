let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\01.IncomingReports\1.4 Khurja 2x660MW\1.7.4 HOP DFR\2022-04"),
    FileteredOpenFiles = Table.SelectRows(Source, each not Text.Contains([Name], "~")),
    RemovedOtherColumns = Table.SelectColumns(FileteredOpenFiles,{"Name", "Content"}),
    SplitDateAndprojectName = Table.SplitColumn(RemovedOtherColumns, "Name", Splitter.SplitTextByEachDelimiter({"-"}, QuoteStyle.Csv, true), {"Date", "Project"}),
    ChangedTypeOfDateColumn = Table.TransformColumnTypes(SplitDateAndprojectName,{{"Date", type date}}),
    ExtractedProjectName = Table.TransformColumns(ChangedTypeOfDateColumn, {{"Project", each Text.BetweenDelimiters(_, " ", ".", {0, RelativePosition.FromEnd}, 0), type text}}),
    ExtractedSheets = Table.AddColumn(ExtractedProjectName, "Sheets", each Excel.Workbook([Content])),
    RemovedRawContents = Table.RemoveColumns(ExtractedSheets,{"Content"}),
    ExpandedSheets = Table.ExpandTableColumn(RemovedRawContents, "Sheets", {"Name", "Data", "Item", "Kind", "Hidden"}, {"Name", "Data", "Item", "Kind", "Hidden"}),
    FilteredSheets = Table.SelectRows(ExpandedSheets, each ([Kind] = "Sheet")),
    RemovedOtherSheetsColumns = Table.SelectColumns(FilteredSheets,{"Date", "Project", "Data"}),
    PreliminaryCleaningOfData = Table.AddColumn(RemovedOtherSheetsColumns, "CleanData", each Table.PromoteHeaders([Data])),
    RemovedRawData = Table.RemoveColumns(PreliminaryCleaningOfData,{"Data"}),
    ExpandedCleanData = Table.ExpandTableColumn(RemovedRawData, "CleanData", {"Date", "Project", "Package", "Unit", "Description", "Manpower"}, {"Date.1", "Project.1", "Package", "Unit", "Description", "Manpower"}),
    FilteredNullsInDescription = Table.SelectRows(ExpandedCleanData, each ([Description] <> null)),
    RemovedRepeatedColumns = Table.RemoveColumns(FilteredNullsInDescription,{"Date.1", "Project.1"}),
    ChangedTypeOfCleanData = Table.TransformColumnTypes(RemovedRepeatedColumns,{{"Package", type text}, {"Unit", type text}, {"Description", type text}, {"Manpower", Int64.Type}}),
    FilledDownNames = Table.FillDown(ChangedTypeOfCleanData,{"Package", "Unit"}),
    #"Filtered Rows" = Table.SelectRows(FilledDownNames, each ([Manpower] <> null))
in
    #"Filtered Rows"