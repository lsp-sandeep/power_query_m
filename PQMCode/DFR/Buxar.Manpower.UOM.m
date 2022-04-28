let
    Buxar_UOM = Table.Distinct(Buxar_Manpower[[Project], [Project_ID], [UOM], [Project_Manpower_UOM_ID]])
in
    Buxar_UOM