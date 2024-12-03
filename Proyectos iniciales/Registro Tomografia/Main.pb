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
  #lista_contraste
  
  #campo_comentarios
  #fuente_principal
  #campo_sala
  #estudios_cabeza
  #estudios_torso
  #estudios_columna
  #boton_guardar
  #boton_limpiar
  #boton_cancelar
  #reloj
  #base_datos
EndEnumeration

LoadFont(#fuente_principal,"Segoe UI", 11)
texto_auxiliar.s = ""
UseMySQLDatabase()

Global dbname.s = "host=localhost port=3306 dbname=gestion_tomografia" : Global user.s = "rodry" : Global pass.s = "rodry1234"


user.s = "rodry" : pass.s = "rodry1234"
tabla_tecnicos.s = "tecnicos"
tabla_registros.s = "registro_pacientes"

Procedure asignar_a_gadget(combobox, List lista.s())
  
  ClearGadgetItems(combobox)
  ForEach lista()
    AddGadgetItem(combobox, -1, lista())
  Next
  
EndProcedure

Procedure leer_asignar_lista(gadget, archivo.s, ordenar = 1)
  NewList lista.s()
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
  asignar_a_gadget(gadget, lista())
EndProcedure

Procedure.s leer_estudios()
  NewList  lista_estudios.s()
  estudios.s = ""
  For i=0 To CountGadgetItems(#estudios_cabeza)-1
          
    If GetGadgetItemState(#estudios_cabeza, i)
      AddElement(lista_estudios())
      lista_estudios() = GetGadgetItemText(#estudios_cabeza, i)
    EndIf   
  Next
  
  For i=0 To CountGadgetItems(#estudios_columna)-1
          
    If GetGadgetItemState(#estudios_columna, i)
      AddElement(lista_estudios())
      lista_estudios() = GetGadgetItemText(#estudios_columna, i)
    EndIf 
  Next
  
  For i=0 To CountGadgetItems(#estudios_torso)-1
          
    If GetGadgetItemState(#estudios_torso, i)
      AddElement(lista_estudios())
      lista_estudios() = GetGadgetItemText(#estudios_torso, i)
    EndIf 
  Next
  If ListSize(lista_estudios()) = 1
    estudios = lista_estudios()
  Else
    ForEach lista_estudios()
      estudios + lista_estudios() + ", "
    Next
      estudios = Left(estudios, Len(estudios) -2)
  EndIf 
    
  ProcedureReturn estudios
EndProcedure

Procedure comprobar_region()
  
   For i=0 To CountGadgetItems(#estudios_cabeza)-1
          
     If GetGadgetItemState(#estudios_cabeza, i)
       ProcedureReturn #True 
     EndIf  
   Next
   For i=0 To CountGadgetItems(#estudios_columna)-1
          
     If GetGadgetItemState(#estudios_columna, i)
       ProcedureReturn #True 
     EndIf  
   Next
   For i=0 To CountGadgetItems(#estudios_torso)-1
          
     If GetGadgetItemState(#estudios_torso, i)
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
  For i = 0 To CountGadgetItems(#estudios_cabeza) -1
    SetGadgetItemState(#estudios_cabeza, i, 0)
  Next
    For i = 0 To CountGadgetItems(#estudios_columna) -1
    SetGadgetItemState(#estudios_columna, i, 0)
  Next
    For i = 0 To CountGadgetItems(#estudios_torso) -1
    SetGadgetItemState(#estudios_torso, i, 0)
  Next
  
EndProcedure

Procedure$ title(palabra$)  ;Formatea el texto a primera letra mayuscula
  
  i.l=2
  r$=UCase(Mid(palabra$,1,1))
  While i<= Len(palabra$)
    If Mid(palabra$,i,1)=" "
      r$=r$+ UCase(Mid(palabra$,i,2))
      i=i+2
    Else
      r$=r$+LCase(Mid(palabra$,i,1))
      i=i+1
    EndIf
  Wend
  ProcedureReturn r$
EndProcedure

Procedure.s capitalize(text.s)
  ProcedureReturn UCase(Mid(text,1,1))+LCase(Mid(text,2,Len(text)))
EndProcedure

Procedure adquirir_datos()
  
  fecha.s = FormatDate("%yyyy-%mm-%dd %hh:%mm:%ss", Date())
  tecnico.s = GetGadgetText(#lista_tecnicos)
  contraste.s = GetGadgetText(#campo_comentarios)
  dni.s = GetGadgetText(#campo_dni)
  apellido.s = title(GetGadgetText(#campo_apellido))
  nombre.s =title(GetGadgetText(#campo_nombre))
  apellido.s = title(GetGadgetText(#campo_apellido))
  ubicacion.s = GetGadgetText(#lista_ubicacion) + " " + GetGadgetText(#campo_sala)
  
  regiones.s = leer_estudios()
  
  solicitante.s = title(GetGadgetText(#campo_medico))
  diagnostico.s = capitalize(GetGadgetText(#campo_diagnostico))
  comentarios.s = capitalize(GetGadgetText(#campo_comentarios))
  
  If OpenDatabase(#base_datos, dbname, user, pass)
    
    tabla.s = "INSERT INTO registro_pacientes (fecha, dni, apellido, nombre, ubicacion, region, solicitante, diagnostico, tecnico_asignado, contraste) "
    valores.s = " VALUES ('" + fecha + "', '" + dni + "', '" + apellido + "', '" + nombre + "', '" + ubicacion + "', '" + regiones + "', '" + solicitante + "', '" + diagnostico + "', '" + tecnico + "', '" + contraste + "')"
    query.s = tabla + valores
    
    If DatabaseUpdate(#base_datos, query)  
      MessageRequester("Registro guardado", "Registro guardado en la base de datos exitosamente")
    Else 
      MessageRequester("Error", "No se pudo guardar el registro en la base de datos")
    EndIf 
  Else
    MessageRequester("Error","No se pudo establecer conexion con la base de datos", #PB_MessageRequester_Error)
  EndIf 
  
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

Procedure seleccionar_turno()
  
  turno.s = GetGadgetText(#lista_turnos)
  ClearGadgetItems(#lista_tecnicos)
  If OpenDatabase(#base_datos, dbname, user, pass)
    DatabaseQuery(#base_datos, "SELECT * FROM tecnicos where turno='" + turno + "' order by apellido")
    While NextDatabaseRow(#base_datos) 
      nombre.s = GetDatabaseString(#base_datos, 1) + ", " + GetDatabaseString(#base_datos, 2)
      AddGadgetItem(#lista_tecnicos,-1 ,nombre)
    Wend
    FinishDatabaseQuery(#base_datos)
  EndIf 
    
EndProcedure



NewList lista_turnos.s()
NewList tecnicos_manana.s()
NewList tecnicos_intermedio.s()
NewList tecnicos_tarde.s()
NewList tecnicos_noche.s()
NewList lista_estudios.s()

OpenWindow(#ventana_principal, 0, 0, 830, 730, "Registro Tomografia", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
SetGadgetFont(#PB_Any, FontID(#fuente_principal))
TextGadget(#PB_Any, 180, 20, 280, 25, "Gestion Ingreso Tomografia")

PanelGadget(#panel_principal, 10, 60, 810, 660)
AddGadgetItem(#panel_principal, -1, "Gestion de Ingreso")
TextGadget(#PB_Any, 30, 28, 130, 25, "Fecha y hora")
StringGadget(#campo_fecha, 170, 28, 230, 25, "")
DisableGadget(#campo_fecha, 1)
TextGadget(#PB_Any, 30, 68, 130, 25, "DNI")
StringGadget(#campo_dni, 170, 68, 230, 25, "", #PB_String_Numeric)
TextGadget(#PB_Any, 30, 108, 130, 25, "Apellido")
StringGadget(#campo_apellido, 170, 108, 230, 25, "")
TextGadget(#PB_Any, 30, 148, 130, 25, "Nombres")
StringGadget(#campo_nombre, 170, 148, 230, 25, "")
TextGadget(#PB_Any, 30, 188, 130, 25, "Ubicacion")
ComboBoxGadget(#lista_ubicacion, 170, 188, 230, 25)
AddGadgetItem(#lista_ubicacion, -1, "Internado")
AddGadgetItem(#lista_ubicacion, -1, "Guardia", 0, 1)
AddGadgetItem(#lista_ubicacion, -1, "Ambulatorio", 0, 2)

TextGadget(#PB_Any, 410, 28, 130, 25, "Seleciona Turno")
ComboBoxGadget(#lista_turnos, 550, 28, 230, 25)
TextGadget(#PB_Any, 410, 68, 130, 25, "Tecnico")
ComboBoxGadget(#lista_tecnicos, 550, 68, 230, 25)
TextGadget(#PB_Any, 410, 108, 130, 25, "Constraste")
ComboBoxGadget(#lista_contraste, 550, 108, 230, 25)
AddGadgetItem(#lista_contraste, -1, "Sin contraste")
AddGadgetItem(#lista_contraste, -1, "Contraste Oral", 0, 1)
AddGadgetItem(#lista_contraste, -1, "Contraste EV", 0, 2)
AddGadgetItem(#lista_contraste, -1, "Contraste Oral y EV", 0, 3)
TextGadget(#PB_Any, 410, 148, 130, 25, "Solicitante")
StringGadget(#campo_medico, 550, 148, 230, 25, "")
TextGadget(#PB_Any, 410, 188, 130, 25, "Sala")
StringGadget(#campo_sala, 550, 188, 230, 25, "")

ListIconGadget(#estudios_cabeza, 20, 248, 250, 190, "Cabeza y cuello", 240, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
ListIconGadget(#estudios_torso, 280, 248, 250, 190, "Torso", 240, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
ListIconGadget(#estudios_columna, 540, 248, 250, 190, "Columna y Extremidades", 240, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)

TextGadget(#PB_Any, 70, 458, 130, 25, "Diagnostico")
StringGadget(#campo_diagnostico, 220, 458, 510, 25, "")
TextGadget(#PB_Any, 70, 498, 130, 50, "Comentarios")
EditorGadget(#campo_comentarios, 220, 498, 510, 50)
ButtonGadget(#boton_guardar, 430, 568, 180, 50, "Guardar")
ButtonGadget(#boton_limpiar, 140, 568, 180, 50, "Limpiar")

AddGadgetItem(#panel_principal, -1, "Lista de pacientes")
CloseGadgetList()
AddWindowTimer(#ventana_principal, #reloj, 1000)

leer_asignar_lista(#lista_turnos, "lista_turnos.txt")
leer_asignar_lista(#estudios_cabeza, "estudios_cabeza.txt" )
leer_asignar_lista(#estudios_torso, "estudios_torso.txt" )
leer_asignar_lista(#estudios_columna, "estudios_columna.txt" )

Repeat 
  event = WindowEvent()
  
  If event = #PB_Event_Timer And EventTimer() = #reloj
    hora$=FormatDate("%dd-%mm-%yyyy %hh:%ii",Date())
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
            borrar_campos()
          EndIf 
          
        Case #lista_turnos
          seleccionar_turno()
          
          
      EndSelect
  EndSelect
Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 297
; FirstLine = 137
; Folding = Ay
; EnableXP
; HideErrorLog