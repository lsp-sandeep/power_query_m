let
    Source = Buxar,
    #"Added Custom" = Table.AddColumn(Source, "Custom", each Table.AddIndexColumn([Data], "Index", 0, 1, Int64.Type)),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"Data"}),
    #"Expanded Custom" = Table.ExpandTableColumn(#"Removed Columns", "Custom", {"Column1", "Index"}, {"Column1", "Index"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Custom",{{"Column1", type text}}),
    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each Text.Contains([Column1], "Area wise") or Text.Contains([Column1], "Sr. no.") or Text.Contains([Column1], "Total (In Nos)")),
    #"Pivoted Column" = Table.Pivot(#"Filtered Rows", List.Distinct(#"Filtered Rows"[Column1]), "Column1", "Index", List.Sum),
    #"Renamed Columns" = Table.RenameColumns(#"Pivoted Column",{{"Area wise Erection Summary ", "Erection"}, {"Area wise other activities", "Other"}, {"Sr. no.", "Manpower"}, {"Total (In Nos)", "End"}}),
    #"Merged Columns" = Table.CombineColumns(Table.TransformColumnTypes(#"Renamed Columns", {{"Date", type text}}, "en-IN"),{"Date", "Project", "Unit"},Combiner.CombineTextByDelimiter(" | ", QuoteStyle.None),"Merged")
in
    #"Merged Columns"