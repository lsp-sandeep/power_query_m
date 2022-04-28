let
    Khurja_UOM = Table.Distinct(Khurja_Manpower[[Project], [Project_ID], [UOM], [Project_Manpower_UOM_ID]])
in
    Khurja_UOM