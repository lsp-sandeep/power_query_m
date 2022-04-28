let
    Ghatampur_UOM = Table.Distinct(Ghatampur_Progress[[Project], [Project_ID], [UOM], [Project_Progress_UOM_ID]])
in
    Ghatampur_UOM