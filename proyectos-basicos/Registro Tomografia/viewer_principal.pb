UseSQLiteDatabase()
  
Enumeration
  #ventana_principal : #cambiar_path_bd : #campo_busqueda :  #campo_fecha_inicio
  #campo_fecha_fin : #boton_busqueda :  #boton_limpiar :  #boton_hoy
  #listado_registros :  #campo_fecha : #label_dni :  #campo_dni : #exportar_csv
  #campo_apellido :  #campo_nombre : #campo_sala :  #campo_id : #menu_actualizar
  #titulo_datos_paciente :  #campo_diagnostico :  #campo_contraste :  #campo_solicitante
  #campo_tecnico :  #campo_regiones : #campo_comentarios :  #fuente_principal : #tecla_intro
EndEnumeration

Global dbname.s = "", user.s = "", pass.s = "", archivo_ini.s = "resources/configuration.ini"
LoadFont(#fuente_principal,"Segoe UI", 11)

Procedure exportar_csv(query.s = "SELECT * FROM registro_pacientes ORDER BY fecha desc")
  
  If OpenDatabase(basedatos, "resources/gestion_tomografia.db", "", "")
    
    If DatabaseQuery(basedatos, query)
      linea.s = "ID;Fecha;DNI;Apellido;Nombre;Ubicacion;Regiones;Contraste;Solicitante;Diagnostico;Comentarios;Tecnico" + Chr(10)
      While NextDatabaseRow(basedatos)
        For i = 0 To 11
          linea + GetDatabaseString(basedatos, i) + ";"
        Next
        linea + Chr(10)
      Wend
      path.s = SaveFileRequester("Seleccione ubicacion del archivo", "base_datos.csv", "CSV file (*.csv)",0)
      If path 
        If GetExtensionPart(path) <> "csv"
          path + ".csv"
        EndIf 
        
        CreateFile(archivo, path)
        WriteString(archivo, linea)
        CloseFile(archivo)
        MessageRequester("Exportacion exitosa", "Archivo exportado satisfactoriamente en: " + path)
      Else
        MessageRequester("Cancelado","Exportacion cancelada")
      EndIf 
      
    Else
      MessageRequester("Error en la query", DatabaseError(), #PB_MessageRequester_Error)
    EndIf 
    CloseDatabase(basedatos)
  Else
    MessageRequester("Error", "Error al conectarse a la base de datos: " + DatabaseError(), #PB_MessageRequester_Error)
  EndIf 
  
EndProcedure

Procedure date_requester()
  
  window_date = OpenWindow(#PB_Any, 0, 0, 300, 200, "Selecciona fecha", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  fecha_inicio = DateGadget(#PB_Any, 120, 40, 150, 25, "")
  TextGadget(#PB_Any, 10, 40, 100, 25, "Fecha Inicio")
  fecha_fin = DateGadget(#PB_Any, 120, 90, 150, 25, "")
  TextGadget(#PB_Any, 10, 90, 100, 25, "Fecha Inicio")
  boton_aceptar = ButtonGadget(#PB_Any, 90, 150, 120, 35, "Aceptar")
  
  Repeat
    event = WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(window_date)
      Case #PB_Event_Gadget
        Select EventGadget()
            
          Case boton_aceptar
            text_inicio.s = FormatDate("%yyyy-%mm-%dd",GetGadgetState(fecha_inicio)) + " 00:00"
            text_fin.s = FormatDate("%yyyy-%mm-%dd",GetGadgetState(fecha_fin)) + " 23:59"
            query.s = "SELECT * FROM registro_pacientes where fecha between '" + text_inicio + "' AND '" + text_fin + "' order by fecha desc"
            exportar_csv(query)
            
        EndSelect
        
    EndSelect
    
  Until event = #PB_Event_CloseWindow 
  
EndProcedure
  
Procedure leer_path_database()
  
  If OpenPreferences(archivo_ini)
    dbname=ReadPreferenceString("database_path", "error")
    If OpenDatabase(0, dbname, user, pass)
      MessageRequester("Atencion", "Se conecto correctamente a la base de datos")
      CloseDatabase(0)
    Else
      MessageRequester("Error", "Error al conectarse a la base de datos")
    EndIf 
  Else
    MessageRequester("Error","Error al leer el archivo de configuracion", #PB_MessageRequester_Error)
  EndIf 
  
EndProcedure

Macro ventana_principal()
  
  OpenWindow(#ventana_principal, 0, 0, 1366, 780, "Visualizacion de Registros", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  SetGadgetFont(#PB_Any, FontID(#fuente_principal))
  CreateMenu(#PB_Any, WindowID(#ventana_principal))
  MenuTitle("Archivo")
  MenuItem(#menu_actualizar, "Actualizar")
  MenuItem(#cambiar_path_bd, "Path base de datos")
  MenuItem(#exportar_csv, "Exportar csv")
  TextGadget(#PB_Any, 50, 28, 100, 25, "Busqueda")
  StringGadget(#campo_busqueda, 170, 28, 430, 25, "")
  TextGadget(#PB_Any, 50, 68, 100, 25, "Fecha inicio")
  DateGadget(#campo_fecha_inicio, 170, 68, 150, 25, "")
  SetGadgetState(#campo_fecha_inicio, Date(2025,01,01,00,00,00))
  TextGadget(#PB_Any, 330, 68, 100, 25, "Fecha fin")
  DateGadget(#campo_fecha_fin, 450, 68, 150, 25)
  SetGadgetState(#campo_fecha_fin, Date())
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
  SetGadgetColor(#campo_fecha, #PB_Gadget_BackColor, $D4FF7F)
  TextGadget(#PB_Any, 1164, 58, 20, 25, "N°")
  StringGadget(#campo_id, 1190, 58, 60, 25, "", #PB_String_ReadOnly)
  SetGadgetColor(#campo_id, #PB_Gadget_BackColor, $FAFAFF)
  TextGadget(#PB_Any, 830, 108, 90, 25, "DNI")
  StringGadget(#campo_dni, 934, 108, 316, 25, "", #PB_String_ReadOnly)
  SetGadgetColor(#campo_dni, #PB_Gadget_BackColor, $D4FF7F)
  TextGadget(#PB_Any, 830, 158, 90, 25, "Apellido")
  StringGadget(#campo_apellido, 934, 158, 316, 25, "", #PB_String_ReadOnly | #PB_String_UpperCase)
  SetGadgetColor(#campo_apellido, #PB_Gadget_BackColor, $D4FF7F)
  TextGadget(#PB_Any, 830, 208, 90, 25, "Nombres")
  StringGadget(#campo_nombre, 934, 208, 316, 25, "", #PB_String_ReadOnly)
  SetGadgetColor(#campo_nombre, #PB_Gadget_BackColor, $FAFAFF)
  TextGadget(#PB_Any, 830, 258, 90, 25, "Sala")
  StringGadget(#campo_sala, 934, 258, 316, 25, "", #PB_String_ReadOnly)
  SetGadgetColor(#campo_sala, #PB_Gadget_BackColor, $FAFAFF)
  TextGadget(#PB_Any, 830, 308, 90, 25, "Contraste")
  StringGadget(#campo_contraste, 934, 308, 316, 25, "", #PB_String_ReadOnly)
  SetGadgetColor(#campo_contraste, #PB_Gadget_BackColor, $FAFAFF)
  TextGadget(#PB_Any, 830, 358, 90, 25, "Solicitante")
  StringGadget(#campo_solicitante, 934, 358, 316, 25, "", #PB_String_ReadOnly)
  SetGadgetColor(#campo_solicitante, #PB_Gadget_BackColor, $FAFAFF)
  TextGadget(#PB_Any, 830, 408, 90, 25, "Tecnico")
  StringGadget(#campo_tecnico, 934, 408, 316, 25, "", #PB_String_ReadOnly)
  SetGadgetColor(#campo_tecnico, #PB_Gadget_BackColor, $FAFAFF)
  TextGadget(#PB_Any, 830, 458, 90, 32, "Regiones")
  EditorGadget(#campo_regiones, 934, 458, 316, 102, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  TextGadget(#PB_Any, 830, 588, 90, 32, "Diagnostico")
  EditorGadget(#campo_diagnostico, 934, 588, 316, 70, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  TextGadget(#PB_Any, 830, 678, 90, 32, "Comentarios")
  EditorGadget(#campo_comentarios, 934, 678, 316, 70, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  AddKeyboardShortcut(#ventana_principal, #PB_Shortcut_Return, #tecla_intro)
  
EndMacro

Procedure llenar_lista_pacientes(gadget, query.s= "Select * FROM tabla_visualizacion order by fecha desc LIMIT 80")
  ClearGadgetItems(gadget)
  If OpenDatabase(db, dbname, user, pass)
    If DatabaseQuery(db, query)
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

Procedure cambiar_path_database()
  
  If OpenPreferences(archivo_ini)
    nuevo_path.s = OpenFileRequester("Selecciona archivo de base de datos","", "Base de datos (*.db) | *.db", 0)
    WritePreferenceString("database_path", nuevo_path)
    path.s = ReadPreferenceString("database_path", "error")
    If path.s <> "error"
      MessageRequester("Atecion", "Se cambio el path de la base de datos a " + path)
      dbname = path
    EndIf 
    ClosePreferences()
  EndIf
  
EndProcedure

Procedure busqueda()
  busqueda.s = GetGadgetText(#campo_busqueda)
  fecha_inicio.s = FormatDate("%yyyy-%mm-%dd", GetGadgetState(#campo_fecha_inicio))
  fecha_fin.s = FormatDate("%yyyy-%mm-%dd", GetGadgetState(#campo_fecha_fin))
  
  query.s = "SELECT * FROM tabla_visualizacion" +
            " WHERE (nombre like '%" + busqueda + "%' or " +
            "nombre like '%" + busqueda + "%' or " +
            "dni like '%" + busqueda + "%') and" +
            " (fecha between '" + fecha_inicio + " 00:00' And '" + fecha_fin + " 23:59') order by fecha desc"
  
  llenar_lista_pacientes(#listado_registros, query)
EndProcedure

ventana_principal()
leer_path_database()
llenar_lista_pacientes(#listado_registros)

Repeat  
  event = WindowEvent()
  
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
          
        Case #listado_registros
          ;If EventType() = #PB_EventType_LeftDoubleClick
            dni.s=GetGadgetItemText(#listado_registros,GetGadgetState(#listado_registros),2)
            llenar_datos_paciente(dni)
          ;EndIf 
          
          Case #boton_busqueda
            busqueda()
            
        Case #boton_limpiar
          SetGadgetState(#campo_fecha_inicio, Date())
          SetGadgetState(#campo_fecha_inicio, Date(2025,01,01,00,00,00))
          SetGadgetText(#campo_busqueda, "")
          llenar_lista_pacientes(#listado_registros)
          
        Case #boton_hoy
          SetGadgetState(#campo_fecha_inicio, Date())
          SetGadgetState(#campo_fecha_fin, Date())
          query.s = "SELECT * FROM tabla_visualizacion " +
                    "WHERE fecha BETWEEN '" + fecha_inicio + " 00:00' And '" + fecha_fin + " 23:59' order by fecha desc"
          llenar_lista_pacientes(#listado_registros, query)
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #cambiar_path_bd
          cambiar_path_database()
          
        Case #tecla_intro
          busqueda()
          
        Case #menu_actualizar
          busqueda()
          
        Case #exportar_csv
          date_requester()
          
      EndSelect
      
  EndSelect
  
  
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 99
; FirstLine = 12
; Folding = I+
; EnableXP
; HideErrorLog