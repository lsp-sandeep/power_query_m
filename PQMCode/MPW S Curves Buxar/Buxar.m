let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.8 MPW Audit Reports\2022-02-Audit-18\MPW S-Curves\Buxar"),
    #"Filtered Rows1" = Table.SelectRows(Source, each ([Extension] = ".xlsx")),
    #"Filtered Rows" = Table.SelectRows(#"Filtered Rows1", each not Text.Contains([Name], "~") and not Text.Contains([Name], "Timeline")),
    #"Renamed Columns" = Table.RenameColumns(#"Filtered Rows",{{"Name", "Package"}}),
    #"Removed Other Columns" = Table.SelectColumns(#"Renamed Columns",{"Folder Path", "Package", "Content"}),
    #"Extracted Text Between Delimiters1" = Table.TransformColumns(#"Removed Other Columns", {{"Package", each Text.BetweenDelimiters(_, "_", "."), type text}}),
    #"Extracted Text Between Delimiters" = Table.TransformColumns(#"Extracted Text Between Delimiters1", {{"Folder Path", each Text.BetweenDelimiters(_, "\", "\", 6, 0), type text}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Extracted Text Between Delimiters",{{"Folder Path", "AuditMonth"}}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Renamed Columns1", "Package", Splitter.SplitTextByDelimiter(" ", QuoteStyle.Csv), {"Project", "Unit"}),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Split Column by Delimiter", {{"AuditMonth", each Text.BeforeDelimiter(_, "-", 1), type text}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Extracted Text Before Delimiter",{{"AuditMonth", type date}}),
    #"Calculated End of Month" = Table.TransformColumns(#"Changed Type",{{"AuditMonth", Date.EndOfMonth, type date}})
in
    #"Calculated End of Month"