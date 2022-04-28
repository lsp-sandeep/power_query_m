let
    Ghatampur_UOM = Table.Distinct(Ghatampur_Manpower[[Project], [Project_ID], [UOM], [Project_Manpower_UOM_ID]])
in
    Ghatampur_UOM