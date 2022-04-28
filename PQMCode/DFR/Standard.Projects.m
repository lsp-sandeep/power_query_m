let
    Khurja_UOM = Table.Distinct(Khurja_Progress[[Project], [Project_ID]]),
    Buxar_UOM = Table.Distinct(Buxar_Progress[[Project], [Project_ID]]),
    Ghatampur_UOM = Table.Distinct(Ghatampur_Progress[[Project], [Project_ID]]),
    Appended = Table.Combine({Khurja_UOM, Buxar_UOM, Ghatampur_UOM})
in
    Appended