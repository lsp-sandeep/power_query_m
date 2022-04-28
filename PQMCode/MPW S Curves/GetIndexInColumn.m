(Table as table, column as text, name as text) =>
    Table.SelectRows(Table.AddIndexColumn(Table, "Index", 0, 1, Int64.Type), each Text.Contains(Record.Field(_, column), name))[Index]