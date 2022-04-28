let
    Source = Buxar_Source,
    ExpandedCleanData = Table.ExpandTableColumn(Source, "CleanData", {"Date", "Project", "Total Manpower (FTD)"}, {"Date.1", "Project.1", "Total Manpower (FTD)"}),
    RemovedRepeatedColumns = Table.RemoveColumns(ExpandedCleanData,{"Date.1", "Project.1"}),
    ChangedTypeOfCleanData = Table.TransformColumnTypes(RemovedRepeatedColumns,{{"Total Manpower (FTD)", Int64.Type}}),
    FilteredNullsInTotalManpower = Table.SelectRows(ChangedTypeOfCleanData, each [#"Total Manpower (FTD)"] <> null and [#"Total Manpower (FTD)"] <> ""),
    RenamedToTotalManpower = Table.RenameColumns(FilteredNullsInTotalManpower,{{"Total Manpower (FTD)", "Total Manpower"}})
in
    RenamedToTotalManpower