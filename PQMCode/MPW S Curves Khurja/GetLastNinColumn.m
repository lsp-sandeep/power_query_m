let
    Source = (Table as table, column as text, name as text) =>
    try (Table.RowCount(Table) - GetIndexInColumn(Table, column, name){0}) otherwise 0
in
    Source