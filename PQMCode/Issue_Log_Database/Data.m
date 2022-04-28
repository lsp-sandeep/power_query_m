let
    Source = Table.Combine({#"Ghatampur Data", #"Buxar Data", #"Khurja Data"}),
    #"Sorted Rows" = Table.Sort(Source,{{"Project", Order.Ascending}, {"Open/#(lf)Closed", Order.Ascending}, {"Priority", Order.Ascending}})
in
    #"Sorted Rows"