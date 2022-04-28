let
    Source = #"Package UOM List Raw",
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"KEY", type text}, {"Project", type text}, {"Unit", type text}, {"Package", type text}, {"Parameter", type text}, {"UOM", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"UOM"}),
    Custom1 = Excel.Workbook(File.Contents("\\mydata01\02.TeamData\14.ProjectControls&CapabilityCenter\02.InternalReporting\2.4 Flash Reports\2.4.0 Database\4. MPW S-Curves\MPW S-Curve Database Checklist.xlsx"), null, true),
    #"Filtered Rows" = Table.SelectRows(Custom1, each ([Kind] = "Table") and ([Name] = "Package_UOM_List")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Data"}),
    Data = #"Removed Other Columns"{0}[Data],
    #"Changed Type1" = Table.TransformColumnTypes(Data,{{"KEY", type text}, {"Project", type text}, {"Unit", type text}, {"Package", type text}, {"Parameter", type text}, {"UOM", type text}}),
    #"Merged Queries" = Table.NestedJoin(#"Removed Columns", {"KEY"}, #"Changed Type1", {"KEY"}, "Checklist", JoinKind.LeftOuter),
    #"Expanded Checklist" = Table.ExpandTableColumn(#"Merged Queries", "Checklist", {"UOM"}, {"UOM"})
in
    #"Expanded Checklist"