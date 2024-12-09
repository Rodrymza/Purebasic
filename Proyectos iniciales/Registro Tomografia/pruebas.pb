Global dbname.s = "gestion_tomografia.db" : Global user.s = "" : Global pass.s = ""
Enumeration
  #base_datos
EndEnumeration

UseSQLiteDatabase()

Procedure asignar_tabla_gagdet(nombre_tabla.s, gadget = 0, filtro.s = "", orden.s = "")
  If OpenDatabase(#base_datos, dbname, user, pass)
    DatabaseQuery(#base_datos, "SELECT * FROM " + nombre_tabla + filtro + orden)
    Debug #base_datos
    While NextDatabaseRow(#base_datos)
      For i=0 To DatabaseColumns(#base_datos) -1 
        texto_asignar.s + GetDatabaseString(#base_datos, i) + Chr(10) 
      Next
      Debug texto_asignar
      ;AddGadgetItem(gadget, -1, texto_asignar)
    Wend
    FinishDatabaseQuery(#base_datos)
  Else
    MessageRequester("Error ","No se pudo conectar a la base de datos", #PB_MessageRequester_Error)
  EndIf 
EndProcedure

asignar_tabla_gagdet("lista_pacientes")






; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 30
; Folding = -
; EnableXP
; HideErrorLog