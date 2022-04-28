let
    Source = (Table as table, column as text) =>
    Table.SelectRows(Table, each ((Record.Field(_, column)) <> null))
in
    Source