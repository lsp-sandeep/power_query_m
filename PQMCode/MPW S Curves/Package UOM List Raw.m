let
    Source = #"S Curve Data Raw",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Project", "Unit", "Package", "Parameter", "UOM"}),
    #"Inserted Merged Column" = Table.AddColumn(#"Removed Other Columns", "KEY", each Text.Combine({[Project], [Unit], [Package], [Parameter]}, " | "), type text),
    #"Reordered Columns1" = Table.ReorderColumns(#"Inserted Merged Column",{"KEY", "Project", "Unit", "Package", "Parameter", "UOM"})
in
    #"Reordered Columns1"