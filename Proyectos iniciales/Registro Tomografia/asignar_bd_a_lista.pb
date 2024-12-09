UseSQLiteDatabase()
Global dbname.s = "gestion_tomografia.db" : Global user.s = "" : Global pass.s = ""
Enumeration
#base_datos
EndEnumeration

Procedure asignar_bd_a_gadget(tablename.s, columna,filtro.s = "" , orden.s = "", seleccion.s = "*")
If OpenDatabase(#base_datos, dbname, user, pass)
  DatabaseQuery(#base_datos, "SELECT " + seleccion + " FROM " + tablename + filtro + orden)
  ClearGadgetItems(gadget)
  Debug "SELECT " + seleccion + " FROM " + tablename + filtro + orden
  While NextDatabaseRow(#base_datos)
    texto.s = GetDatabaseString(#base_datos, columna)
    Debug texto
    AddGadgetItem(gadget, -1, texto)
    Wend  
EndIf 

EndProcedure

asignar_bd_a_gadget("registro_pacientes", 0, " where apellido = 'Ramirez'" , " order by apellido asc", "apellido")


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 6
; Folding = -
; EnableXP
; HideErrorLog