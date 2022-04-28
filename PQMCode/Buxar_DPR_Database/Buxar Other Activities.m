let
    Source = Buxar,
    #"Inserted Merged Column" = Table.AddColumn(Source, "Merged", each Text.Combine({Text.From([Date], "en-IN"), [Project], [Unit]}, " | "), type text),
    #"Merged Queries" = Table.NestedJoin(#"Inserted Merged Column", {"Merged"}, IndexQuery, {"Merged"}, "IndexQuery", JoinKind.LeftOuter),
    #"Expanded IndexQuery" = Table.ExpandTableColumn(#"Merged Queries", "IndexQuery", {"Manpower", "Other"}, {"Manpower", "Other"}),
    #"Added Custom" = Table.AddColumn(#"Expanded IndexQuery", "Custom", each Table.PromoteHeaders(Table.FirstN(Table.RemoveFirstN([Data],[Other]),[Manpower] - [Other]))),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom",{"Data", "Merged", "Manpower", "Other"}),
    #"Expanded Custom" = Table.ExpandTableColumn(#"Removed Columns1", "Custom", {"Area wise other activities", "UOM", "Tentative", "Cum. Ach.", "Monthly", "Column7"}, {"Other Activities", "UOM", "Tentative", "Cum. Ach.", "Monthly Target", "Monthly Actual"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Custom", each ([Other Activities] <> null)),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Filtered Rows", {{"Other Activities", each Text.BeforeDelimiter(_, " ("), type text}}),
    #"Unpivoted Columns" = Table.UnpivotOtherColumns(#"Extracted Text Before Delimiter", {"Date", "Project", "Unit", "UOM", "Tentative", "Cum. Ach.", "Monthly Target", "Monthly Actual"}, "Attribute", "Value"),
    #"Renamed Columns" = Table.RenameColumns(#"Unpivoted Columns",{{"Attribute", "Package_1"}, {"Value", "Package_2"}, {"Tentative", "Scope"}, {"Cum. Ach.", "Completed TD"}, {"Monthly Target", "Target FTM"}, {"Monthly Actual", "Actual FTM"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns",{{"Unit", type text}, {"UOM", type text}, {"Scope", type number}, {"Completed TD", type number}, {"Target FTM", type number}, {"Actual FTM", type number}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type",{"Date", "Project", "Unit", "Package_1", "Package_2", "UOM", "Scope", "Completed TD", "Target FTM", "Actual FTM"})
in
    #"Reordered Columns"