﻿let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45W8ssvVtJRMlSKjQUA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [UOM = _t, UOM_ID = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"UOM", type text}, {"UOM_ID", Int64.Type}})
in
    #"Changed Type"