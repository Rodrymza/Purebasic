UseSQLiteDatabase()
Enumeration
    #ventana_principal
    #campo_busqueda
    #campo_fecha_inicio
    #campo_fecha_fin
    #boton_busqueda
    #boton_limpiar
    #boton_hoy
    #listado_registros
    #campo_fecha
    #label_dni
    #campo_dni
    #campo_apellido
    #campo_nombre
    #campo_sala
    #campo_id
    #titulo_datos_paciente
    #label_diagnostico
    #campo_diagnostico
    #campo_contraste
    #campo_solicitante
    #campo_tecnico
    #campo_regiones
    #campo_comentarios
    #fuente_principal
  EndEnumeration
  Global dbname.s = "resources/gestion_tomografia.db", user.s = "", pass.s = ""
  LoadFont(#fuente_principal,"Segoe UI", 11)


Macro ventana_principal()
  
  OpenWindow(#ventana_principal, 0, 0, 1366, 768, "Visualizacion de Registros", #PB_Window_SystemMenu)
  SetGadgetFont(#PB_Any, FontID(#fuente_principal))
  TextGadget(#PB_Any, 50, 28, 100, 25, "Busqueda")
  StringGadget(#campo_busqueda, 170, 28, 430, 25, "")
  TextGadget(#PB_Any, 50, 68, 100, 25, "Fecha inicio")
  DateGadget(#campo_fecha_inicio, 170, 68, 150, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 330, 68, 100, 25, "Fecha fin")
  DateGadget(#campo_fecha_fin, 450, 68, 150, 25, "", #PB_String_ReadOnly)
  ButtonGadget(#boton_busqueda, 250, 118, 150, 32, "Buscar")
  ButtonGadget(#boton_limpiar, 70, 118, 150, 32, "Limpiar Filtros")
  ButtonGadget(#boton_hoy, 430, 118, 150, 32, "Hoy")
  ListIconGadget(#listado_registros, 30, 160, 680, 590, "Fecha", 130, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#listado_registros, 1, "Apellido y Nombre", 220)
  AddGadgetColumn(#listado_registros, 2, "DNI", 80)
  AddGadgetColumn(#listado_registros, 3, "Regiones", 220)
  TextGadget(#titulo_datos_paciente, 730, 20, 620, 25, "Datos del paciente", #PB_Text_Center)
  TextGadget(#PB_Any, 830, 58, 90, 25, "Fecha y hora")
  StringGadget(#campo_fecha, 934, 58, 216, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 1164, 58, 20, 25, "N°")
  StringGadget(#campo_id, 1190, 58, 60, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 830, 108, 90, 25, "DNI")
  StringGadget(#campo_dni, 934, 108, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 830, 158, 90, 25, "Apellido")
  StringGadget(#campo_apellido, 934, 158, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 830, 208, 90, 25, "Nombres")
  StringGadget(#campo_nombre, 934, 208, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 830, 258, 90, 25, "Sala")
  StringGadget(#campo_sala, 934, 258, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 830, 308, 90, 25, "Contraste")
  StringGadget(#campo_contraste, 934, 308, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 830, 358, 90, 25, "Solicitante")
  StringGadget(#campo_solicitante, 934, 358, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 830, 408, 90, 25, "Tecnico")
  StringGadget(#campo_tecnico, 934, 408, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 830, 458, 90, 32, "Regiones")
  EditorGadget(#campo_regiones, 934, 458, 316, 102, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  TextGadget(#PB_Any, 830, 588, 90, 32, "Diagnostico")
  EditorGadget(#campo_diagnostico, 934, 588, 316, 70, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  TextGadget(#PB_Any, 830, 678, 90, 32, "Comentarios")
  EditorGadget(#campo_comentarios, 934, 678, 316, 70, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  
EndMacro

Procedure llenar_lista_pacientes(gadget, filtro.s= "")
  If OpenDatabase(db, dbname, user, pass)
    If DatabaseQuery(db, "SELECT * FROM tabla_visualizacion" + filtro)
      index = 0
      While NextDatabaseRow(db)
        string.s = ""
        For i=0 To 3
          string + GetDatabaseString(db, i) + Chr(10)
        Next
        AddGadgetItem(gadget, -1, string)
        If index%2 = 0
          SetGadgetItemColor(gadget, index, #PB_Gadget_BackColor, $90EE90)
        EndIf 
        index + 1 
      Wend
      FinishDatabaseQuery(db)
    Else
      MessageRequester("Error","Error en la query de la DB",#PB_MessageRequester_Error)
    EndIf 
  Else
    MessageRequester("Error","No se pudo conectar a la BD", #PB_MessageRequester_Error)
  EndIf 
  CloseDatabase(#PB_All)
EndProcedure

Procedure llenar_datos_paciente(dni.s)
  query.s = "SELECT * FROM registro_pacientes WHERE dni=" + dni
  Debug query
   If OpenDatabase(db, dbname, user, pass)
    If DatabaseQuery(db, query)
      
      While NextDatabaseRow(db)
        id.s = GetDatabaseString(db,0)
        fecha.s = GetDatabaseString(db,1)
        dni.s = GetDatabaseString(db,2)
        apellido.s = GetDatabaseString(db,3)
        nombre.s = GetDatabaseString(db,4)
        ubicacion.s = GetDatabaseString(db,5)
        region.s = ReplaceString(GetDatabaseString(db,6),", ",Chr(10))
        contraste.s = GetDatabaseString(db,7)
        solicitante.s = GetDatabaseString(db,8)
        diagnostico.s = GetDatabaseString(db,9)
        comentarios.s = GetDatabaseString(db,10)
        tecnico.s = GetDatabaseString(db,11)
                
      Wend
      
      FinishDatabaseQuery(db)
    Else
      MessageRequester("Error","Error en la query de la DB",#PB_MessageRequester_Error)
    EndIf 
  Else
    MessageRequester("Error","No se pudo conectar a la BD", #PB_MessageRequester_Error)
  EndIf 
  CloseDatabase(#PB_All) 
  
  SetGadgetText(#campo_fecha, fecha)
  SetGadgetText(#campo_id, id)
  SetGadgetText(#campo_dni, dni)
  SetGadgetText(#campo_apellido, apellido)
  SetGadgetText(#campo_nombre, nombre)
  SetGadgetText(#campo_sala, ubicacion)
  SetGadgetText(#campo_contraste, contraste)
  SetGadgetText(#campo_solicitante, solicitante)
  SetGadgetText(#campo_tecnico, tecnico)
  SetGadgetText(#campo_regiones, region)
  SetGadgetText(#campo_diagnostico, diagnostico)
  SetGadgetText(#campo_comentarios, comentarios)
  
EndProcedure


ventana_principal()
llenar_lista_pacientes(#listado_registros)
Repeat  
  event = WindowEvent()
  
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
          
        Case #listado_registros
          If EventType() = #PB_EventType_LeftDoubleClick
            dni.s=GetGadgetItemText(#listado_registros,GetGadgetState(#listado_registros),2)
            llenar_datos_paciente(dni)
          EndIf 
          
      EndSelect
  EndSelect
  
  
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 54
; FirstLine = 25
; Folding = -
; EnableXP
; HideErrorLog