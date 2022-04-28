let
    Source = Data,
    #"Filtered Rows" = Table.SelectRows(Source, each ([#"Open/#(lf)Closed"] = "Open")),
    #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows",{"Open/#(lf)Closed"}),
    #"Pivoted Column" = Table.Pivot(#"Removed Columns", List.Distinct(#"Removed Columns"[Priority]), "Priority", "TotalCount"),
    #"Replaced Value" = Table.ReplaceValue(#"Pivoted Column",null,0,Replacer.ReplaceValue,{"P1", "P2"}),
    #"Inserted Addition" = Table.AddColumn(#"Replaced Value", "Total", each [P1] + [P2], type number),
    #"Removed Columns1" = Table.RemoveColumns(#"Inserted Addition",{"P2"}),
    #"Merged Queries" = Table.NestedJoin(#"Removed Columns1", {"Project"}, Dates, {"Project"}, "Dates", JoinKind.LeftOuter),
    #"Expanded Dates" = Table.ExpandTableColumn(#"Merged Queries", "Dates", {"Date modified"}, {"Date modified"})
in
    #"Expanded Dates"