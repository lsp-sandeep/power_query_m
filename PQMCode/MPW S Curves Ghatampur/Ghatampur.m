let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.8 MPW Audit Reports\2022-02-Audit-18\MPW S-Curves\Ghatampur\Feb-22 S curves"),
    #"Filtered Rows" = Table.SelectRows(Source, each not Text.Contains([Name], "~")),
    #"Renamed Columns" = Table.RenameColumns(#"Filtered Rows",{{"Name", "Package"}}),
    #"Removed Other Columns" = Table.SelectColumns(#"Renamed Columns",{"Folder Path", "Package", "Content"}),
    #"Extracted Text Between Delimiters" = Table.TransformColumns(#"Removed Other Columns", {{"Folder Path", each Text.BetweenDelimiters(_, "\", "\", 6, 2), type text}}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Extracted Text Between Delimiters", "Folder Path", Splitter.SplitTextByDelimiter("\", QuoteStyle.Csv), {"AuditMonth", "SCurve", "Project"}),
    #"Removed Columns" = Table.RemoveColumns(#"Split Column by Delimiter",{"SCurve"}),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Removed Columns", {{"AuditMonth", each Text.BeforeDelimiter(_, "-", 1), type text}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Extracted Text Before Delimiter",{{"AuditMonth", type date}}),
    #"Calculated End of Month" = Table.TransformColumns(#"Changed Type",{{"AuditMonth", Date.EndOfMonth, type date}})
in
    #"Calculated End of Month"