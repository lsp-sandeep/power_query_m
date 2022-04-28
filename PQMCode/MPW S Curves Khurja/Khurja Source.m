let
    Source = Folder.Files("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.8 MPW Audit Reports\2022-02-Audit-18\MPW S-Curves\Khurja"),
    #"Filtered Rows" = Table.SelectRows(Source, each not Text.Contains([Name], "~")),
    #"Filtered Rows2" = Table.SelectRows(#"Filtered Rows", each ([Extension] = ".xlsx")),
    #"Renamed Columns" = Table.RenameColumns(#"Filtered Rows2",{{"Name", "Package"}}),
    #"Filtered Rows1" = Table.SelectRows(#"Renamed Columns", each Text.Contains([Package], "S Curve")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows1",{"Folder Path", "Package", "Content"}),
    #"Extracted Text Between Delimiters" = Table.TransformColumns(#"Removed Other Columns", {{"Folder Path", each Text.BetweenDelimiters(_, "\", "\", 6, 2), type text}}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Extracted Text Between Delimiters", "Folder Path", Splitter.SplitTextByDelimiter("\", QuoteStyle.Csv), {"AuditMonth", "SCurve", "Project"}),
    #"Removed Columns" = Table.RemoveColumns(#"Split Column by Delimiter",{"SCurve"}),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Removed Columns", {{"AuditMonth", each Text.BeforeDelimiter(_, "-", 1), type text}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Extracted Text Before Delimiter",{{"AuditMonth", type date}}),
    #"Calculated End of Month" = Table.TransformColumns(#"Changed Type",{{"AuditMonth", Date.EndOfMonth, type date}}),
    #"Added Custom" = Table.AddColumn(#"Calculated End of Month", "Custom", each Excel.Workbook([Content])),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom",{"Content"}),
    #"Inserted Text Between Delimiters" = Table.AddColumn(#"Removed Columns1", "Unit", each Text.BetweenDelimiters([Package], " ", "-", {1, RelativePosition.FromEnd}, {0, RelativePosition.FromEnd}), type text),
    #"Replaced Value" = Table.ReplaceValue(#"Inserted Text Between Delimiters","BOP","Common",Replacer.ReplaceText,{"Unit"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value"," ","-0",Replacer.ReplaceText,{"Unit"}),
    #"Removed Other Columns1" = Table.SelectColumns(#"Replaced Value1",{"AuditMonth", "Project", "Unit", "Custom"})
in
    #"Removed Other Columns1"