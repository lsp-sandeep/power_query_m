(table) =>
 Table.SelectColumns(table, List.Select(Table.ColumnNames(table), each List.NonNullCount(Table.ToColumns(Table.SelectColumns(table, _)){0})>0))