let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\01.IncomingReports\1.2 Ghatampur 3x660 MW\1.4.1 Daily Progress Reports\2022\2022-04"),
    #"Filtered Rows" = Table.SelectRows(Source, each not Text.Contains([Name], "~")),
    RemovedOtherFileColumns = Table.SelectColumns(#"Filtered Rows",{"Name", "Content"}),
    ExtractedProjectDetails = Table.TransformColumns(RemovedOtherFileColumns, {{"Name", each Text.BeforeDelimiter(_, " "), type text}}),
    #"Split Column by Delimiter" = Table.SplitColumn(ExtractedProjectDetails, "Name", Splitter.SplitTextByEachDelimiter({"-"}, QuoteStyle.Csv, true), {"Date", "Project"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Date", type date}, {"Project", type text}}),
    ExtractedWorkbkFrmFiles = Table.AddColumn(#"Changed Type", "Workbooks", each Excel.Workbook([Content])),
    RemovedContent = Table.RemoveColumns(ExtractedWorkbkFrmFiles,{"Content"}),
    ExpandedWorkbooks = Table.ExpandTableColumn(RemovedContent, "Workbooks", {"Name", "Data", "Kind", "Hidden"}, {"Name", "Data", "Kind", "Hidden"}),
    FilteredUsefulSheets = Table.SelectRows(ExpandedWorkbooks, each ([Kind] = "Sheet") and ([Name] = "a)-Group summary Civil" or [Name] = "b) Group Summary Mech,E&I" or [Name] = "Manpower Report")),
    RemovedOtherSheetColumns = Table.RemoveColumns(FilteredUsefulSheets,{"Kind", "Hidden"}),
    RenamedNameToPckg1 = Table.RenameColumns(RemovedOtherSheetColumns,{{"Name", "Package_1"}, {"Data", "Sheets"}})
in
    RenamedNameToPckg1