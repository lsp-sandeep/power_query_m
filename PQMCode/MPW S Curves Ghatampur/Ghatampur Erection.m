let
    Source = #"Ghatampur Mech & Civil",
    #"Filtered Rows" = Table.SelectRows(Source, each not Text.Contains([Package], "critical") and not Text.Contains([Package], "Civil")),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Filtered Rows", {{"Package", each Text.BeforeDelimiter(_, " ", 1), type text}}),
    #"Replaced Value1" = Table.ReplaceValue(#"Extracted Text Before Delimiter"," ","#",Replacer.ReplaceText,{"Package"}),
    #"Renamed Columns" = Table.RenameColumns(#"Replaced Value1",{{"Package", "Unit"}}),
    #"Extracted Text Before Delimiter1" = Table.TransformColumns(#"Renamed Columns", {{"Name", each Text.BeforeDelimiter(_, "#"), type text}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Extracted Text Before Delimiter1",{{"Name", "Package"}}),
    #"Replaced Value" = Table.ReplaceValue(#"Renamed Columns1","Unit","Boiler",Replacer.ReplaceText,{"Package"}),
    #"Added Custom1" = Table.AddColumn(#"Replaced Value", "Custom", each RemoveNullsInColumn(RemoveNullColumns([Data]),"Column1")),
    #"Added Custom2" = Table.AddColumn(#"Added Custom1", "CleanData", each Table.PromoteHeaders(Table.Skip([Custom],GetIndexInColumn([Custom],"Column1","Month"){0}), [PromoteAllScalars=true])),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom2",{"Data", "Custom"}),
    Custom1 = Table.ColumnNames(Table.Combine(#"Removed Columns1"[CleanData])),
    Custom2 = Table.ExpandTableColumn(#"Removed Columns1", "CleanData", Custom1),
    #"Renamed Columns2" = Table.RenameColumns(Custom2,{{"Month Name", "Parameter"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns2",{{"Parameter", type text}}),
    #"Filtered Rows1" = Table.SelectRows(#"Changed Type", each not Text.Contains([Parameter], ".") and not Text.Contains([Parameter], "1") and not Text.Contains([Parameter], "2") and not Text.Contains([Parameter], "3") and not Text.Contains([Parameter], "4") and not Text.Contains([Parameter], "5") and not Text.Contains([Parameter], "6") and not Text.Contains([Parameter], "7") and not Text.Contains([Parameter], "8") and not Text.Contains([Parameter], "9"))
in
    #"Filtered Rows1"