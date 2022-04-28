let
    Source = Khurja,
    #"FilteredInternals" = Table.SelectRows(Source, each ([Folder Path] = "Internal DPR")),

    #"KeptlatestFile" = Table.LastN(#"FilteredInternals", 1),

    #"ExpandedWrkbks" = Table.ExpandTableColumn(#"KeptlatestFile", "Workbooks", {"Name", "Data", "Kind"}, {"Name", "Data", "Kind"}),

    #"FilteredDLRSheets" = Table.SelectRows(#"ExpandedWrkbks", each ([Kind] = "Sheet") and ([Name] = "DLR")),

    #"RemovedKind" = Table.RemoveColumns(#"FilteredDLRSheets",{"Kind"}),

    RenamedNameToParameter = Table.RenameColumns(#"RemovedKind",{{"Name", "Parameter"}}),

    #"ReplacedDLRToManPwr" = Table.ReplaceValue(RenamedNameToParameter,"DLR","Manpower",Replacer.ReplaceText,{"Parameter"}),

    #"AddedCleanData" = Table.AddColumn(ReplacedDLRToManPwr, "CleanData", each Table.RemoveLastN(Table.Skip(Table.PromoteHeaders(Table.Skip([Data],1), [PromoteAllScalars=true]),5),2)),

    #"RemovedOldDataFldrPthDate" = Table.RemoveColumns(#"AddedCleanData",{"Data", "Folder Path", "Date"}),

    #"ExpandedCleanData" = Table.ExpandTableColumn(#"RemovedOldDataFldrPthDate", "CleanData", Table.ColumnNames(Table.Combine(#"RemovedOldDataFldrPthDate"[CleanData]))),

    #"RemovedVendorCode" = Table.RemoveColumns(ExpandedCleanData,{"Vendor Code"}),

    #"RenamedClm4ToPckgAToSrN" = Table.RenameColumns(#"RemovedVendorCode",{{"Column4", "Package"}, {"A", "Sr. No."}, {"Site Staff Details", "Package_3"}}),

    AddedIndexClmn = Table.AddIndexColumn(RenamedClm4ToPckgAToSrN, "Index", 1, 1, Int64.Type),

    #"SelectedA2ZFrmSrN" = Table.AddColumn(AddedIndexClmn, "A2Z", each Text.Select([#"Sr. No."],{"A".."z"}), type text),

    #"ReplacedErrorsInA2Z" = Table.ReplaceErrorValues(#"SelectedA2ZFrmSrN", {{"A2Z", null}}),

    AddedPckg1 = Table.AddColumn(#"ReplacedErrorsInA2Z", "Package_1", each if [A2Z] <> null then [Package] else null),
    ExtractedUnitNo = Table.AddColumn(AddedPckg1, "Unit No", each Text.AfterDelimiter([Package], "#"), type text),
    #"FilledDownPckg2" = Table.FillDown(ExtractedUnitNo,{"Package_1"}),

    RenamedPckgToPckg2 = Table.RenameColumns(#"FilledDownPckg2",{{"Package", "Package_2"}}),

    #"FilteredNullsInSrNA2Z" = Table.SelectRows(RenamedPckgToPckg2, each ([#"Sr. No."] <> null) and ([A2Z] = null)),

    RemovedSrNA2ZUnitNo = Table.RemoveColumns(#"FilteredNullsInSrNA2Z",{"Sr. No.", "A2Z", "Unit No"}),

    #"UnpivotedDates" = Table.UnpivotOtherColumns(RemovedSrNA2ZUnitNo, {"Project", "Index", "Package_1", "Package_2", "Package_3", "Parameter"}, "Date", "Value"),
    ReplacedHyphenTo0InManpwr = Table.ReplaceValue(UnpivotedDates,"-",0,Replacer.ReplaceValue,{"Value"}),
    ChangedDateType = Table.TransformColumnTypes(ReplacedHyphenTo0InManpwr,{{"Date", type date}}),
    FilteredCurrentMonth = Table.SelectRows(ChangedDateType, each [Date] >= #date(2022, 4, 1) and [Date] <= #date(2022, 4, 30)),
    #"SortedDates" = Table.Sort(FilteredCurrentMonth,{{"Date", Order.Ascending}, {"Index", Order.Ascending}}),
    RemovedIndex = Table.RemoveColumns(SortedDates,{"Index"}),
    #"Pivoted Column" = Table.Pivot(RemovedIndex, List.Distinct(RemovedIndex[Parameter]), "Parameter", "Value", List.Sum),
    ReorderedColumns = Table.ReorderColumns(#"Pivoted Column",{"Date", "Project", "Package_1", "Package_2", "Package_3", "Manpower"}),
    #"Unpivoted Columns" = Table.UnpivotOtherColumns(ReorderedColumns, {"Date", "Project", "Package_1", "Package_2", "Package_3"}, "Parameter", "Value"),
    #"Changed Type" = Table.TransformColumnTypes(#"Unpivoted Columns",{{"Value", Int64.Type}, {"Package_2", type text}, {"Package_3", type text}, {"Package_1", type text}})
in
    #"Changed Type"