Global dbname.s = "gestion_tomografia.db" : Global user.s = "" : Global pass.s = ""
Enumeration
  #base_datos
EndEnumeration

UseSQLiteDatabase()

Procedure asignar_tabla_gagdet(nombre_tabla.s, gadget = 0, seleccion.s = "*", filtro.s = " ", orden.s = " ", columna = 0)
  If OpenDatabase(#base_datos, dbname, user, pass)
    DatabaseQuery(#base_datos, "SELECT " + seleccion + " FROM " + nombre_tabla + " " +  filtro + " " + orden)
    ;Debug "SELECT " + seleccion + " FROM " + nombre_tabla + " " +  filtro + " " + orden
    While NextDatabaseRow(#base_datos)
      texto_asignar = GetDatabaseString(#base_datos, 0)
      AddGadgetItem(gadget, -1, texto_asignar)
    Wend
    FinishDatabaseQuery(#base_datos)
  Else
    MessageRequester("Error ","No se pudo conectar a la base de datos", #PB_MessageRequester_Error)
  EndIf 
EndProcedure

asignar_tabla_gagdet("registro_pacientes", 0, "nombre || ' ' || apellido", "where nombre like 'r%'","order by nombre" )






; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 27
; Folding = -
; EnableXP
; HideErrorLog