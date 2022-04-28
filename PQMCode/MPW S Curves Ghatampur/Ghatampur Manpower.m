let
    Source = Ghatampur,
    #"Filtered Rows2" = Table.SelectRows(Source, each Text.Contains([Package], "manpower") and not Text.Contains([Package], "Total")),
    #"Added Custom" = Table.AddColumn(#"Filtered Rows2", "Workbooks", each Excel.Workbook([Content])),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"Package" , "Content"}),
    #"Expanded Workbooks" = Table.ExpandTableColumn(#"Removed Columns", "Workbooks", {"Name", "Data", "Item", "Kind", "Hidden"}, {"Name", "Data", "Item", "Kind", "Hidden"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Workbooks", each not Text.Contains([Name], "_") and not Text.Contains([Name], "Sheet") and ([Hidden] <> true)),
    #"Trimmed Text" = Table.TransformColumns(#"Filtered Rows",{{"Name", Text.Trim, type text}}),
    #"Removed Other Columns1" = Table.SelectColumns(#"Trimmed Text",{"AuditMonth", "Project", "Name", "Data"}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Removed Other Columns1", "Name", Splitter.SplitTextByDelimiter(" ", QuoteStyle.Csv), {"Name.1", "Name.2", "Name.3"}),
    #"Replaced Value" = Table.ReplaceValue(#"Split Column by Delimiter","U","Unit",Replacer.ReplaceText,{"Name.3"}),
    #"Added Conditional Column" = Table.AddColumn(#"Replaced Value", "Unit", each if Text.Contains([Name.1], "#") then [Name.1] else [Name.3]),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Conditional Column", "Custom", each if Text.Contains([Name.1], "#") then "Mechanical" else [Name.1]),
    #"Inserted Merged Column" = Table.AddColumn(#"Added Conditional Column1", "Package", each Text.Combine({[Custom], [Name.2]}, " "), type text),
    #"Removed Other Columns" = Table.SelectColumns(#"Inserted Merged Column",{"AuditMonth", "Project", "Unit", "Package", "Data"}),
    #"Added Custom1" = Table.AddColumn(#"Removed Other Columns", "Custom", each RemoveNullColumns(RemoveNullsInColumn([Data],"Column1"))),
    #"Added Custom2" = Table.AddColumn(#"Added Custom1", "CleanData", each Table.PromoteHeaders(Table.Skip([Custom],GetIndexInColumn([Custom],"Column1","Month"){0}), [PromoteAllScalars=true])),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom2",{"Data", "Custom"}),
    Custom1 = Table.ColumnNames(Table.Combine(#"Removed Columns1"[CleanData])),
    Custom2 = Table.ExpandTableColumn(#"Removed Columns1", "CleanData", Custom1),
    #"Renamed Columns" = Table.RenameColumns(Custom2,{{"Month Name", "Parameter"}})
in
    #"Renamed Columns"