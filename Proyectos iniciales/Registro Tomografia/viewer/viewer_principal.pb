Enumeration
  #Ventana_Principal
  #Campo_Busqueda
  #Date_Inicio
  #Date_Fin
  #Boton_Busqueda
  #Boton_Limpiar
  #Boton_Hoy
  #Listado_Registros
  #Campo_Fecha
  #Campo_DNI
  #Campo_Apellido
  #Campo_Nombre
  #Campo_Sala
  #Campo_ID
  #Detalle_Diagnostico
  #Campo_Contraste
  #Campo_Solicitante
  #Campo_Tecnico
  #Detalle_Regiones
  #Detalle_Comentarios
EndEnumeration


Macro ventana_principal()
  
  OpenWindow(#PB_Any, 0, 0, 1024, 768, "Visualizacion de Registros", #PB_Window_SystemMenu)
  TextGadget(#PB_Any, 30, 28, 100, 25, "Busqueda")
  StringGadget(#Campo_Busqueda, 150, 28, 430, 25, "", #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 30, 68, 100, 25, "Fecha inicio")
  DateGadget(#Date_Inicio, 150, 68, 150, 25, "", #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 310, 68, 100, 25, "Fecha fin")
  DateGadget(#Date_Fin, 430, 68, 150, 25, "", #PB_Editor_ReadOnly)
  ButtonGadget(#Boton_Busqueda, 230, 118, 150, 32, "Buscar")
  ButtonGadget(#Boton_Limpiar, 50, 118, 150, 32, "Limpiar Filtros")
  ButtonGadget(#Boton_Hoy, 410, 118, 150, 32, "Hoy")
  ListIconGadget(#Listado_Registros, 10, 170, 610, 590, "Fecha", 120, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#Listado_Registros, 1, "Apellido y Nombre", 200)
  AddGadgetColumn(#Listado_Registros, 2, "DNI", 80)
  AddGadgetColumn(#Listado_Registros, 3, "Regiones", 200)
  AddGadgetItem(#Listado_Registros, -1, "")
  TextGadget(#PB_Any, 630, 68, 90, 25, "Fecha y hora")
  StringGadget(#Campo_Fecha, 740, 68, 180, 25, "", #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 630, 108, 90, 25, "DNI")
  StringGadget(#Campo_DNI, 734, 108, 276, 25, "", #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 630, 148, 90, 25, "Apellido")
  StringGadget(#Campo_Apellido, 734, 148, 276, 25, "", #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 630, 188, 90, 25, "Nombres")
  StringGadget(#Campo_Nombre, 734, 188, 276, 25, "", #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 630, 228, 90, 25, "Sala")
  StringGadget(#Campo_Sala, 734, 228, 276, 25, "", #PB_Editor_ReadOnly)
  StringGadget(#Campo_ID, 960, 68, 50, 25, "", #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 934, 68, 20, 25, "N°")
  TextGadget(#PB_Any, 630, 20, 600, 25, "Datos del paciente", #PB_Text_Center)
  TextGadget(#PB_Any, 630, 508, 90, 32, "Diagnostico")
  EditorGadget(#Detalle_Diagnostico, 734, 508, 276, 70, #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 630, 268, 90, 25, "Contraste")
  StringGadget(#Campo_Contraste, 734, 268, 276, 25, "", #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 630, 308, 90, 25, "Solicitante")
  StringGadget(#Campo_Solicitante, 734, 308, 276, 25, "", #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 630, 348, 90, 25, "Tecnico")
  StringGadget(#Campo_Tecnico, 734, 348, 276, 25, "", #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 630, 388, 90, 32, "Regiones")
  EditorGadget(#Detalle_Regiones, 734, 388, 276, 102, #PB_Editor_ReadOnly)
  TextGadget(#PB_Any, 630, 588, 90, 32, "Comentarios")
  EditorGadget(#Detalle_Comentarios, 734, 588, 276, 70, #PB_Editor_ReadOnly)
    
EndMacro


ventana_principal()
Repeat  
  event = WindowEvent()
  
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 17
; FirstLine = 17
; Folding = -
; EnableXP
; HideErrorLog