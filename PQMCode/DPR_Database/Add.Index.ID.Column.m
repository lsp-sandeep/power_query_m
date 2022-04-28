let
    Add_Index_ID_Column = (table_name as table, column_name as text, project_table_name as text) =>
        let
        OtherColumns = Table.ToList(Table.SelectRows(Table.FromList(Table.ColumnNames(table_name)), each [Column1] <> column_name and [Column1] <> "Value")),
        #"Merged Columns" = Table.CombineColumns(table_name,OtherColumns,Combiner.CombineTextByDelimiter(" |::| ", QuoteStyle.None),"Merged"),
        #"Pivoted Column" = Table.Pivot(#"Merged Columns", List.Distinct(#"Merged Columns"[Merged]), "Merged", "Value", List.Sum),
        ID_column_name = project_table_name & "_" & column_name & "_" & "ID",
        #"Added Index" = Table.AddIndexColumn(#"Pivoted Column", ID_column_name, 1, 1, Int64.Type),
        #"Changed Type1" = Table.TransformColumnTypes(#"Added Index",{{ID_column_name, type text}}),
        #"Unpivoted Other Columns" = Table.UnpivotOtherColumns(#"Changed Type1", {ID_column_name, column_name}, "Attribute", "Value"),
        #"Split Column by Delimiter1" = Table.SplitColumn(#"Unpivoted Other Columns", "Attribute", Splitter.SplitTextByDelimiter(" |::| ", QuoteStyle.Csv), OtherColumns),
        #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter1",{{ID_column_name, type text}})
        in
        #"Changed Type2"
in
    Add_Index_ID_Column