;Programa de tareas
Enumeration
  #ventana_principal
  #lista_tareas
  #agregar_tarea
  #eliminar_tarea
  #modificar_tarea
  #cambiar_estado
  #string_busqueda
  #buscar_tarea
  #filtro_estado
  #archivo
  #panel_principal
EndEnumeration


Structure datos
  id.l
  nombre.s
  detalle.s
  fecha_creacion.i
  fecha_vencimiento.i
  estado.l
  prioridad.l
EndStructure

NewList tareas.datos()
Dim prioridad.s(2) : prioridad(0)="Baja" : prioridad(1)="Media" : prioridad(2)="Alta"
Dim estado.s(2) : estado(0)="Pendiente" : estado(1)="En ejecucion" : estado(2)="Finalizada"

If ReadFile(#archivo,"tareas.txt")
  While Eof(#archivo)=0
    AddElement(tareas()) : tareas()\nombre=ReadString(#archivo)
  Wend  
Else 
  Debug "error"
EndIf 

Global color_alta=$6A6AFF, color_media=$8BECFF, color_baja=$94EE4E


OpenWindow(#ventana_principal, 0, 0, 610, 510, "Gestion de Tareas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
PanelGadget(#panel_principal,10,10,590,500)
AddGadgetItem(#panel_principal, -1, "Panel Principal")
ListIconGadget(#lista_tareas, 10, 60, 560, 350, "Tarea", 150,#PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
AddGadgetColumn(#lista_tareas, 1, "Creacion", 100)
AddGadgetColumn(#lista_tareas, 2, "Estado", 100)
AddGadgetColumn(#lista_tareas, 3, "Vencimiento", 100)
AddGadgetColumn(#lista_tareas, 4, "Prioridad", 100)
ButtonGadget(#agregar_tarea, 30, 430, 120, 30, "Agregar Tarea")
ButtonGadget(#eliminar_tarea, 420, 430, 120, 30, "Eliminar Tarea")
ButtonGadget(#modificar_tarea, 290, 430, 120, 30, "Modificar Tarea")
ButtonGadget(#cambiar_estado, 160, 430, 120, 30, "Cambiar Estado")
StringGadget(#string_busqueda, 90, 30, 150, 25, "")
ButtonGadget(#buscar_tarea, 250, 30, 100, 25, "Buscar Tarea")
TextGadget(#PB_Any, 30, 30, 50, 25, "Buscar:")
ComboBoxGadget(#filtro_estado, 440, 30, 130, 25)
TextGadget(#PB_Any, 390, 30, 40, 25, "Filtro")
AddGadgetItem(#filtro_estado,-1,"Limpiar Filtro")
CloseGadgetList()

For i=0 To 2
  AddGadgetItem(#filtro_estado,-1,estado(i))
Next
SetGadgetState(#filtro_estado,0)
ForEach tareas()
  AddGadgetItem(#lista_tareas,n,tareas()\nombre + Chr(10) + FormatDate("%dd-%mm-%yy",Date()) + Chr(10) + estado(0))
  SetGadgetItemColor(#lista_tareas,n,#PB_Gadget_BackColor,color_media)
  n=n+1
Next

Repeat 
  event=WindowEvent()
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #buscar_tarea
          ForEach tareas()
            If FindString(tareas()\nombre,"medico")
              MessageRequester("","Encontrado")
            EndIf 
          Next
          
      EndSelect
  EndSelect        
  Until event=#PB_Event_CloseWindow


; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 67
; FirstLine = 19
; EnableXP
; HideErrorLog