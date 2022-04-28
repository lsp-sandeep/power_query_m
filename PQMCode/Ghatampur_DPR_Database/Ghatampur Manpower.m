let
    Source = #"Ghatampur Manpower Raw",
    #"Added Custom" = Table.AddColumn(Source, "UOM", each "Nos"),
    #"Sorted Rows1" = Table.Sort(#"Added Custom",{{"Date", Order.Ascending}, {"Project", Order.Ascending}, {"Package_1", Order.Ascending}}),
    ID = Table.AddIndexColumn(#"Sorted Rows1", "ID", 1, 1, Int64.Type),
    #"Changed Type1" = Table.TransformColumnTypes(ID,{{"ID", type text}, {"Date", type text}}),
    UOM_ID = Add_Index_ID_Column(#"Changed Type1", "Manpower", "UOM"),
    Package_1_ID = Add_Index_ID_Column(UOM_ID, "Manpower", "Package_1"),
    Project_ID = Table.AddColumn(Package_1_ID, "Project_ID", each if [Project] = "Ghatampur" then 11010 else null),
    #"Changed Type2" = Table.TransformColumnTypes(Project_ID,{{"Project_ID", type text}}),

    Project_Manpower_ID =
    let
        #"Changed Type4" = Table.TransformColumnTypes(Project_ID,{{"ID", Int64.Type}}),
        #"Sorted Rows" = Table.Sort(#"Changed Type2",{{"ID", Order.Ascending}}),
        #"Changed Type3" = Table.TransformColumnTypes(#"Sorted Rows",{{"ID", type text}}),
        Project_Manpower_ID_KEY = Table.AddColumn(#"Changed Type3", "", each Text.Combine({Text.From([Project_Manpower_Package_1_ID], "en-IN"), Text.From([Project_Manpower_UOM_ID], "en-IN")}, "-"), type text),
        Add_ID = Add_Index_ID_Column(Project_Manpower_ID_KEY, "Manpower", ""),
        #"Renamed Columns" = Table.RenameColumns(Add_ID,{{"Project_Manpower__ID", "Project_Manpower_ID"}}),
        #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{""})
    in 
        #"Removed Columns",

    #"Changed Type" = Table.TransformColumnTypes(Project_Manpower_ID,{{"Date", type date}, {"ID", Int64.Type}, {"Project_ID", Int64.Type}, {"Project_Manpower_ID", Int64.Type}, {"Project_Manpower_Package_1_ID", Int64.Type}, {"Project_Manpower_UOM_ID", Int64.Type}}),

    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type",{"Date", "ID", "Project_Manpower_ID", "Project", "Project_ID", "Package_1", "Project_Manpower_Package_1_ID", "UOM", "Project_Manpower_UOM_ID", "Parameter", "Value"}),
    #"Sorted Rows" = Table.Sort(#"Reordered Columns",{{"ID", Order.Ascending}}),
    #"Pivoted Column" = Table.Pivot(#"Sorted Rows", List.Distinct(#"Sorted Rows"[Parameter]), "Parameter", "Value", List.Sum)
in
    #"Pivoted Column"