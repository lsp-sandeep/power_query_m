let
    Source = Table.Combine({#"Buxar Erection", #"Buxar Other Activities"}),
    #"Sorted Rows1" = Table.Sort(Source,{{"Date", Order.Ascending}, {"Project", Order.Ascending}, {"Unit", Order.Ascending}, {"Package_1", Order.Ascending}, {"Package_2", Order.Ascending}, {"UOM", Order.Ascending}}),
    ID = Table.AddIndexColumn(#"Sorted Rows1", "ID", 1, 1, Int64.Type),
    #"Changed Type1" = Table.TransformColumnTypes(ID,{{"ID", type text}, {"Date", type text}}),
    #"Unpivoted Columns" = Table.UnpivotOtherColumns(#"Changed Type1", {"Date", "Project", "Unit", "Package_1", "Package_2", "UOM", "ID"}, "Parameter", "Value"),
    UOM_ID = Add_Index_ID_Column(#"Unpivoted Columns", "Progress", "UOM"),
    Package_2_ID = Add_Index_ID_Column(UOM_ID, "Progress", "Package_2"),
    Package_1_ID = Add_Index_ID_Column(Package_2_ID, "Progress", "Package_1"),
    Unit_ID = Add_Index_ID_Column(Package_1_ID, "Progress", "Unit"),
    Project_ID = Table.AddColumn(Unit_ID, "Project_ID", each if [Project] = "Buxar" then 51007 else null),
    #"Changed Type2" = Table.TransformColumnTypes(Project_ID,{{"Project_ID", type text}}),

    Project_Progress_ID =
    let
        #"Changed Type4" = Table.TransformColumnTypes(Project_ID,{{"ID", Int64.Type}}),
        #"Sorted Rows" = Table.Sort(#"Changed Type2",{{"ID", Order.Ascending}}),
        #"Changed Type3" = Table.TransformColumnTypes(#"Sorted Rows",{{"ID", type text}}),
        Project_Progress_ID_KEY = Table.AddColumn(#"Changed Type3", "", each Text.Combine({Text.From([Project_Progress_Unit_ID], "en-IN"), Text.From([Project_Progress_Package_1_ID], "en-IN"), Text.From([Project_Progress_Package_2_ID], "en-IN"), Text.From([Project_Progress_UOM_ID], "en-IN")}, "-"), type text),
        Add_ID = Add_Index_ID_Column(Project_Progress_ID_KEY, "Progress", ""),
        #"Renamed Columns" = Table.RenameColumns(Add_ID,{{"Project_Progress__ID", "Project_Progress_ID"}}),
        #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{""})
    in 
        #"Removed Columns",

    #"Changed Type" = Table.TransformColumnTypes(Project_Progress_ID,{{"Date", type date}, {"ID", Int64.Type}, {"Project_ID", Int64.Type}, {"Project_Progress_Unit_ID", Int64.Type}, {"Project_Progress_Package_1_ID", Int64.Type}, {"Project_Progress_Package_2_ID", Int64.Type}, {"Project_Progress_UOM_ID", Int64.Type}, {"Project_Progress_ID", Int64.Type}}),

    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type",{"Date", "ID", "Project_Progress_ID", "Project", "Project_ID", "Unit", "Project_Progress_Unit_ID", "Package_1", "Project_Progress_Package_1_ID", "Package_2", "Project_Progress_Package_2_ID", "UOM", "Project_Progress_UOM_ID", "Parameter", "Value"}),
    #"Pivoted Column" = Table.Pivot(#"Reordered Columns", List.Distinct(#"Reordered Columns"[Parameter]), "Parameter", "Value", List.Sum),
    #"Sorted Rows" = Table.Sort(#"Pivoted Column",{{"ID", Order.Ascending}})
in
    #"Sorted Rows"