let
    Source = Ghatampur,
    #"Filtered Rows2" = Table.SelectRows(Source, each not Text.Contains([Package], "manpower")),
    #"Filtered Rows3" = Table.SelectRows(#"Filtered Rows2", each not Text.Contains([Package], "Material Receipt")),
    #"Added Custom" = Table.AddColumn(#"Filtered Rows3", "Workbooks", each Excel.Workbook([Content])),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"Content"}),
    #"Expanded Workbooks" = Table.ExpandTableColumn(#"Removed Columns", "Workbooks", {"Name", "Data", "Item", "Kind", "Hidden"}, {"Name", "Data", "Item", "Kind", "Hidden"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Workbooks", each ([Kind] = "Sheet") and ([Hidden] = false)),
    #"Removed Columns1" = Table.RemoveColumns(#"Filtered Rows",{"Item", "Kind", "Hidden"}),
    #"Trimmed Text" = Table.TransformColumns(#"Removed Columns1",{{"Name", Text.Trim, type text}}),
    #"Filtered Rows1" = Table.SelectRows(#"Trimmed Text", each not Text.Contains([Name], "Symbol") and not Text.Contains([Name], "NCR") and not Text.Contains([Name], "Sheet"))
in
    #"Filtered Rows1"