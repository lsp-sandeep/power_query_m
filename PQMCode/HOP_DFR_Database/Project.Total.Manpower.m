let
    Source = Project_Total_Manpower_Raw,
    #"Added Custom" = Table.AddColumn(Source, "UOM", each "Nos"),
    #"Sorted Rows1" = Table.Sort(#"Added Custom",{{"Date", Order.Ascending}, {"Project", Order.Ascending}}),
    #"Unpivoted Columns" = Table.UnpivotOtherColumns(#"Sorted Rows1", {"Date", "Project", "UOM"}, "Parameter", "Value"),
    ID = Table.AddIndexColumn(#"Unpivoted Columns", "ID", 1, 1, Int64.Type),
    #"Changed Type1" = Table.TransformColumnTypes(ID,{{"ID", type text}, {"Date", type text}}),
    UOM_ID = #"Add_Index_ID_Column"(#"Changed Type1", "Manpower", "UOM"),
    Project_ID = Table.AddColumn(UOM_ID, "Project_ID", each if [Project] = "Ghatampur" then 11010 else if [Project] = "Khurja" then 11015 else if [Project] = "Buxar" then 51007 else null),
    #"Changed Type2" = Table.TransformColumnTypes(Project_ID,{{"Project_ID", type text}}),

    Project_Manpower_ID =
    Table.AddColumn(#"Changed Type2", "Project_Total_Manpower_ID", each "1"),

    #"Changed Type" = Table.TransformColumnTypes(Project_Manpower_ID,{{"Date", type date}, {"ID", Int64.Type}, {"Project_ID", Int64.Type}, {"Project_Total_Manpower_ID", Int64.Type}}),

    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type",{"Date", "ID", "Project_Total_Manpower_ID", "Project", "Project_ID", "UOM", "Project_Manpower_UOM_ID", "Parameter", "Value"}),
    #"Sorted Rows" = Table.Sort(#"Reordered Columns",{{"ID", Order.Ascending}}),
    #"Pivoted Column" = Table.Pivot(#"Sorted Rows", List.Distinct(#"Sorted Rows"[Parameter]), "Parameter", "Value", List.Sum)
in
    #"Pivoted Column"