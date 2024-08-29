;Programa de tareas
Enumeration
  #ventana_principal : #lista_tareas
  #agregar_tarea : #eliminar_tarea
  #modificar_tarea : #cambiar_estado
  #string_busqueda : #buscar_tarea
  #filtro_estado : #archivo
  #panel_principal : #title_string
  #Descripcion : #description_string
  #creation_date : #expiration_date
  #priority_combo : #titulo_pestana
  #boton_guardar 
EndEnumeration

UseMySQLDatabase()


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
NewList busqueda.datos()
Global Dim prioridad.s(2) : prioridad(0)="Baja" : prioridad(1)="Media" : prioridad(2)="Alta"
Global Dim estado.s(2) : estado(0)="Pendiente" : estado(1)="En ejecucion" : estado(2)="Finalizada"

If ReadFile(#archivo,"tareas.txt")
  While Eof(#archivo)=0
    AddElement(tareas()) : tareas()\nombre=ReadString(#archivo)
  Wend  
Else 
  Debug "error"
EndIf 

Global color_alta=$6A6AFF, color_media=$8BECFF, color_baja=$94EE4E

Procedure actulizar_lista(List tareas.datos())
  ClearGadgetItems(#lista_tareas)
  ForEach tareas()
    AddGadgetItem(#lista_tareas, n, tareas()\nombre + Chr(10) + FormatDate("%dd-%mm-%yy", tareas()\fecha_creacion) + Chr(10) + estado(tareas()\estado) + Chr(10) + FormatDate("%dd-%mm-%yy", tareas()\fecha_vencimiento) + Chr(10) + prioridad(tareas()\prioridad))
    If tareas()\prioridad=0 : SetGadgetItemColor(#lista_tareas,n,#PB_Gadget_BackColor,color_baja)
    ElseIf  tareas()\prioridad=1 : SetGadgetItemColor(#lista_tareas,n,#PB_Gadget_BackColor,color_media)
    Else : SetGadgetItemColor(#lista_tareas,n,#PB_Gadget_BackColor,color_alta)
    EndIf 
    Next
  EndProcedure
  
  Procedure buscar_elemento(string.s,List lista.datos())
    ResetList(lista())
    While NextElement(lista())
      If lista()\nombre=string
        ProcedureReturn 1
      EndIf 
    Wend
    MessageRequester("Atencion","No seleccionaste ningun elemento",#PB_MessageRequester_Error)
    ProcedureReturn 0
  EndProcedure
  
  Procedure borrar_campos()
    SetGadgetText(#title_string,"")
    SetGadgetText(#title_string,"")  
    SetGadgetText(#description_string,"")  
    SetGadgetState(#creation_date,Date())  
    SetGadgetState(#priority_combo,0)
    SetGadgetState(#expiration_date,Date())  
  EndProcedure
  
  
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

AddGadgetItem(#panel_principal, -1, "Agregar/Modificar Tarea")
TextGadget(#titulo_pestana, 160, 18, 220, 25, "Nueva Tarea", #PB_Text_Center)
TextGadget(#PB_Any, 60, 118, 100, 25, "Titulo")
StringGadget(#title_string, 170, 118, 220, 25, "")
TextGadget(#Descripcion, 60, 178, 100, 25, "Descripcion")
StringGadget(#description_string, 170, 158, 220, 60, "")
TextGadget(#PB_Any, 60, 78, 100, 25, "Fecha Creacion")
DateGadget(#creation_date, 170, 78, 120, 25, "%dd-%mm-%yyyy")
TextGadget(#PB_Any, 60, 228, 100, 25, " Vencimiento")
DateGadget(#expiration_date, 170, 228, 120, 25, "%dd-%mm-%yyyy")
TextGadget(#PB_Any, 60, 268, 100, 25, " Prioridad")
ComboBoxGadget(#priority_combo, 170, 268, 130, 25)
ButtonGadget(#boton_guardar, 380, 318, 140, 42, "Guardar")
CloseGadgetList()

actulizar_lista(tareas())

For i=0 To 2
  AddGadgetItem(#filtro_estado,-1,estado(i))
  AddGadgetItem(#priority_combo,-1,prioridad(i))
Next

SetGadgetState(#filtro_estado,0)
SetGadgetState(#priority_combo,0)

Repeat 
  event=WindowEvent()
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #buscar_tarea
          If GetGadgetText(#string_busqueda)=""
            actulizar_lista(tareas())
          Else
            ForEach tareas()
              If FindString(LCase(tareas()\nombre),LCase(GetGadgetText(#string_busqueda)))
                AddElement(busqueda())
                busqueda()=tareas()
              EndIf 
            Next
            actulizar_lista(busqueda())
            ClearList(busqueda())
          EndIf 
        Case #boton_guardar
          If GetGadgetText(#description_string)<>"" And GetGadgetText(#title_string)<>""
            If GetGadgetText(#titulo_pestana)="Nueva Tarea" : AddElement(tareas()) : EndIf 
            tareas()\nombre=GetGadgetText(#title_string) : tareas()\detalle=GetGadgetText(#description_string)
            tareas()\fecha_creacion=ParseDate("%dd-%mm-%yyyy",GetGadgetText(#creation_date))
            tareas()\fecha_vencimiento=ParseDate("%dd-%mm-%yyyy",GetGadgetText(#expiration_date))
            tareas()\prioridad=GetGadgetState(#priority_combo)
            actulizar_lista(tareas())
            MessageRequester("Exito!","Tarea guardada correctamente",#PB_MessageRequester_Ok)
            SetGadgetState(#panel_principal,0)
            borrar_campos()
          Else
            MessageRequester("Error","Falta completar campos",#PB_MessageRequester_Error)
          EndIf 
        Case #eliminar_tarea
          If buscar_elemento(GetGadgetText(#lista_tareas),tareas())
            result=MessageRequester("Atencion","Desea eliminar la siguiente tarea: " + tareas()\nombre, #PB_MessageRequester_YesNo)
            If result=#PB_MessageRequester_Yes
              DeleteElement(tareas(),1)
              actulizar_lista(tareas())
            EndIf 
          EndIf 
          
        Case #modificar_tarea
          If buscar_elemento(GetGadgetText(#lista_tareas),tareas())
            SetGadgetText(#titulo_pestana, "Modificar Tarea")
            SetGadgetState(#panel_principal,1)
            SetGadgetState(#creation_date, tareas()\fecha_creacion)
            SetGadgetText(#title_string, tareas()\nombre)
            SetGadgetText(#description_string, tareas()\detalle)
            SetGadgetState(#priority_combo, tareas ()\prioridad)
            SetGadgetState(#expiration_date, tareas()\fecha_vencimiento)
          EndIf
          
        Case #agregar_tarea
          SetGadgetState(#panel_principal,1)
          borrar_campos()
        Case #cambiar_estado
          If buscar_elemento(GetGadgetText(#lista_tareas),tareas())
            If tareas()\estado<2 : tareas()\estado=tareas()\estado+1 : EndIf 
            actulizar_lista(tareas())
          EndIf   
          
      EndSelect
  EndSelect        
Until event=#PB_Event_CloseWindow


; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 128
; FirstLine = 121
; Folding = -
; EnableXP
; HideErrorLog