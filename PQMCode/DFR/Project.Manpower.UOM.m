let
    Khurja_UOM = Table.Distinct(Khurja_Manpower[[Project], [Project_ID], [UOM], [Project_Manpower_UOM_ID]]),
    Buxar_UOM = Table.Distinct(Buxar_Manpower[[Project], [Project_ID], [UOM], [Project_Manpower_UOM_ID]]),
    Ghatampur_UOM = Table.Distinct(Ghatampur_Manpower[[Project], [Project_ID], [UOM], [Project_Manpower_UOM_ID]]),
    #"Appended Query" = Table.Combine({Khurja_UOM, Buxar_UOM, Ghatampur_UOM}),
    UOM_ID = Table.AddColumn(#"Appended Query", "UOM_ID", each if Text.Contains([UOM], "Nos") then 1 else null),
    #"Changed Type" = Table.TransformColumnTypes(UOM_ID,{{"UOM_ID", Int64.Type}})
in
    #"Changed Type"