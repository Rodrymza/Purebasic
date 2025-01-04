UseSQLiteDatabase()
Enumeration
    #ventana_principal
    #label_busqueda
    #campo_busqueda
    #label_fecha_inicio
    #campo_fecha_inicio
    #label_fecha_fin
    #campo_fecha_fin
    #boton_busqueda
    #boton_limpiar
    #boton_hoy
    #listado_registros
    #label_fecha_hora
    #campo_fecha
    #label_dni
    #campo_dni
    #label_apellido
    #campo_apellido
    #label_nombres
    #campo_nombre
    #label_sala
    #campo_sala
    #campo_id
    #label_numero
    #titulo_datos_paciente
    #label_diagnostico
    #campo_diagnostico
    #label_contraste
    #campo_contraste
    #label_solicitante
    #campo_solicitante
    #label_tecnico
    #campo_tecnico
    #label_regiones
    #campo_regiones
    #label_comentarios
    #campo_comentarios
    #fuente_principal
  EndEnumeration
  Global dbname.s = "resources/gestion_tomografia.db", user.s = "", pass.s = ""
  LoadFont(#fuente_principal,"Segoe UI", 11)


Macro ventana_principal()
  
  OpenWindow(#ventana_principal, 0, 0, 1366, 768, "Visualizacion de Registros", #PB_Window_SystemMenu)
    SetGadgetFont(#PB_Any, FontID(#fuente_principal))
  TextGadget(#label_busqueda, 50, 28, 100, 25, "Busqueda")
  StringGadget(#campo_busqueda, 170, 28, 430, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_fecha_inicio, 50, 68, 100, 25, "Fecha inicio")
  DateGadget(#campo_fecha_inicio, 170, 68, 150, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_fecha_fin, 330, 68, 100, 25, "Fecha fin")
  DateGadget(#campo_fecha_fin, 450, 68, 150, 25, "", #PB_String_ReadOnly)
  ButtonGadget(#boton_busqueda, 250, 118, 150, 32, "Buscar")
  ButtonGadget(#boton_limpiar, 70, 118, 150, 32, "Limpiar Filtros")
  ButtonGadget(#boton_hoy, 430, 118, 150, 32, "Hoy")
  ListIconGadget(#listado_registros, 30, 160, 680, 590, "Fecha", 130, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#listado_registros, 1, "Apellido y Nombre", 220)
  AddGadgetColumn(#listado_registros, 2, "DNI", 80)
  AddGadgetColumn(#listado_registros, 3, "Regiones", 220)
  AddGadgetItem(#listado_registros, -1, "")
  TextGadget(#titulo_datos_paciente, 730, 20, 620, 25, "Datos del paciente", #PB_Text_Center)
  TextGadget(#label_fecha_hora, 830, 58, 90, 25, "Fecha y hora")
  StringGadget(#campo_fecha, 934, 58, 216, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_numero, 1164, 58, 20, 25, "N°")
  StringGadget(#campo_id, 1190, 58, 60, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_dni, 830, 108, 90, 25, "DNI")
  StringGadget(#campo_dni, 934, 108, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_apellido, 830, 158, 90, 25, "Apellido")
  StringGadget(#campo_apellido, 934, 158, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_nombres, 830, 208, 90, 25, "Nombres")
  StringGadget(#campo_nombre, 934, 208, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_sala, 830, 258, 90, 25, "Sala")
  StringGadget(#campo_sala, 934, 258, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_contraste, 830, 308, 90, 25, "Contraste")
  StringGadget(#campo_contraste, 934, 308, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_solicitante, 830, 358, 90, 25, "Solicitante")
  StringGadget(#campo_solicitante, 934, 358, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_tecnico, 830, 408, 90, 25, "Tecnico")
  StringGadget(#campo_tecnico, 934, 408, 316, 25, "", #PB_String_ReadOnly)
  TextGadget(#label_regiones, 830, 458, 90, 32, "Regiones")
  EditorGadget(#campo_regiones, 934, 458, 316, 102, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  TextGadget(#label_diagnostico, 830, 588, 90, 32, "Diagnostico")
  EditorGadget(#campo_diagnostico, 934, 588, 316, 70, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  TextGadget(#label_comentarios, 830, 678, 90, 32, "Comentarios")
  EditorGadget(#campo_comentarios, 934, 678, 316, 70, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  
EndMacro

Procedure llenar_lista_pacientes(gadget, filtro.s= "")
  If OpenDatabase(db, dbname, user, pass)
    If DatabaseQuery(db, "SELECT * FROM tabla_visualizacion" + filtro)
      index = 1
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

ventana_principal()
llenar_lista_pacientes(#listado_registros)
Repeat  
  event = WindowEvent()
  
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
          
        Case #listado_registros
          If EventType() = #PB_EventType_LeftDoubleClick
            Debug GetGadgetItemText(#listado_registros,GetGadgetState(#listado_registros),2)
          EndIf 
          
      EndSelect
  EndSelect
  
  
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 39
; FirstLine = 21
; Folding = 0
; EnableXP
; HideErrorLog