let
    Khurja_UOM = Table.Distinct(Khurja_Progress[[Project], [Project_ID], [UOM], [Project_Progress_UOM_ID]]),
    Buxar_UOM = Table.Distinct(Buxar_Progress[[Project], [Project_ID], [UOM], [Project_Progress_UOM_ID]]),
    Ghatampur_UOM = Table.Distinct(Ghatampur_Progress[[Project], [Project_ID], [UOM], [Project_Progress_UOM_ID]]),
    Appended = Table.Combine({Khurja_UOM, Buxar_UOM, Ghatampur_UOM}),
    UOM_ID = Table.AddColumn(Appended, "UOM_ID", each if Text.Contains([UOM], "MT") then 1 else if Text.Contains([UOM], "Nos") then 2 else if Text.Contains([UOM], "RM") then 3 else if Text.Contains([UOM], "SQM") then 4 else if Text.Contains([UOM], "CUM") then 5 else null)
in
    UOM_ID