let
    Source = Buxar,
    #"Inserted Merged Column" = Table.AddColumn(Source, "Merged", each Text.Combine({Text.From([Date], "en-IN"), [Project], [Unit]}, " | "), type text),
    #"Merged Queries" = Table.NestedJoin(#"Inserted Merged Column", {"Merged"}, IndexQuery, {"Merged"}, "IndexQuery", JoinKind.LeftOuter),
    #"Expanded IndexQuery" = Table.ExpandTableColumn(#"Merged Queries", "IndexQuery", {"Erection", "Other"}, {"Erection", "Other"}),
    #"Added Custom" = Table.AddColumn(#"Expanded IndexQuery", "Custom", each Table.PromoteHeaders(Table.FirstN(Table.RemoveFirstN([Data],[Erection]),[Other] - [Erection]))),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom",{"Data", "Merged", "Erection", "Other"}),
    #"Expanded Custom" = Table.ExpandTableColumn(#"Removed Columns1", "Custom", {"Area wise Erection Summary ", "Tentative - Scope #(lf)(In MT)", "Cum. Ach.", "Monthly", "Column7", "Day"}, {"Erection", "Scope (In MT)", "Cum. Ach.", "Monthly Target", "Monthly Actual", "Day Actual"}),
    #"Unpivoted Columns" = Table.UnpivotOtherColumns(#"Expanded Custom", {"Date", "Project", "Unit", "Scope (In MT)", "Cum. Ach.", "Monthly Target", "Monthly Actual", "Day Actual"}, "Attribute", "Value"),
    #"Renamed Columns" = Table.RenameColumns(#"Unpivoted Columns",{{"Attribute", "Package_1"}, {"Value", "Package_2"}, {"Cum. Ach.", "Completed TD"}, {"Monthly Target", "Target FTM"}, {"Monthly Actual", "Actual FTM"}, {"Day Actual", "Actual FTD"}}),
    #"Unpivoted Columns1" = Table.UnpivotOtherColumns(#"Renamed Columns", {"Date", "Project", "Unit", "Completed TD", "Target FTM", "Actual FTM", "Actual FTD", "Package_1", "Package_2"}, "Attribute", "Value"),
    #"Inserted Text Between Delimiters" = Table.AddColumn(#"Unpivoted Columns1", "UOM", each Text.BetweenDelimiters([Attribute], " (In ", ")"), type text),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Inserted Text Between Delimiters", {{"Attribute", each Text.BeforeDelimiter(_, " ("), type text}}),
    #"Pivoted Column" = Table.Pivot(#"Extracted Text Before Delimiter", List.Distinct(#"Extracted Text Before Delimiter"[Attribute]), "Attribute", "Value", List.Sum),
    #"Reordered Columns" = Table.ReorderColumns(#"Pivoted Column",{"Date", "Project", "Unit", "Package_1", "Package_2", "UOM", "Scope", "Completed TD", "Target FTM", "Actual FTM", "Actual FTD"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Reordered Columns",{{"Unit", type text}, {"Package_2", type text}, {"Scope", type number}, {"Completed TD", type number}, {"Target FTM", type number}, {"Actual FTM", type number}, {"Actual FTD", type number}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"Actual FTD"})
in
    #"Removed Columns"