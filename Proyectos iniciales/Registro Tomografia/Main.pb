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
  #campo_fecha
  #campo_diagnostico
  #campo_medico
  
  #campo_comentarios

  #campo_sala
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
UseMySQLDatabase()

dbname.s = "host=localhost port=3306 dbname=gestion_tomografia"
user.s = "rodry" : pass.s = "rodry1234"
tabla_tecnicos.s = "tecnicos"
tabla_registros.s = "registro_pacientes"

Procedure leer_asignar_lista(List lista.s(), archivo.s, ordenar = 1)
  If ReadFile(0, archivo)
    While Not Eof(0) 
      texto.s =  ReadString(0)
      AddElement(lista()) : lista() = texto
    Wend
  Else
    MessageRequester("Error", "Error al leer el archivo" + archivo)   
  EndIf 
  If ordenar=1
    SortList(lista(), #PB_Sort_Ascending)
  EndIf 
EndProcedure

Procedure asignar_a_combobox(combobox, List lista.s())
  
  ClearGadgetItems(combobox)
  ForEach lista()
    AddGadgetItem(combobox, -1, lista())
  Next
  
EndProcedure

Procedure.s leer_estudios(gadget)
  estudios.s = ""
  For i=0 To CountGadgetItems(gadget)-1
          
    If GetGadgetItemState(gadget, i)
      estudios + GetGadgetItemText(gadget, i) + ", "
    EndIf 
  Next
  estudios = Left(estudios, Len(estudios) -2)
  ProcedureReturn estudios
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
   MessageRequester("Error", "Debes elegir al menos una region")
   ProcedureReturn #False 
EndProcedure

Procedure borrar_campos()
  For i= #campo_dni To #campo_medico
    SetGadgetText(i, "")
  Next
  For i = 0 To CountGadgetItems(#lista_estudiosuno) -1
    SetGadgetItemState(#lista_estudiosuno, i, 0)
  Next
    For i = 0 To CountGadgetItems(#lista_estudiosdos) -1
    SetGadgetItemState(#lista_estudiosdos, i, 0)
  Next
  
EndProcedure

Procedure llenar_lista_estudios()
  
  NewList estudios.s()
  leer_asignar_lista(estudios(), "lista_estudios.txt", 0)
  FirstElement(estudios())
  primera_mitad = ListSize(estudios())/2
  segunda_mitad = ListSize(estudios()) - primera_mitad
  
  For i=0 To primera_mitad -1
    AddGadgetItem(#lista_estudiosuno, -1, estudios())
    NextElement(estudios())
  Next
  For i=0 To segunda_mitad -1
    AddGadgetItem(#lista_estudiosdos, -1, estudios())
    NextElement(estudios())
  Next
  
EndProcedure

Procedure adquirir_datos()
  
  fecha.s = GetGadgetText(#campo_fecha)
  tecnico.s = GetGadgetText(#lista_tecnicos)
  id.s = GetGadgetText(#campo_dni)
  apellido.s = GetGadgetText(#campo_apellido)
  nombre.s = GetGadgetText(#campo_nombre)
  apellido.s = GetGadgetText(#campo_apellido)
  ubicacion.s = GetGadgetText(#lista_ubicacion) + " " + GetGadgetText(#campo_sala)
  
  regiones.s = leer_estudios(#lista_estudiosuno)
  regiones + ", " + leer_estudios(#lista_estudiosdos)
  
  solicitante.s = GetGadgetText(#campo_medico)
  diagnostico.s = GetGadgetText(#campo_diagnostico)
  comentarios.s = GetGadgetText(#campo_comentarios)
  
  Debug fecha
  Debug tecnico
  Debug id
  Debug apellido
  Debug nombre
  Debug ubicacion
  Debug regiones
  Debug solicitante
  Debug diagnostico
  Debug comentarios
  
  
EndProcedure

Procedure comprobar_campos_vacios()
  
  For i = #lista_tecnicos To #campo_medico
    If GetGadgetText(i) = ""
      MessageRequester("Error", "Falta completar campos obligatorios")
      ProcedureReturn #True 
    EndIf 
  Next
  
   ProcedureReturn #False 
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
DisableGadget(#campo_fecha, 1)
TextGadget(#PB_Any, 40, 68, 130, 25, "Seleciona Turno")
ComboBoxGadget(#lista_turnos, 190, 68, 220, 25)
TextGadget(#PB_Any, 40, 108, 130, 25, "Tecnico")
ComboBoxGadget(#lista_tecnicos, 190, 108, 220, 25)
TextGadget(#PB_Any, 40, 148, 130, 25, "DNI")
StringGadget(#campo_dni, 190, 148, 380, 25, "", #PB_String_Numeric)
TextGadget(#PB_Any, 40, 188, 130, 25, "Apellido")
StringGadget(#campo_apellido, 190, 188, 380, 25, "")
TextGadget(#PB_Any, 40, 228, 130, 25, "Nombres")
StringGadget(#campo_nombre, 190, 228, 380, 25, "")
TextGadget(#PB_Any, 40, 268, 130, 25, "Ubicacion")
ComboBoxGadget(#lista_ubicacion, 190, 268, 200, 25)
TextGadget(#PB_Any, 400, 268, 60, 25, "Sala")
StringGadget(#campo_sala, 470, 268, 100, 25, "")
AddGadgetItem(#lista_ubicacion, -1, "Internado")
AddGadgetItem(#lista_ubicacion, -1, "Guardia", 0, 1)
AddGadgetItem(#lista_ubicacion, -1, "Ambulatorio", 0, 2)

TextGadget(#PB_Any, 40, 308, 130, 25, "Estudios")
ListIconGadget(#lista_estudiosuno, 40, 338, 260, 190, "Region", 250, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
ListIconGadget(#lista_estudiosdos, 310, 338, 260, 190, "Region", 250, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)

TextGadget(#PB_Any, 40, 538, 130, 25, "Solicitante")
StringGadget(#campo_medico, 190, 538, 380, 25, "")
TextGadget(#PB_Any, 40, 578, 130, 25, "Diagnostico")
StringGadget(#campo_diagnostico, 190, 578, 380, 25, "")
TextGadget(#PB_Any, 40, 618, 130, 50, "Comentarios")
EditorGadget(#campo_comentarios, 190, 618, 380, 50, #PB_Editor_WordWrap)
ButtonGadget(#boton_guardar, 420, 688, 160, 40, "Guardar")
ButtonGadget(#boton_limpiar, 230, 688, 160, 40, "Limpiar")
ButtonGadget(#boton_cancelar, 40, 688, 160, 40, "Cancelar")

AddGadgetItem(#panel_principal, -1, "Lista de pacientes")
CloseGadgetList()
AddWindowTimer(#ventana_principal, #reloj, 1000)

leer_asignar_lista(lista_turnos(), "lista_turnos.txt")
leer_asignar_lista(tecnicos_manana(), "tecnicos_manana.txt")
leer_asignar_lista(lista_estudios(), "lista_estudios.txt" )
asignar_a_combobox(#lista_tecnicos, tecnicos_manana())
asignar_a_combobox(#lista_turnos, lista_turnos())
llenar_lista_estudios()

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
          If Not comprobar_campos_vacios() And comprobar_region()
            adquirir_datos()
            MessageRequester("Guardado", "Registro guardado correctamente")
          EndIf 
          
      EndSelect
  EndSelect
Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 188
; FirstLine = 61
; Folding = A9
; EnableXP
; HideErrorLog