let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\01.IncomingReports\1.3 Buxar 2x660 MW\1.6.4 HOP DFR\2022-04"),
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
    RemovedRawData = Table.RemoveColumns(PreliminaryCleaningOfData,{"Data"})
in
    RemovedRawData