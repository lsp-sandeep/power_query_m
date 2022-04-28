let
    Source = Table.Combine({#"Ghatampur Material Receipt Vs Issue", #"Ghatampur Critical", #"Ghatampur Civil", #"Ghatampur Erection", #"Ghatampur Manpower"}),
    ColumnNames = Table.ColumnNames(Source),
    SortedColumnNames = List.FirstN(ColumnNames,6) & SortDateList(List.Skip(ColumnNames,6)),
    #"Reordered Columns" = Table.ReorderColumns(Source,SortedColumnNames),
    #"Replaced Value1" = Table.ReplaceValue(#"Reordered Columns","Unit#1,2,3","Common",Replacer.ReplaceText,{"Unit"}),
    #"Replaced Value" = Table.ReplaceValue(#"Replaced Value1","#","-0",Replacer.ReplaceText,{"Unit"})
in
    #"Replaced Value"