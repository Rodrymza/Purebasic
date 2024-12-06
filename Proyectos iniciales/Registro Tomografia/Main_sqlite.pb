;Registro pacientes de tomografia
;Rodry Ramirez (c) 2024
;rodrymza@gmail.com

Enumeration
  #archivo_turnos : #ventana_principal
  #panel_principal : #lista_turnos
  
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
  
  #listado_pacientes
  #campo_busqueda
  #date_inicio
  #date_fin
  #boton_fecha
  #boton_busqueda
  #boton_fecha_hoy
  #filtro_tecnico
  #boton_limpiar_filtro
  
  #detalle_tecnico : #detalle_fecha : #detalle_apellido
  #detalle_nombre : #detalle_ubicacion
  #detalle_solicitante : #detalle_diagnostico : #detalle_dni
  #detalle_estudios : #detalle_contraste : #barra_estado
  
EndEnumeration

LoadFont(#fuente_principal,"Segoe UI", 11)
texto_auxiliar.s = ""

UseSQLiteDatabase()

Global dbname.s = "gestion_tomografia.db" : Global user.s = "" : Global pass.s = ""


user.s = "rodry" : pass.s = "rodry1234"
tabla_tecnicos.s = "tecnicos"
tabla_registros.s = "registro_pacientes"

Procedure barra_total_estudios()
  OpenDatabase(#base_datos, dbname, user, pass)
  DatabaseQuery(#base_datos, "SELECT count(*) FROM gestion_tomografia.registro_pacientes where date(fecha) = curdate();")
  While NextDatabaseRow(#base_datos)
    total = GetDatabaseLong(#base_datos, 0)
  Wend  
  FinishDatabaseQuery(#base_datos)
  StatusBarText(#barra_estado, 1, "Total estudios de hoy: " + total)
  DatabaseQuery(#base_datos, "SELECT count(*) FROM gestion_tomografia.registro_pacientes where year(fecha) = year(curdate());")
  While NextDatabaseRow(#base_datos)
    total = GetDatabaseLong(#base_datos, 0)
  Wend  
  FinishDatabaseQuery(#base_datos)
    StatusBarText(#barra_estado, 2, "Total estudios del año: " + total)

EndProcedure

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
  
  fecha.s = FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss", Date())
  tecnico.s = GetGadgetText(#lista_tecnicos)
  contraste.s = GetGadgetText(#lista_contraste)
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

Procedure actualizar_lista_pacientes(filtro.s = "")
  
  If OpenDatabase(#base_datos, dbname, user, pass)
    ClearGadgetItems(#listado_pacientes)
    query.s = "SELECT * FROM registro_pacientes" + filtro + " order by fecha desc"
    i = 0
    If DatabaseQuery(#base_datos, query)
      While NextDatabaseRow(#base_datos)
        nro.s = Str(GetDatabaseLong(#base_datos,0))
        fecha.s = Left(GetDatabaseString(#base_datos, 1), 16)
        nombre.s = GetDatabaseString(#base_datos, 3) + ", " + StringField(GetDatabaseString(#base_datos, 4), 1, " ")
        dni.s = GetDatabaseString(#base_datos, 2)
        estudios.s = GetDatabaseString(#base_datos, 6)
        tecnico.s = StringField(GetDatabaseString(#base_datos, 11), 1, ",")
        diagnostico.s = GetDatabaseString(#base_datos, 9)
        
        AddGadgetItem(#listado_pacientes, -1, nro + Chr(10) + fecha + Chr(10) + nombre + Chr(10) + dni + Chr(10) + estudios + Chr(10) + diagnostico + Chr(10) + tecnico)
        If i%2 = 0
          SetGadgetItemColor(#listado_pacientes, i, #PB_Gadget_BackColor, $AACD66)          
        EndIf 
        i + 1
      Wend 
      FinishDatabaseQuery(#base_datos)
    EndIf
  EndIf 
EndProcedure

Procedure llenar_filtro_tecnicos()
  
  If OpenDatabase(#base_datos, dbname, user, pass)
    If DatabaseQuery(#base_datos, "SELECT * FROM tecnicos order by apellido")
      While NextDatabaseRow(#base_datos)
        tecnico.s = GetDatabaseString(#base_datos, 1) + ", " + GetDatabaseString(#base_datos, 2)
        AddGadgetItem(#filtro_tecnico, -1, tecnico)
      Wend  
      FinishDatabaseQuery(#base_datos)
    EndIf 
  EndIf
  
  
EndProcedure

Procedure filtrar_fecha(fecha_inicio, fecha_fin )
  inicio.s = FormatDate("%yyyy-%mm-%dd" , fecha_inicio)
  fin.s = FormatDate("%yyyy-%mm-%dd" , fecha_fin)
  query.s = " where fecha between '" + inicio + " 00:00' and '" + fin + " 23:59'"
  actualizar_lista_pacientes(query)
  
EndProcedure

Procedure busqueda()
  busqueda.s = GetGadgetText(#campo_busqueda)
  filtro.s = ""
  If busqueda<>""
    filtro = " where nombre like '%" + busqueda + "%' or apellido like '%" + busqueda + "%' or dni like '%" +busqueda + "%'"
  EndIf 
  actualizar_lista_pacientes(filtro)
EndProcedure

Procedure ver_detalle_paciente()

  id_paciente.s = GetGadgetText(#listado_pacientes)
  If OpenDatabase(#base_datos, dbname, user, pass)
    If DatabaseQuery(#base_datos, "SELECT * FROM registro_pacientes where id_registro = '" + id_paciente + "'")
      While NextDatabaseRow(#base_datos)
        fecha.s = GetDatabaseString(#base_datos, 1)
        dni.s = GetDatabaseString(#base_datos, 2)
        apellido.s = GetDatabaseString(#base_datos, 3)
        nombre.s = GetDatabaseString(#base_datos, 4)
        ubicacion.s = GetDatabaseString(#base_datos, 5)
        estudios.s = GetDatabaseString(#base_datos, 6)
        contraste.s = GetDatabaseString(#base_datos, 7)
        solicitante.s = GetDatabaseString(#base_datos, 8)
        diagnostico.s = GetDatabaseString(#base_datos, 9)
        tecnico.s = GetDatabaseString(#base_datos, 11)
      Wend  
      
    EndIf 
  EndIf
  SetGadgetText(#detalle_fecha, fecha)
  SetGadgetText(#detalle_dni, dni)
  SetGadgetText(#detalle_apellido, apellido)
  SetGadgetText(#detalle_nombre, nombre)
  SetGadgetText(#detalle_ubicacion, ubicacion)
  SetGadgetText(#detalle_diagnostico, diagnostico)
  SetGadgetText(#detalle_tecnico, tecnico)
  SetGadgetText(#detalle_solicitante, solicitante)
  
  For i = 0 To 3
    If GetGadgetItemText(#detalle_contraste,i) = contraste
      SetGadgetState(#detalle_contraste, i)
    EndIf  
  Next
  
  ClearGadgetItems(#detalle_estudios)
  total = CountString(estudios, ",")
  For i=1 To total+1
    AddGadgetItem(#detalle_estudios, -1, StringField(estudios, i,", "))
  Next
  
  SetGadgetState(#panel_principal, 2)
  
  
EndProcedure

Procedure desactivar_detalles(desactivar = 1)
  
  DisableGadget(#detalle_apellido, desactivar)
  DisableGadget(#detalle_nombre, desactivar)
  DisableGadget(#detalle_dni, desactivar)
  DisableGadget(#detalle_diagnostico, desactivar)
  DisableGadget(#detalle_solicitante, desactivar)
  DisableGadget(#detalle_tecnico, desactivar)
  DisableGadget(#detalle_ubicacion, desactivar)
  
EndProcedure

Procedure ventana_principal()
  
  OpenWindow(#ventana_principal, 0, 0, 1010, 780, "Registro Tomografia", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  SetGadgetFont(#PB_Any, FontID(#fuente_principal))
  TextGadget(#PB_Any, 260, 20, 280, 25, "Gestion Ingreso Tomografia")
  PanelGadget(#panel_principal, 20, 60, 970, 690)
  AddGadgetItem(#panel_principal, 0, "Gestion de Ingreso")
  
  TextGadget(#PB_Any, 40, 28, 130, 25, "Fecha y hora")
  StringGadget(#campo_fecha, 180, 28, 290, 25, "")
  DisableGadget(#campo_fecha, 1)
  TextGadget(#PB_Any, 40, 68, 130, 25, "DNI")
  StringGadget(#campo_dni, 180, 68, 290, 25, "")
  TextGadget(#PB_Any, 40, 108, 130, 25, "Apellido")
  StringGadget(#campo_apellido, 180, 108, 290, 25, "")
  TextGadget(#PB_Any, 40, 148, 130, 25, "Nombres")
  StringGadget(#campo_nombre, 180, 148, 290, 25, "")
  TextGadget(#PB_Any, 40, 188, 130, 25, "Ubicacion")
  ComboBoxGadget(#lista_ubicacion, 180, 188, 290, 25)
  AddGadgetItem(#lista_ubicacion, -1, "Internado")
  AddGadgetItem(#lista_ubicacion, -1, "Guardia", 0, 1)
  AddGadgetItem(#lista_ubicacion, -1, "Ambulatorio", 0, 2)
  TextGadget(#PB_Any, 500, 28, 130, 25, "Seleciona Turno")
  ComboBoxGadget(#lista_turnos, 640, 28, 290, 25)
  TextGadget(#PB_Any, 500, 68, 130, 25, "Tecnico")
  ComboBoxGadget(#lista_tecnicos, 640, 68, 290, 25)
  TextGadget(#PB_Any, 500, 108, 130, 25, "Constraste")
  ComboBoxGadget(#lista_contraste, 640, 108, 290, 25)
  AddGadgetItem(#lista_contraste, -1, "Sin contraste")
  AddGadgetItem(#lista_contraste, -1, "Contraste Oral", 0, 1)
  AddGadgetItem(#lista_contraste, -1, "Contraste EV", 0, 2)
  AddGadgetItem(#lista_contraste, -1, "Contraste Oral y EV", 0, 3)
  TextGadget(#PB_Any, 500, 148, 130, 25, "Solicitante")
  StringGadget(#campo_medico, 640, 148, 290, 25, "")
  TextGadget(#PB_Any, 500, 188, 130, 25, "Sala")
  StringGadget(#campo_sala, 640, 188, 290, 25, "")
  
  ListIconGadget(#estudios_cabeza, 40, 248, 280, 190, "Cabreza y Cuello", 270, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
  ListIconGadget(#estudios_torso, 340, 248, 280, 190, "Torso", 270, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
  ListIconGadget(#estudios_columna, 640, 248, 280, 190, "Columna y Extremidades", 270, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
  
  
  TextGadget(#PB_Any, 70, 458, 130, 25, "Diagnostico")
  StringGadget(#campo_diagnostico, 220, 458, 700, 25, "")
  TextGadget(#PB_Any, 70, 498, 130, 50, "Comentarios")
  EditorGadget(#campo_comentarios, 220, 498, 700, 70)
  ButtonGadget(#boton_guardar, 560, 588, 190, 60, "Guardar")
  ButtonGadget(#boton_limpiar, 260, 588, 190, 60, "Limpiar")
  
  AddGadgetItem(#panel_principal, 1, "Lista de pacientes")
  TextGadget(#PB_Any, 110, 28, 100, 25, "Busqueda")
  StringGadget(#campo_busqueda, 230, 28, 430, 25, "")
  ButtonGadget(#boton_busqueda, 690, 28, 150, 25, "Buscar")
  TextGadget(#PB_Any, 110, 68, 100, 25, "Fecha inicio")
  DateGadget(#date_inicio, 230, 68, 150, 25, "")
  TextGadget(#PB_Any, 390, 68, 100, 25, "Fecha fin")
  DateGadget(#date_fin, 510, 68, 150, 25, "")
  ButtonGadget(#boton_fecha, 690, 68, 150, 25, "Buscar fecha")
  ButtonGadget(#boton_limpiar_filtro, 110, 108, 140, 25, "Limpiar Filtros")
  TextGadget(#PB_Any, 270, 108, 100, 25, "Tecnico")
  ComboBoxGadget(#filtro_tecnico, 390, 108, 270, 25)
  ButtonGadget(#boton_fecha_hoy, 690, 108, 150, 25, "Hoy")
  
  ListIconGadget(#listado_pacientes, 20, 148, 930, 500, "Nro", 40, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#listado_pacientes, 1, "Fecha", 140)
  AddGadgetColumn(#listado_pacientes, 2, "Apellido y Nombre", 150)
  AddGadgetColumn(#listado_pacientes, 3, "DNI", 80)
  AddGadgetColumn(#listado_pacientes, 4, "Estudios", 250)
  AddGadgetColumn(#listado_pacientes, 5, "Diagnostico", 150)
  AddGadgetColumn(#listado_pacientes, 6, "Tecnico", 100)
  
  AddGadgetItem(#panel_principal, 2, "Detalles Estudio")
  TextGadget(#PB_Any, 310, 28, 230, 25, "Detalles Estudio")
  TextGadget(#PB_Any, 480, 278, 120, 25, "Tecnico")
  StringGadget(#detalle_tecnico, 610, 278, 300, 25, "")
  TextGadget(#PB_Any, 30, 78, 120, 25, "Fecha")
  StringGadget(#detalle_fecha, 160, 78, 300, 25, "")
  DisableGadget(#detalle_fecha, 1)
  TextGadget(#PB_Any, 30, 158, 120, 25, "Apellido")
  StringGadget(#detalle_apellido, 160, 158, 300, 25, "")
  TextGadget(#PB_Any, 30, 198, 120, 25, "Nombre")
  StringGadget(#detalle_nombre, 160, 198, 300, 25, "")
  TextGadget(#PB_Any, 30, 238, 120, 25, "Ubicacion")
  StringGadget(#detalle_ubicacion, 160, 238, 300, 25, "")
  TextGadget(#PB_Any, 480, 318, 120, 25, "Solicitante")
  StringGadget(#detalle_solicitante, 610, 318, 300, 25, "")
  TextGadget(#PB_Any, 30, 278, 120, 25, "Diagnostico")
  StringGadget(#detalle_diagnostico, 160, 278, 300, 25, "")
  TextGadget(#PB_Any, 30, 118, 120, 25, "DNI")
  StringGadget(#detalle_dni, 160, 118, 300, 25, "")
  TextGadget(#PB_Any, 480, 78, 120, 25, "Estudios")
  ListViewGadget(#detalle_estudios, 610, 78, 300, 180)
  TextGadget(#PB_Any, 30, 318, 120, 25, "Contraste")
  ComboBoxGadget(#detalle_contraste, 160, 318, 300, 25)
  AddGadgetItem(#detalle_contraste, -1, "Sin contraste")
  AddGadgetItem(#detalle_contraste, -1, "Contraste Oral", 0, 1)
  AddGadgetItem(#detalle_contraste, -1, "Contraste EV", 0, 2)
  AddGadgetItem(#detalle_contraste, -1, "Contraste Oral y EV", 0, 3)
  CloseGadgetList()
  CreateStatusBar(#barra_estado, WindowID(#ventana_principal))
  AddStatusBarField(50)
  AddStatusBarField(200)
  AddStatusBarField(200)
  AddWindowTimer(#ventana_principal, #reloj, 1000)
  
EndProcedure

ventana_principal()
leer_asignar_lista(#lista_turnos, "lista_turnos.txt")
leer_asignar_lista(#estudios_cabeza, "estudios_cabeza.txt" )
leer_asignar_lista(#estudios_torso, "estudios_torso.txt" )
leer_asignar_lista(#estudios_columna, "estudios_columna.txt" )
actualizar_lista_pacientes()
llenar_filtro_tecnicos()
desactivar_detalles()
barra_total_estudios()

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
            borrar_campos()
            actualizar_lista_pacientes()
          EndIf 
          
        Case #lista_turnos
          seleccionar_turno()
          
        Case #boton_fecha
          If GetGadgetState(#date_inicio) > GetGadgetState(#date_fin)
            MessageRequester("Error","La fecha de inicio no puede ser superior a la de fin",#PB_MessageRequester_Error)
          Else
            filtrar_fecha(GetGadgetState(#date_inicio), GetGadgetState(#date_fin))
          EndIf 
          
        Case #boton_busqueda
          busqueda()
          
        Case #filtro_tecnico
          filtro.s = " where tecnico_asignado = '" + GetGadgetText(#filtro_tecnico) + "'"
          actualizar_lista_pacientes(filtro)
          
        Case #boton_fecha_hoy
          filtrar_fecha(Date(), Date())
          
        Case #boton_limpiar_filtro
          actualizar_lista_pacientes()
          
        Case #listado_pacientes
          If EventType() = #PB_EventType_LeftDoubleClick
            ver_detalle_paciente()
          EndIf 
          
        Case #boton_limpiar
  
          
          
      EndSelect
  EndSelect
Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 247
; FirstLine = 67
; Folding = AQA-
; EnableXP
; HideErrorLog