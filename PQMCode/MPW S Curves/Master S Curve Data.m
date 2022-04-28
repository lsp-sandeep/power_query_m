let
    Source = Table.NestedJoin(#"Package UOM List", {"KEY"}, #"S Curve Data Raw", {"KEY"}, "S Curve Data Raw", JoinKind.LeftOuter),
    UOMListColumnNames = List.Skip(List.RemoveLastN(Table.ColumnNames(Source),1),1),
    RawColumnNames = Table.FromList(Table.ColumnNames(Table.Combine(Source[#"S Curve Data Raw"]))),
    FilteredColumnNames = Table.SelectRows(RawColumnNames, each ([Column1] <> "KEY" and [Column1] <> "Package" and [Column1] <> "Parameter" and [Column1] <> "Project" and [Column1] <> "Unit" and [Column1] <> "UOM"))[Column1],
    ColumnNames = List.FirstN(FilteredColumnNames,1) & UOMListColumnNames & List.Skip(FilteredColumnNames,1),
    #"Expanded S Curve Data Raw" = Table.ExpandTableColumn(Source, "S Curve Data Raw", FilteredColumnNames),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded S Curve Data Raw",{"KEY"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Removed Columns",ColumnNames),
    #"Changed Type" = Table.TransformColumnTypes(#"Reordered Columns",{{"AuditMonth", type date}})
in
    #"Changed Type"