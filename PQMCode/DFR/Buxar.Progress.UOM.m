let
    Buxar_UOM = Table.Distinct(Buxar_Progress[[Project], [Project_ID], [UOM], [Project_Progress_UOM_ID]])  
in
    Buxar_UOM