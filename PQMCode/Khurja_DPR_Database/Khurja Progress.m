let
    Source = #"Khurja Progress Raw",
    #"Sorted Rows1" = Table.Sort(Source,{{"Date", Order.Ascending}, {"Project", Order.Ascending}, {"Package_1", Order.Ascending}, {"Package_2", Order.Ascending}, {"Package_3", Order.Ascending}, {"UOM", Order.Ascending}}),
    ID = Table.AddIndexColumn(#"Sorted Rows1", "ID", 1, 1, Int64.Type),
    #"Changed Type1" = Table.TransformColumnTypes(ID,{{"ID", type text}, {"Date", type text}}),
    #"Unpivoted Columns" = Table.UnpivotOtherColumns(#"Changed Type1", {"Date", "Project", "Package_1", "Package_2", "Package_3", "UOM", "ID"}, "Parameter", "Value"),
    UOM_ID = Add_Index_ID_Column(#"Unpivoted Columns", "Progress", "UOM"),
    Package_3_ID = Add_Index_ID_Column(UOM_ID, "Progress", "Package_3"),
    Package_2_ID = Add_Index_ID_Column(Package_3_ID, "Progress", "Package_2"),
    Package_1_ID = Add_Index_ID_Column(Package_2_ID, "Progress", "Package_1"),
    Project_ID = Table.AddColumn(Package_1_ID, "Project_ID", each if [Project] = "Khurja" then 11015 else null),
    #"Changed Type2" = Table.TransformColumnTypes(Project_ID,{{"Project_ID", type text}}),

    Project_Progress_ID =
    let
        #"Changed Type4" = Table.TransformColumnTypes(#"Changed Type2",{{"ID", Int64.Type}}),
        #"Sorted Rows" = Table.Sort(#"Changed Type4",{{"ID", Order.Ascending}}),
        #"Changed Type3" = Table.TransformColumnTypes(#"Sorted Rows",{{"ID", type text}}),
        Project_Progress_ID_KEY = Table.AddColumn(#"Changed Type3", "", each Text.Combine({Text.From([Project_Progress_Package_1_ID], "en-IN"), Text.From([Project_Progress_Package_2_ID], "en-IN"), Text.From([Project_Progress_Package_3_ID], "en-IN"), Text.From([Project_Progress_UOM_ID], "en-IN")}, "-"), type text),
        Add_ID = Add_Index_ID_Column(Project_Progress_ID_KEY, "Progress", ""),
        #"Renamed Columns" = Table.RenameColumns(Add_ID,{{"Project_Progress__ID", "Project_Progress_ID"}}),
        #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{""})
    in 
        #"Removed Columns",

    #"Changed Type" = Table.TransformColumnTypes(Project_Progress_ID,{{"Date", type date}, {"ID", Int64.Type}, {"Project_ID", Int64.Type}, {"Project_Progress_Package_1_ID", Int64.Type}, {"Project_Progress_Package_2_ID", Int64.Type}, {"Project_Progress_Package_3_ID", Int64.Type}, {"Project_Progress_UOM_ID", Int64.Type}, {"Project_Progress_ID", Int64.Type}}),

    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type",{"Date", "ID", "Project_Progress_ID", "Project", "Project_ID", "Package_1", "Project_Progress_Package_1_ID", "Package_2", "Project_Progress_Package_2_ID", "Package_3", "Project_Progress_Package_3_ID", "UOM", "Project_Progress_UOM_ID", "Parameter", "Value"}),
    #"Sorted Rows" = Table.Sort(#"Reordered Columns",{{"ID", Order.Ascending}}),
    #"Pivoted Column" = Table.Pivot(#"Sorted Rows", List.Distinct(#"Sorted Rows"[Parameter]), "Parameter", "Value", List.Sum)
in
    #"Pivoted Column"