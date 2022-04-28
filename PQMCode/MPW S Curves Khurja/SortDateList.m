let
    Source = (List as list) =>
    Table.TransformColumnTypes(Table.Sort(Table.TransformColumnTypes(Table.FromList(List), {{"Column1", type date}}),{{"Column1", Order.Ascending}}),{{"Column1", type text}})[Column1]
in
    Source