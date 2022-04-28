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
    ExpandedCleanData = Table.ExpandTableColumn(RemovedRawData, "CleanData", {"Date", "Project", "Package", "Unit", "Description", "UOM", "Total Scope", "Total Completed Till Date", "FTM Target", "FTM Actual", "FTD Target", "FTD Actual"}, {"Date.1", "Project.1", "Package", "Unit", "Description", "UOM", "Total Scope", "Total Completed Till Date", "FTM Target", "FTM Actual", "FTD Target", "FTD Actual"}),
    FilteredNullsInDescription = Table.SelectRows(ExpandedCleanData, each ([Description] <> null)),
    RemovedRepeatedColumns = Table.RemoveColumns(FilteredNullsInDescription,{"Date.1", "Project.1"}),
    ChangedTypeOfCleanData = Table.TransformColumnTypes(RemovedRepeatedColumns,{{"Package", type text}, {"Unit", type text}, {"Description", type text}, {"UOM", type text}, {"Total Scope", type number}, {"Total Completed Till Date", type number}, {"FTM Target", type number}, {"FTM Actual", type number}, {"FTD Target", type number}, {"FTD Actual", type number}}),
    FilledDownNames = Table.FillDown(ChangedTypeOfCleanData,{"Package", "Unit"})
in
    FilledDownNames