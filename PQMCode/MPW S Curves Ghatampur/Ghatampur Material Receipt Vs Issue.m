let
    Source = Ghatampur,
    #"Filtered Rows1" = Table.SelectRows(Source, each Text.Contains([Package], "Material")),
    #"Extracted Text Between Delimiters" = Table.TransformColumns(#"Filtered Rows1", {{"Package", each Text.BetweenDelimiters(_, " ", " ", 0, 3), type text}}),
    #"Added Custom" = Table.AddColumn(#"Extracted Text Between Delimiters", "Workbooks", each Excel.Workbook([Content])),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"Content"}),
    #"Expanded Workbooks" = Table.ExpandTableColumn(#"Removed Columns", "Workbooks", {"Name", "Data", "Item", "Kind", "Hidden"}, {"Name", "Data", "Item", "Kind", "Hidden"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Workbooks", each ([Kind] = "Sheet") and ([Hidden] = false)),
    #"Replaced Value" = Table.ReplaceValue(#"Filtered Rows","U","Unit",Replacer.ReplaceText,{"Name"}),
    #"Trimmed Text" = Table.TransformColumns(#"Replaced Value",{{"Name", Text.Trim, type text}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Trimmed Text",{"Item", "Kind", "Hidden"}),
    #"Added Custom1" = Table.AddColumn(#"Removed Columns2", "Custom", each RemoveNullsInColumn(RemoveNullColumns([Data]),"Column1")),
    #"Added Custom2" = Table.AddColumn(#"Added Custom1", "CleanData", each Table.PromoteHeaders(Table.Skip([Custom],GetIndexInColumn([Custom],"Column1","Material"){1}), [PromoteAllScalars=true])),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom2",{"Data", "Custom"}),
    Custom1 = Table.ColumnNames(Table.Combine(#"Removed Columns1"[CleanData])),
    Custom2 = Table.ExpandTableColumn(#"Removed Columns1", "CleanData", Custom1),
    #"Renamed Columns" = Table.RenameColumns(Custom2,{{"Material", "Parameter"}, {"Name", "Unit"}}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Renamed Columns", "Parameter", Splitter.SplitTextByDelimiter("(", QuoteStyle.Csv), {"Parameter", "UOM"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Parameter", type text}, {"UOM", type text}}),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Changed Type", {{"UOM", each Text.BeforeDelimiter(_, ")"), type text}})
in
    #"Extracted Text Before Delimiter"