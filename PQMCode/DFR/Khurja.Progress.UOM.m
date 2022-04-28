let
    Khurja_UOM = Table.Distinct(Khurja_Progress[[Project], [Project_ID], [UOM], [Project_Progress_UOM_ID]])
in
    Khurja_UOM