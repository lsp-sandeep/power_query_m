let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\01.IncomingReports\1.4 Khurja 2x660MW\1.7.4 HOP DFR\2022-04"),
    FilteredOpenFiles = Table.SelectRows(Source, each not Text.Contains([Name], "~")),
    RemovedOtherColumns = Table.SelectColumns(FilteredOpenFiles,{"Name", "Content"}),
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
    ExpandedCleanData = Table.ExpandTableColumn(RemovedRawData, "CleanData", {"Date", "Project", "Total Manpower (FTD)"}, {"Date.1", "Project.1", "Total Manpower (FTD)"}),
    RemovedRepeatedColumns = Table.RemoveColumns(ExpandedCleanData,{"Date.1", "Project.1"}),
    ChangedTypeOfCleanData = Table.TransformColumnTypes(RemovedRepeatedColumns,{{"Total Manpower (FTD)", Int64.Type}}),
    FilteredNullsInTotalManpower = Table.SelectRows(ChangedTypeOfCleanData, each ([#"Total Manpower (FTD)"] <> null)),
    RenamedToTotalManpower = Table.RenameColumns(FilteredNullsInTotalManpower,{{"Total Manpower (FTD)", "Total Manpower"}})
in
    RenamedToTotalManpower