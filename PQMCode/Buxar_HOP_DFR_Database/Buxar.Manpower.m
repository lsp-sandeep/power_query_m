let
    Source = Buxar_Source,
    ExpandedCleanData = Table.ExpandTableColumn(Source, "CleanData", {"Date", "Project", "Package", "Unit", "Description", "Manpower"}, {"Date.1", "Project.1", "Package", "Unit", "Description", "Manpower"}),
    RemovedRepeatedColumns = Table.RemoveColumns(ExpandedCleanData,{"Date.1", "Project.1"}),
    ChangedTypeOfCleanData = Table.TransformColumnTypes(RemovedRepeatedColumns,{{"Package", type text}, {"Unit", type text}, {"Description", type text}, {"Manpower", Int64.Type}}),
    FilledDownNames = Table.FillDown(ChangedTypeOfCleanData,{"Package", "Unit"})
in
    FilledDownNames