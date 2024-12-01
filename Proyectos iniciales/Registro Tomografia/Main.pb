;Registro pacientes de tomografia
;Rodry Ramirez (c) 2024
;rodrymza@gmail.com

Enumeration
  #archivo_turnos
  #ventana_principal
  #panel_principal
  #lista_turnos
  #lista_tecnicos
  
  #campo_dni
  #campo_apellido
  #campo_nombre
  #lista_ubicacion
  #campo_sala
  #campo_fecha
  #campo_diagnostico
  #campo_comentarios
  #campo_medico
  
  #lista_estudiosuno
  #lista_estudiosdos
  #fuente_principal
  #boton_guardar
  #boton_limpiar
  #boton_cancelar
  #reloj
EndEnumeration

LoadFont(#fuente_principal,"Segoe UI", 11)
texto_auxiliar.s = ""

Procedure leer_asignar_lista(List lista.s(), archivo.s)
  If ReadFile(0, archivo)
    While Not Eof(0) 
      texto.s =  ReadString(0)
      AddElement(lista()) : lista() = texto
    Wend
  Else
    Debug "error al leer el archivo"   
  EndIf 
  
  SortList(lista(), #PB_Sort_Ascending)

EndProcedure

Procedure asignar_a_combobox(combobox, List lista.s())
  
  ClearGadgetItems(combobox)
  ForEach lista()
    AddGadgetItem(combobox, -1, lista())
  Next
  
EndProcedure

Procedure leer_estudios(gadget)
  
  For i=0 To CountGadgetItems(gadget)-1
          
    If GetGadgetItemState(gadget, i)
      Debug GetGadgetItemText(gadget, i)
    EndIf 
  Next
EndProcedure

Procedure comprobar_region()
  
   For i=0 To CountGadgetItems(#lista_estudiosuno)-1
          
     If GetGadgetItemState(#lista_estudiosuno, i)
       ProcedureReturn #True
     EndIf  
   Next
   For i=0 To CountGadgetItems(#lista_estudiosdos)-1
          
     If GetGadgetItemState(#lista_estudiosdos, i)
       ProcedureReturn #True
     EndIf  
   Next
   ProcedureReturn #False   
EndProcedure

Procedure borrar_campos()
  For i= #campo_apellido To #campo_medico
    SetGadgetText(i, "")
  Next
EndProcedure

  
NewList lista_turnos.s()
NewList tecnicos_manana.s()
NewList tecnicos_intermedio.s()
NewList tecnicos_tarde.s()
NewList tecnicos_noche.s()
NewList lista_estudios.s()

OpenWindow(#ventana_principal, 0, 0, 660, 860, "Registro Tomografia", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
SetGadgetFont(#PB_Any, FontID(#fuente_principal))
TextGadget(#PB_Any, 180, 20, 280, 25, "Gestion Ingreso Tomografia")
PanelGadget(#panel_principal, 10, 60, 630, 780)
AddGadgetItem(#panel_principal, -1, "Gestion de Ingreso")
TextGadget(#PB_Any, 40, 28, 130, 25, "Fecha y hora")
StringGadget(#campo_fecha, 190, 28, 210, 25, "")
TextGadget(#PB_Any, 40, 68, 130, 25, "Seleciona Turno")
ComboBoxGadget(#lista_turnos, 190, 68, 220, 25)
TextGadget(#PB_Any, 40, 108, 130, 25, "Tecnico")
ComboBoxGadget(#lista_tecnicos, 190, 108, 220, 25)
TextGadget(#PB_Any, 40, 148, 130, 25, "DNI")
StringGadget(#campo_dni, 190, 148, 380, 25, "")
TextGadget(#PB_Any, 40, 188, 130, 25, "Apellido")
StringGadget(#campo_apellido, 190, 188, 380, 25, "")
TextGadget(#PB_Any, 40, 268, 130, 25, "Ubicacion")
ComboBoxGadget(#lista_ubicacion, 190, 268, 200, 25)
AddGadgetItem(#lista_ubicacion, -1, "Internado")
AddGadgetItem(#lista_ubicacion, -1, "Guardia", 0, 1)
AddGadgetItem(#lista_ubicacion, -1, "Ambulatorio", 0, 2)
TextGadget(#PB_Any, 40, 578, 130, 25, "Diagnostico")
StringGadget(#campo_diagnostico, 190, 578, 380, 25, "")

TextGadget(#PB_Any, 40, 308, 130, 25, "Estudios")
ListIconGadget(#lista_estudiosuno, 40, 338, 260, 190, "Region", 250, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
AddGadgetItem(#lista_estudiosuno, -1, "Cerebro")
AddGadgetItem(#lista_estudiosuno, -1, "Cervical")
AddGadgetItem(#lista_estudiosuno, -1, "Torax")
AddGadgetItem(#lista_estudiosuno, -1, "Abdomen")
ListIconGadget(#lista_estudiosdos, 310, 338, 260, 190, "Region", 250, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
AddGadgetItem(#lista_estudiosdos, -1, "Pelvis")
AddGadgetItem(#lista_estudiosdos, -1, "Miembro superior")
AddGadgetItem(#lista_estudiosdos, -1, "Miembro inferior")
AddGadgetItem(#lista_estudiosdos, -1, "Puncion")
AddGadgetItem(#lista_estudiosdos, -1, "Cuello")

TextGadget(#PB_Any, 40, 618, 130, 50, "Comentarios")
EditorGadget(#campo_comentarios, 190, 618, 380, 50)
ButtonGadget(#boton_guardar, 420, 688, 160, 40, "Guardar")
ButtonGadget(#boton_limpiar, 230, 688, 160, 40, "Limpiar")
ButtonGadget(#boton_cancelar, 40, 688, 160, 40, "Cancelar")

DisableGadget(#campo_fecha, 1)
TextGadget(#PB_Any, 40, 538, 130, 25, "Solicitante")
StringGadget(#campo_medico, 190, 538, 380, 25, "")
StringGadget(#campo_sala, 470, 268, 100, 25, "")
TextGadget(#PB_Any, 400, 268, 60, 25, "Sala")
TextGadget(#PB_Any, 40, 228, 130, 25, "Nombres")
StringGadget(#campo_nombre, 190, 228, 380, 25, "")
AddGadgetItem(#panel_principal, -1, "Lista de pacientes")
CloseGadgetList()
AddWindowTimer(#ventana_principal, #reloj, 1000)

leer_asignar_lista(lista_turnos(), "lista_turnos.txt")
leer_asignar_lista(tecnicos_manana(), "tecnicos_manana.txt")
leer_asignar_lista(lista_estudios(), "lista_estudios.txt" )
asignar_a_combobox(#lista_tecnicos, tecnicos_manana())
asignar_a_combobox(#lista_turnos, lista_turnos())

Repeat 
  event = WindowEvent()
  
  If event = #PB_Event_Timer And EventTimer() = #reloj
    hora$=FormatDate("%dd/%mm/%yyyy - %hh:%ii",Date())
    SetGadgetText(#campo_fecha,hora$)
  EndIf  
  
  Select event 
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #lista_ubicacion
          If GetGadgetState(#lista_ubicacion) = 0
            DisableGadget(#campo_sala, 0)
            SetGadgetText(#campo_sala, texto_auxiliar)
          Else 
            DisableGadget(#campo_sala, 1)
            texto_auxiliar.s = GetGadgetText(#campo_sala)
            SetGadgetText(#campo_sala, "")
          EndIf
          
        Case #boton_guardar
          If comprobar_region()
          leer_estudios(#lista_estudiosdos)
          leer_estudios(#lista_estudiosuno)
          borrar_campos()
        Else 
          MessageRequester("Error","Debe seleccionar al menos una region", #PB_MessageRequester_Error)
        EndIf 
        
          
      EndSelect
  EndSelect
Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 181
; FirstLine = 102
; Folding = w
; EnableXP
; HideErrorLog