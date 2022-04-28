let
    Source = Ghatampur_Source,
    ExpandedCleanData = Table.ExpandTableColumn(Source, "CleanData", {"Date", "Project", "Package", "Unit", "Description", "UOM", "Total Scope", "Total Completed Till Date", "FTM Target", "FTM Actual", "FTD Target", "FTD Actual"}, {"Date.1", "Project.1", "Package", "Unit", "Description", "UOM", "Total Scope", "Total Completed Till Date", "FTM Target", "FTM Actual", "FTD Target", "FTD Actual"}),
    RemovedRepeatedColumns = Table.RemoveColumns(ExpandedCleanData,{"Date.1", "Project.1"}),
    ChangedTypeOfCleanData = Table.TransformColumnTypes(RemovedRepeatedColumns,{{"Package", type text}, {"Unit", type text}, {"Description", type text}, {"UOM", type text}, {"Total Scope", type number}, {"Total Completed Till Date", type number}, {"FTM Target", type number}, {"FTM Actual", type number}, {"FTD Target", type number}, {"FTD Actual", type number}}),
    FilledDownNames = Table.FillDown(ChangedTypeOfCleanData,{"Package", "Unit"})
in
    FilledDownNames