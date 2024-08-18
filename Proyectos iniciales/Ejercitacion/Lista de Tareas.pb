Enumeration
  #ventana_principal
  #filtro
  #agregar_tarea
  #eliminar
  #lista_tareas
  #eliminar_completadas
  #guardar_tareas
  #savefile
EndEnumeration

Structure info
  descripcion.s
  marca.l
EndStructure

Global NewList tareas.info()
Global nombrefichero.s="Tareas.txt"

Procedure actualizarlista()
  ClearList(tareas())
  For i=0 To CountGadgetItems(#lista_tareas)-1
    AddElement(tareas()) 
    tareas()\descripcion=GetGadgetItemText(#lista_tareas,i)
    If GetGadgetItemState(#lista_tareas,i) & #PB_ListIcon_Checked
      tareas()\marca=1
    Else
      tareas()\marca=0
    EndIf
  Next
EndProcedure

Procedure llenarlista()
  ClearGadgetItems(#lista_tareas)
  n=0
  ForEach tareas()
    AddGadgetItem(#lista_tareas,n,tareas()\descripcion) : If tareas()\marca=1 : SetGadgetItemState(#lista_tareas,n,#PB_ListIcon_Checked) : EndIf
    n=n+1
  Next
EndProcedure

Procedure leerfichero()
  
  If OpenFile(#savefile,nombrefichero)
    While Eof(#savefile)=#False
      linea$=ReadString(#savefile)
      AddElement(tareas())
      tareas()\descripcion=StringField(linea$,1,",")
      tareas()\marca=Val(StringField(linea$,2,","))
    Wend
  EndIf
  n=0
 llenarlista()
EndProcedure

Procedure guardarArchivo()
  CreateFile(#savefile,nombrefichero)
  ForEach tareas()
    WriteStringN(#savefile,tareas()\descripcion + "," + tareas()\marca)
  Next
  CloseFile(#savefile)
EndProcedure


OpenWindow(#ventana_principal, 0, 0, 310, 430, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CreateMenu(0, WindowID(#ventana_principal))
MenuTitle("Archivo")
MenuItem(#eliminar_completadas, "Eliminar tareas completadas")
MenuItem(#guardar_tareas,"Guardar Tareas")
TextGadget(#PB_Any, 30, 10, 240, 25, "Lista de tareas", #PB_Text_Center)
ListIconGadget(#lista_tareas, 30, 80, 250, 280, "Lista de tareas", 250, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
ComboBoxGadget(#filtro, 100, 50, 180, 25)
AddGadgetItem(#filtro, -1, "Todas las tareas")
AddGadgetItem(#filtro, -1, "Tareas pendientes", 0, 1)
AddGadgetItem(#filtro, -1, "Tareas realizadas", 0, 2)
SetGadgetState(#filtro,0)
TextGadget(#PB_Any, 30, 50, 60, 25, "Filtro")
ButtonGadget(#agregar_tarea, 30, 380, 110, 25, "Agregar Tarea")
ButtonGadget(#eliminar, 160, 380, 110, 25, "Eliminar Tarea")

leerfichero()
Repeat 
  event = WindowEvent()
  Select event
    Case #PB_Event_CloseWindow
      guardarArchivo()
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #agregar_tarea
          AddGadgetItem(#lista_tareas,-1,InputRequester("Nueva tarea","Ingrese nueva tarea",""))
          actualizarlista()
          
        Case #filtro 
          Select GetGadgetState(#filtro)
            Case 0 
              llenarlista()
            Case 1
              ClearGadgetItems(#lista_tareas)
              ForEach tareas()
                If tareas()\marca=0 : AddGadgetItem(#lista_tareas,-1,tareas()\descripcion)  : EndIf 
              Next
              
            Case 2
              ClearGadgetItems(#lista_tareas)
              ForEach tareas()
                If tareas()\marca=1 : AddGadgetItem(#lista_tareas,-1,tareas()\descripcion) : SetGadgetItemState(#lista_tareas,-1,#PB_ListIcon_Checked) : EndIf 
              Next
          EndSelect
          
        Case #lista_tareas
          actualizarlista()
          
        Case #eliminar
          RemoveGadgetItem(#lista_tareas,GetGadgetState(#lista_tareas))
          actualizarlista()
      EndSelect
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case #guardar_tareas
          guardarArchivo()
          
      EndSelect
      
  EndSelect
Until event=#PB_Event_CloseWindow

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 48
; FirstLine = 3
; Folding = 1
; EnableXP
; DPIAware