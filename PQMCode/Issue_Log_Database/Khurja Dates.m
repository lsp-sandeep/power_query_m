let
    Source = #"Khurja Source",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Project_ID", "Project", "Date created", "Date modified", "Date on file"})
in
    #"Removed Other Columns"