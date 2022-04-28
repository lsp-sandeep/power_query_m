let
    Source = Khurja,

    #"Filtered Rows" = Table.SelectRows(Source, each ([Folder Path] = "Internal DPR")),

    #"ExpandedTables" = Table.ExpandTableColumn(#"Filtered Rows", "Workbooks", {"Name", "Data", "Kind"}, {"Name", "Data", "Kind"}),

    #"FilteredSheets" = Table.SelectRows(#"ExpandedTables",
                                        each ([Kind] = "Sheet") and ([Name] = "Summary")),

    #"RemovedTableExpand" = Table.RemoveColumns(#"FilteredSheets",{"Folder Path", "Name", "Kind"}),

    #"AddedCleanData" = Table.AddColumn(#"RemovedTableExpand", "CleanData",
                                        each Table.PromoteHeaders(Table.RemoveFirstN([Data],2))),

    #"RemovedData" = Table.RemoveColumns(#"AddedCleanData",{"Data"}),

    #"ExpandedCleanData" = Table.ExpandTableColumn(#"RemovedData", "CleanData",
                                                    Table.ColumnNames(Table.Combine(#"RemovedData"[CleanData])),
                                                    Table.ColumnNames(Table.Combine(#"RemovedData"[CleanData]))),

    #"FilledUpUOM" = Table.FillUp(#"ExpandedCleanData",{"UOM"}),

    #"RemovedPercentRemarks" = Table.RemoveColumns(#"FilledUpUOM",{"FTM % Comp.", "% Comp.", "Remarks"}),

    #"ChangedTypeSrnTxt" = Table.TransformColumnTypes(#"RemovedPercentRemarks",{{"Sr. No.", type text}}),

    #"AddedRomnsOfSr" = Table.AddColumn(#"ChangedTypeSrnTxt", "Roman",
                                        each Text.Select([#"Sr. No."],{"I","V","X","L"})),

    #"Added123OfSr" = Table.AddColumn(#"AddedRomnsOfSr", "123",
                                        each Text.Select([#"Sr. No."],{"0".."9"})),

    #"AddedABCofSr" = Table.AddColumn(#"Added123OfSr", "ABC",
                                        each if [#"Sr. No."] = [Roman] then null
                                            else if [#"Sr. No."] = [123] then null
                                            else [#"Sr. No."]),

    #"AddedPackage1" = Table.AddColumn(#"AddedABCofSr", "Package_1",
                                        each if [#"Sr. No."] = [ABC] then [Package] else null),

    #"AddedPackage2" = Table.AddColumn(#"AddedPackage1", "Package_2",
                                        each if [#"Sr. No."] = [Roman] then [Package] else null),
    #"ReplacedNullsRomn123" = Table.ReplaceValue(AddedPackage2, "", null, Replacer.ReplaceValue, {"Roman", "123"}),
    FilledDownP1P2RmnAbc123 = Table.FillDown(ReplacedNullsRomn123,{"ABC", "Roman", "Package_1", "Package_2"}),
    ReplacedContPwrInPckg2 = Table.ReplaceValue(FilledDownP1P2RmnAbc123,each [Package_2],each if [Package_1] = "Construction Power" then [Package_1] else [Package_2],Replacer.ReplaceValue,{"Package_2"}),

    RemovedSrNoRmn123ABC = Table.RemoveColumns(ReplacedContPwrInPckg2,{"Sr. No.", "Roman", "123", "ABC"}),
    RenamedPckgToPckg3 = Table.RenameColumns(RemovedSrNoRmn123ABC,{{"Package", "Package_3"}}),
    #"FilteredNullTentScp" = Table.SelectRows(RenamedPckgToPckg3,
                                        each ([Tentative Scope] <> null)),
    AddedTotalIndicator = Table.AddColumn(FilteredNullTentScp, "TotalIndicator", each if [Package_2] = [Package_3] then " (Total)" else null),
    #"Merged Columns" = Table.CombineColumns(AddedTotalIndicator,{"Package_3", "TotalIndicator"},Combiner.CombineTextByDelimiter("", QuoteStyle.None),"Package_3"),
    ReorderedKEYPckg1Pckg2 = Table.ReorderColumns(#"Merged Columns",{"Date", "Project", "Package_1", "Package_2", "Package_3", "UOM", "Tentative Scope", "Cum. Ach. Till #(lf)last month", "FTM Target", "FTM Actual", "Total. Ach. Till date"}),
    #"Renamed Columns" = Table.RenameColumns(ReorderedKEYPckg1Pckg2,{{"Tentative Scope", "Scope"}, {"Cum. Ach. Till #(lf)last month", "Completed LM"}, {"FTM Target", "Target FTM"}, {"FTM Actual", "Actual FTM"}, {"Total. Ach. Till date", "Completed TD"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns",{{"Package_1", type text}, {"Package_2", type text}, {"UOM", type text}, {"Scope", type number}, {"Completed LM", type number}, {"Target FTM", type number}, {"Actual FTM", type number}, {"Completed TD", type number}}),
    ReplacedDotInUOM = Table.ReplaceValue(#"Changed Type",".","",Replacer.ReplaceText,{"UOM"}),
    UppercasedOldUOM = Table.TransformColumns(ReplacedDotInUOM,{{"UOM", Text.Upper, type text}}),
    AddedNewUOM = Table.AddColumn(UppercasedOldUOM, "UOM.1", each if Text.Contains([UOM], "NOS") then "Nos" else if Text.Contains([UOM], "MTR") then "RM" else if Text.Contains([UOM], "RMT") then "RM" else [UOM]),
    RemovedOldUOM = Table.RemoveColumns(AddedNewUOM,{"UOM"}),
    RenamedNewUOM = Table.RenameColumns(RemovedOldUOM,{{"UOM.1", "UOM"}})
in
    RenamedNewUOM