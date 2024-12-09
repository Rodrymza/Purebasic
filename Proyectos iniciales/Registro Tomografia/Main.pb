;Registro pacientes de tomografia
;Rodry Ramirez (c) 2024
;rodrymza@gmail.com

Enumeration
  #archivo_turnos : #ventana_principal : #icono : #acerca_de
  #panel_principal : #lista_turnos : #about_image : #about_ico :#ventana_ayuda
  
  #lista_tecnicos : #campo_dni : #campo_apellido
  #campo_nombre : #lista_ubicacion : #campo_fecha
  #campo_diagnostico : #campo_medico : #lista_contraste
  
  #campo_comentarios : #fuente_principal : #campo_sala
  #estudios_cabeza : #estudios_torso : #estudios_columna
  #boton_guardar : #boton_limpiar : #boton_cancelar
  #reloj : #base_datos
  
  #listado_pacientes : #campo_busqueda : #date_inicio
  #date_fin : #boton_mes_actual : #boton_borrar_estudio
  #boton_busqueda : #boton_fecha_hoy : #texto_estadistica_tabla
  #filtro_tecnico : #boton_limpiar_filtro : #boton_mostrar_detalles
  
  #detalle_tecnico : #detalle_fecha : #detalle_apellido : #modificar_detalles : #detalle_id
  #detalle_nombre : #detalle_ubicacion : #detalle_solicitante : #detalle_guardar : #boton_quitar_estudio
  #detalle_diagnostico : #detalle_dni: #detalle_estudios : #texto_contraste : #detalle_agregar_estudios
  #detalle_contraste : #barra_estado : #detalle_contraste_combo : #detalle_comentarios : #texto_estudios_detalle
EndEnumeration

Structure datos
  numero.l
  fecha.s
  nombre.s
  dni.s
  estudios.s
  diagnostico.s
  tecnico.s
EndStructure

LoadFont(#fuente_principal,"Segoe UI", 11)
LoadImage(#icono, "tac.ico")
texto_auxiliar.s = ""
ascendente = #True
UseSQLiteDatabase()

Global dbname.s = "gestion_tomografia.db" : Global user.s = "" : Global pass.s = ""

Procedure ventana_acercade() ;del menu de ayuda-acerca de
  OpenWindow(#ventana_ayuda, 0, 0, 480, 190, "Acerca de", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  SendMessage_(WindowID(#ventana_ayuda), #WM_SETICON, 0, LoadImage(#about_ico, "about.ico"))
  TextGadget(#PB_Any, 30, 50, 260, 25, "Registro pacientes tomografia Hospital Central v1.0")
  TextGadget(#PB_Any, 30, 90, 260, 25, "Rodry Ramirez (c) 2024")
  TextGadget(#PB_Any, 30, 130, 260, 25, "rodrymza@gmail.com")
  ImageGadget(#PB_Any, 320, 32, 128, 128, LoadImage(#about_image, "medical.ico"))
  Repeat  
    event=WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_ayuda) 
    EndSelect
  Until event= #PB_Event_CloseWindow
EndProcedure

Procedure.b pedir_contrasenia()
  contrasenia.s = "1234" ;"HCentralTomo_2024"
  If InputRequester("Contraseña requerida", "Ingrese contraseña de administrador", "", #PB_InputRequester_Password) = contrasenia
    MessageRequester("Atencion","Acceso correcto", #PB_MessageRequester_Ok)
    ProcedureReturn #True
  Else
    MessageRequester("Error", "La contrasenia ingresada es incorrecta", #PB_MessageRequester_Error)
    ProcedureReturn #False  
  EndIf   
EndProcedure

Procedure barra_total_estudios()
  OpenDatabase(#base_datos, dbname, user, pass)
  hoy.s = FormatDate("%yyyy-%mm-%dd", Date())
  anio.s = FormatDate("%yyyy", Date())
  mes.s = FormatDate("%yyyy-%mm", Date())
  DatabaseQuery(#base_datos, "SELECT count(*) FROM registro_pacientes where fecha like '" + hoy + "%';")
  While NextDatabaseRow(#base_datos)
    total = GetDatabaseLong(#base_datos, 0)
  Wend  
  FinishDatabaseQuery(#base_datos)
  StatusBarText(#barra_estado, 1, "Total estudios de hoy: " + total)
  
  DatabaseQuery(#base_datos, "SELECT count(*) FROM registro_pacientes where fecha like '" + anio + "%';")
  While NextDatabaseRow(#base_datos)
    total = GetDatabaseLong(#base_datos, 0)
  Wend  
  FinishDatabaseQuery(#base_datos)
  StatusBarText(#barra_estado, 2, "Total estudios del año: " + total)
  
  DatabaseQuery(#base_datos, "SELECT count(*) FROM registro_pacientes where fecha like '" + mes + "%';")
  While NextDatabaseRow(#base_datos)
    total = GetDatabaseLong(#base_datos, 0)
  Wend
  FinishDatabaseQuery(#base_datos)
  StatusBarText(#barra_estado, 3, "Total estudios del mes: " + total)
  
EndProcedure

Procedure asignar_bd_a_gadget(tablename.s, columna, gadget, filtro.s = "" , orden.s = "", seleccion.s = "*")
If OpenDatabase(#base_datos, dbname, user, pass)
  DatabaseQuery(#base_datos, "SELECT " + seleccion + " FROM " + tablename + filtro + orden)
  Debug "SELECT " + seleccion + " FROM " + tablename + filtro + orden
  ClearGadgetItems(gadget)
  While NextDatabaseRow(#base_datos)
    texto.s = GetDatabaseString(#base_datos, columna)
    Debug texto
    AddGadgetItem(gadget, -1, texto)
    Wend  
EndIf 

EndProcedure

Procedure.s leer_estudios()
  NewList  lista_estudios.s()
  estudios.s = ""
  For i=0 To CountGadgetItems(#estudios_cabeza)-1
    
    If GetGadgetItemState(#estudios_cabeza, i) & #PB_ListIcon_Checked
      AddElement(lista_estudios())
      lista_estudios() = GetGadgetItemText(#estudios_cabeza, i)
    EndIf   
  Next
  
  For i=0 To CountGadgetItems(#estudios_columna)-1
    
    If GetGadgetItemState(#estudios_columna, i) & #PB_ListIcon_Checked
      AddElement(lista_estudios())
      lista_estudios() = GetGadgetItemText(#estudios_columna, i)
    EndIf 
  Next
  
  For i=0 To CountGadgetItems(#estudios_torso)-1
    
    If GetGadgetItemState(#estudios_torso, i) & #PB_ListIcon_Checked
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
    
    If GetGadgetItemState(#estudios_cabeza, i) & #PB_ListIcon_Checked
      ProcedureReturn #True 
    EndIf  
  Next
  For i=0 To CountGadgetItems(#estudios_columna)-1
    
    If GetGadgetItemState(#estudios_columna, i) & #PB_ListIcon_Checked
      ProcedureReturn #True 
    EndIf  
  Next
  For i=0 To CountGadgetItems(#estudios_torso)-1
    
    If GetGadgetItemState(#estudios_torso, i) & #PB_ListIcon_Checked
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
  tecnico.s = GetGadgetText(#lista_tecnicos) : contraste.s = GetGadgetText(#lista_contraste)
  dni.s = GetGadgetText(#campo_dni)  : nombre.s = title(GetGadgetText(#campo_nombre))
  apellido.s = title(GetGadgetText(#campo_apellido)) :  ubicacion.s = GetGadgetText(#lista_ubicacion) + " " + GetGadgetText(#campo_sala)
  
  regiones.s = leer_estudios()
  
  solicitante.s = title(GetGadgetText(#campo_medico)) : diagnostico.s = capitalize(GetGadgetText(#campo_diagnostico))
  comentarios.s = capitalize(GetGadgetText(#campo_comentarios))
  
  If OpenDatabase(#base_datos, dbname, user, pass)
    
    tabla.s = "INSERT INTO registro_pacientes (fecha, dni, apellido, nombre, ubicacion, region, solicitante, diagnostico, comentarios,tecnico_asignado, contraste) "
    valores.s = " VALUES ('" + fecha + "', '" + dni + "', '" + apellido + "', '" + nombre + "', '" + ubicacion + "', '" + regiones + "', '" + solicitante + "', '" + diagnostico + "', '"+ comentarios + "', '" + tecnico + "', '" + contraste + "')"
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

Procedure actualizar_base_datos()
  tecnico.s = GetGadgetText(#detalle_tecnico) 
  dni.s = GetGadgetText(#detalle_dni) : apellido.s = title(GetGadgetText(#detalle_apellido))
  nombre.s =title(GetGadgetText(#detalle_nombre)) : ubicacion.s = title(GetGadgetText(#detalle_ubicacion))
  diagnostico.s = GetGadgetText(#detalle_diagnostico) : solicitante.s = GetGadgetText(#detalle_solicitante)
  comentarios.s = GetGadgetText(#detalle_comentarios) : estudios.s = ""
  ubicacion.s = GetGadgetText(#detalle_ubicacion)
  contraste.s = GetGadgetText(#detalle_contraste_combo)
  solicitante.s = GetGadgetText(#detalle_solicitante)
  id.s = GetGadgetText(#detalle_id)
  
    For i= 0 To CountGadgetItems(#detalle_estudios) - 1
      estudios + GetGadgetItemText(#detalle_estudios, i) + ", "
    Next
    estudios = Left(estudios, Len(estudios)-2)
    If OpenDatabase(#base_datos, dbname, user, pass)
      query.s = "UPDATE 'registro_pacientes' SET " +
                "dni = '" + dni + "', " +
                "apellido = '" + apellido + "', " +
                "nombre = '" + nombre + "', " +
                "diagnostico = '" + diagnostico + "', " +
                "region = '" + estudios + "', " +
                "comentarios = '" + comentarios + "', " +
                "solicitante = '" + solicitante + "', " +
                "ubicacion = '" + ubicacion + "', " +
                "contraste = '" + contraste + "', " +
                "tecnico_asignado = '" + tecnico + "' " +
              "WHERE id_registro = " + id
      If DatabaseUpdate(#base_datos, query)
        MessageRequester("Atencion","Registro actualizado exitosamente", #PB_MessageRequester_Ok)
      Else 
        MessageRequester("Error","Error al procesar solicitud de actualizacion", #PB_MessageRequester_Error)
      EndIf 
    Else
      MessageRequester("Error", "Error al conectarse a la base de datos", #PB_MessageRequester_Error)
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
      barra_total_estudios()
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
  filtro.s = ""
  busqueda.s = GetGadgetText(#campo_busqueda)
  If busqueda<>""
    filtro = " and nombre like '%" + busqueda + "%' or apellido like '%" + busqueda + "%' or dni like '%" +busqueda + "%'"
  EndIf 
  
  inicio.s = FormatDate("%yyyy-%mm-%dd" , fecha_inicio)
  fin.s = FormatDate("%yyyy-%mm-%dd" , fecha_fin)
  query.s = " where (fecha between '" + inicio + " 00:00' and '" + fin + " 23:59')" + filtro
  ;actualizar_lista_pacientes(query)
  
EndProcedure

Procedure busqueda(fecha_inicio, fecha_fin)
  busqueda.s = GetGadgetText(#campo_busqueda)
  filtro.s = ""
  inicio.s = FormatDate("%yyyy-%mm-%dd" , fecha_inicio)
  fin.s = FormatDate("%yyyy-%mm-%dd" , fecha_fin)
  If busqueda<>""
    filtro = " where nombre like '%" + busqueda + "%' or apellido like '%" + busqueda + "%' or dni like '%" +busqueda + "%' and (fecha between '" + inicio + " 00:00' And '" + fin + " 23:59')" 
  Else
    filtro = " where (fecha between '" + inicio + " 00:00' and '" + fin + " 23:59')"
  EndIf 
  actualizar_lista_pacientes(filtro)
EndProcedure

Procedure ver_detalle_paciente()

  id_paciente.s = GetGadgetText(#listado_pacientes)
  If OpenDatabase(#base_datos, dbname, user, pass)
    If DatabaseQuery(#base_datos, "SELECT * FROM registro_pacientes where id_registro = '" + id_paciente + "'")
      While NextDatabaseRow(#base_datos)
        id.s = GetDatabaseString(#base_datos, 0)
        fecha.s = GetDatabaseString(#base_datos, 1)
        dni.s = GetDatabaseString(#base_datos, 2)
        apellido.s = GetDatabaseString(#base_datos, 3)
        nombre.s = GetDatabaseString(#base_datos, 4)
        ubicacion.s = GetDatabaseString(#base_datos, 5)
        estudios.s = GetDatabaseString(#base_datos, 6)
        contraste.s = GetDatabaseString(#base_datos, 7)
        solicitante.s = GetDatabaseString(#base_datos, 8)
        diagnostico.s = GetDatabaseString(#base_datos, 9)
        comentarios.s = GetDatabaseString(#base_datos, 10)
        tecnico.s = GetDatabaseString(#base_datos, 11)
      Wend  
      
    EndIf 
  EndIf
  SetGadgetText(#detalle_id, id)
  SetGadgetText(#detalle_fecha, fecha)
  SetGadgetText(#detalle_dni, dni)
  SetGadgetText(#detalle_apellido, apellido)
  SetGadgetText(#detalle_nombre, nombre)
  SetGadgetText(#detalle_ubicacion, ubicacion)
  SetGadgetText(#detalle_diagnostico, diagnostico)
  SetGadgetText(#detalle_tecnico, tecnico)
  SetGadgetText(#detalle_solicitante, solicitante)
  SetGadgetText(#detalle_contraste, contraste)
  SetGadgetText(#detalle_comentarios, comentarios)
  
  ClearGadgetItems(#detalle_estudios)
  total = CountString(estudios, ",")
  For i=1 To total+1
    AddGadgetItem(#detalle_estudios, -1, StringField(estudios, i,", "))
  Next
  
  SetGadgetState(#panel_principal, 2)
  
  
EndProcedure

Procedure desactivar_detalles(desactivar = #True)
  DisableGadget(#detalle_apellido, desactivar)
  DisableGadget(#detalle_nombre, desactivar)
  DisableGadget(#detalle_dni, desactivar)
  DisableGadget(#detalle_diagnostico, desactivar)
  DisableGadget(#detalle_solicitante, desactivar)
  DisableGadget(#detalle_tecnico, desactivar)
  DisableGadget(#detalle_ubicacion, desactivar)
  DisableGadget(#detalle_comentarios, desactivar)
  DisableGadget(#detalle_contraste, desactivar)
  HideGadget(#detalle_contraste_combo, desactivar)
  HideGadget(#detalle_contraste, Bool(Not desactivar))
  DisableGadget(#detalle_guardar, desactivar)
  HideGadget(#detalle_agregar_estudios, desactivar)
  HideGadget(#texto_estudios_detalle, desactivar)
  DisableGadget(#modificar_detalles, Bool(Not desactivar))
  DisableGadget(#boton_quitar_estudio, desactivar)
EndProcedure

Procedure modificar_detalles() 
  desactivar_detalles(0)
  HideGadget(#detalle_contraste, 1) :  HideGadget(#detalle_contraste_combo, 0) :  DisableGadget(#detalle_guardar, 0)
  contraste.s = GetGadgetText(#detalle_contraste)
  For i=0 To CountGadgetItems(#detalle_contraste_combo)
    If GetGadgetItemText(#detalle_contraste_combo, i) = contraste
      SetGadgetState(#detalle_contraste_combo, i)
      Break
    EndIf 
  Next
EndProcedure

Procedure mostrar_total_lista()
  total = CountGadgetItems(#listado_pacientes)
  SetGadgetText(#texto_estadistica_tabla, "Total estudios listados: " + total)
EndProcedure

Procedure obtener_listado_pacientes(offset, typeof.i, ascendente.b)
  
  NewList lista_pacientes.datos()
  For i=0 To CountGadgetItems(#listado_pacientes)-1
    AddElement(lista_pacientes())
    lista_pacientes()\numero = Val(GetGadgetItemText(#listado_pacientes, i, 0))
    lista_pacientes()\fecha = GetGadgetItemText(#listado_pacientes, i, 1)
    lista_pacientes()\nombre = GetGadgetItemText(#listado_pacientes, i, 2)
    lista_pacientes()\dni = GetGadgetItemText(#listado_pacientes, i, 3)
    lista_pacientes()\estudios = GetGadgetItemText(#listado_pacientes, i, 4)
    lista_pacientes()\diagnostico = GetGadgetItemText(#listado_pacientes, i, 5)
    lista_pacientes()\tecnico = GetGadgetItemText(#listado_pacientes, i, 6)
  Next
  
  If ascendente
    SortStructuredList(lista_pacientes(), #PB_Sort_Ascending,offset, typeof)
  Else
    SortStructuredList(lista_pacientes(), #PB_Sort_Descending, offset, typeof)
  EndIf 
  i=0
  ClearGadgetItems(#listado_pacientes)
  ForEach lista_pacientes()
  AddGadgetItem(#listado_pacientes, -1, Str(lista_pacientes()\numero) + Chr(10) + lista_pacientes()\fecha + Chr(10) + lista_pacientes()\nombre + Chr(10) + lista_pacientes()\dni + Chr(10) + lista_pacientes()\estudios + Chr(10) + lista_pacientes()\diagnostico + Chr(10) + lista_pacientes()\tecnico)
 If i%2=0
      SetGadgetItemColor(#listado_pacientes, i, #PB_Gadget_BackColor, $AACD66)          
    EndIf 
    i+1  
Next
  mostrar_total_lista()
EndProcedure
  
Procedure ventana_principal()
  
  OpenWindow(#ventana_principal, 0, 0, 1010, 790, "Registro Tomografia", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  SendMessage_(WindowID(#ventana_principal), #WM_SETICON, 0, ImageID(#icono))
  SetGadgetFont(#PB_Any, FontID(#fuente_principal))
  TextGadget(#PB_Any, 260, 20, 280, 25, "Gestion Ingreso Tomografia")
  PanelGadget(#panel_principal, 20, 60, 970, 690)
  AddGadgetItem(#panel_principal, 0, "Gestion de Ingreso")
  CreateMenu(#PB_Any, WindowID(#ventana_principal))
  MenuTitle("Ayuda")
  MenuItem(#acerca_de, "Acerca de")
  
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
  AddGadgetItem(#lista_contraste, -1, "Sin Contraste")
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
  DateGadget(#date_inicio, 230, 68, 150, 25, "",Date(Year(Date()),Month(Date()),1,0,0,0))
  TextGadget(#PB_Any, 390, 68, 100, 25, "Fecha fin")
  DateGadget(#date_fin, 510, 68, 150, 25, "")
  ButtonGadget(#boton_mes_actual, 690, 68, 150, 25, "Mes actual")
  ButtonGadget(#boton_limpiar_filtro, 110, 108, 140, 25, "Limpiar Filtros")
  TextGadget(#PB_Any, 270, 108, 100, 25, "Tecnico")
  ComboBoxGadget(#filtro_tecnico, 390, 108, 270, 25)
  ButtonGadget(#boton_fecha_hoy, 690, 108, 150, 25, "Hoy")
  
  ListIconGadget(#listado_pacientes, 20, 148, 930, 470, "Nro", 40, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#listado_pacientes, 1, "Fecha", 140)
  AddGadgetColumn(#listado_pacientes, 2, "Apellido y Nombre", 150)
  AddGadgetColumn(#listado_pacientes, 3, "DNI", 80)
  AddGadgetColumn(#listado_pacientes, 4, "Estudios", 250)
  AddGadgetColumn(#listado_pacientes, 5, "Diagnostico", 150)
  AddGadgetColumn(#listado_pacientes, 6, "Tecnico", 100)
  ButtonGadget(#boton_borrar_estudio, 740, 628, 200, 25, "Borrar Estudio")
  TextGadget(#texto_estadistica_tabla, 20, 628, 280, 25, "Total estudios listados: ")
  
  AddGadgetItem(#panel_principal, 2, "Detalles Estudio")
  TextGadget(#PB_Any, 330, 8, 230, 25, "Detalles Estudio")
  TextGadget(#PB_Any, 30, 38, 120, 25, "ID")
  StringGadget(#detalle_id, 160, 38, 300, 25, "")
  DisableGadget(#detalle_id, 1)
  TextGadget(#PB_Any, 480, 78, 120, 25, "Tecnico")
  StringGadget(#detalle_tecnico, 610, 78, 300, 25, "")
  TextGadget(#PB_Any, 30, 78, 120, 25, "Fecha")
  StringGadget(#detalle_fecha, 160, 78, 300, 25, "")
  DisableGadget(#detalle_fecha, 1)
  TextGadget(#PB_Any, 30, 158, 120, 25, "Apellido")
  StringGadget(#detalle_apellido, 160, 158, 300, 25, "")
  TextGadget(#PB_Any, 30, 198, 120, 25, "Nombre")
  StringGadget(#detalle_nombre, 160, 198, 300, 25, "")
  TextGadget(#PB_Any, 30, 238, 120, 25, "Ubicacion")
  StringGadget(#detalle_ubicacion, 160, 238, 300, 25, "")
  TextGadget(#PB_Any, 30, 368, 120, 25, "Solicitante")
  StringGadget(#detalle_solicitante, 160, 368, 300, 25, "")
  TextGadget(#PB_Any, 30, 278, 120, 25, "Diagnostico")
  EditorGadget(#detalle_diagnostico, 160, 278, 300, 70, #PB_Editor_WordWrap)
  TextGadget(#PB_Any, 30, 118, 120, 25, "DNI")
  StringGadget(#detalle_dni, 160, 118, 300, 25, "")
  TextGadget(#PB_Any, 480, 118, 120, 25, "Estudios")
  ListViewGadget(#detalle_estudios, 610, 118, 300, 160)
  TextGadget(#PB_Any, 30, 408, 120, 25, "Contraste")
  StringGadget(#detalle_contraste, 160, 408, 300, 25, "")
  ComboBoxGadget(#detalle_contraste_combo, 160, 408, 300, 25)
  HideGadget(#detalle_contraste_combo, 1)
  AddGadgetItem(#detalle_contraste_combo, -1, "Sin Contraste")
  AddGadgetItem(#detalle_contraste_combo, -1, "Contraste Oral", 0, 1)
  AddGadgetItem(#detalle_contraste_combo, -1, "Contraste EV", 0, 2)
  AddGadgetItem(#detalle_contraste_combo, -1, "Contraste Oral y EV", 0, 3)
  ComboBoxGadget(#detalle_agregar_estudios, 160, 448, 300, 25)
  TextGadget(#texto_estudios_detalle, 30, 448, 120, 25, "Estudios")
  TextGadget(#PB_Any, 480, 288, 120, 25, "Comentarios")
  EditorGadget(#detalle_comentarios, 610, 288, 300, 140, #PB_Editor_WordWrap)
  ButtonGadget(#boton_quitar_estudio, 810, 438, 100, 25, "Quitar")
  ButtonGadget(#modificar_detalles, 670, 508, 170, 40, "Modificar")
  ButtonGadget(#detalle_guardar, 670, 558, 170, 40, "Guardar")
  
  CloseGadgetList()
  CreateStatusBar(#barra_estado, WindowID(#ventana_principal))
  AddStatusBarField(50)
  AddStatusBarField(200)
  AddStatusBarField(200)
  AddStatusBarField(200)
  AddWindowTimer(#ventana_principal, #reloj, 1000)
  
EndProcedure

Procedure inicializacion()
  ventana_principal()
  asignar_bd_a_gadget("lista_turnos", 0, #lista_turnos)
  asignar_bd_a_gadget("estudios", 0, #estudios_cabeza, " where region = 'Cabeza'")
  asignar_bd_a_gadget("estudios", 0, #estudios_torso, " where region = 'Torso'")
  asignar_bd_a_gadget("estudios", 0, #estudios_columna, " where region = 'Columna'")
  asignar_bd_a_gadget("estudios", 0, #detalle_agregar_estudios, "", " order by nombre asc")
  actualizar_lista_pacientes()
  llenar_filtro_tecnicos()
  desactivar_detalles()
  barra_total_estudios()
  mostrar_total_lista()
EndProcedure

inicializacion()

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
          If GetGadgetState(#lista_ubicacion) = 01. Pasar todos los txt dentro de la base de datos y reestructurar código para que sea todo leído desde ahí

            DisableGadget(#campo_sala, 0)
            SetGadgetText(#campo_sala, texto_auxiliar)
          Else 
            DisableGadget(#campo_sala, 1)
            texto_auxiliar.s = GetGadgetText(#campo_sala)
            SetGadgetText(#campo_sala, "")
          EndIf
          
        Case #boton_limpiar
          borrar_campos()
          
        Case #boton_guardar
          If Not comprobar_campos_vacios() And comprobar_region()
            adquirir_datos()
            borrar_campos()
            actualizar_lista_pacientes()
          EndIf 
          
        Case #lista_turnos
          seleccionar_turno()
          
        Case #boton_mes_actual
          SetGadgetState(#date_inicio, Date(Year(Date()),Month(Date()),1,0,0,0))
          filtrar_fecha(GetGadgetState(#date_inicio), GetGadgetState(#date_fin))
          mostrar_total_lista()
          
        Case #boton_busqueda
          If GetGadgetState(#date_inicio) > GetGadgetState(#date_fin)
            MessageRequester("Error","La fecha de inicio no puede ser superior a la de fin",#PB_MessageRequester_Error)
          Else
            busqueda(GetGadgetState(#date_inicio), GetGadgetState(#date_fin))
          EndIf 
          mostrar_total_lista()
          
        Case #filtro_tecnico
          filtro.s = " where tecnico_asignado = '" + GetGadgetText(#filtro_tecnico) + "'"
          actualizar_lista_pacientes(filtro)
          mostrar_total_lista()
          
        Case #boton_fecha_hoy
          filtrar_fecha(Date(), Date())
          mostrar_total_lista()
          
        Case #boton_limpiar_filtro
          actualizar_lista_pacientes()
          mostrar_total_lista()
          
        Case #listado_pacientes
          If EventType() = #PB_EventType_LeftDoubleClick
            ver_detalle_paciente()
            desactivar_detalles()
          EndIf 
          If EventType() = #PB_EventType_ColumnClick
            If ascendente
              ascendente = #False 
            Else 
              ascendente = #True
            EndIf 
            
            NewList lista_pacientes.datos()
            column =  GetGadgetAttribute(#listado_pacientes, #PB_ListIcon_ClickedColumn)
            Select column
              Case 0
                obtener_listado_pacientes(OffsetOf(datos\numero), TypeOf(datos\numero), ascendente)
              Case 1
                obtener_listado_pacientes(OffsetOf(datos\fecha), #PB_String, ascendente)
              Case 2
                obtener_listado_pacientes(OffsetOf(datos\nombre), #PB_String, ascendente)
              Case 6
                obtener_listado_pacientes(OffsetOf(datos\tecnico), #PB_String, ascendente)
            EndSelect
          EndIf
          
        Case #modificar_detalles
          If GetGadgetText(#detalle_apellido) <>"" 
            If pedir_contrasenia()
              modificar_detalles()
              DisableGadget(#modificar_detalles, 1)
            EndIf 
          Else
            MessageRequester("Error","No hay ningun estudio seleccionado")
          EndIf 
          
        Case #boton_borrar_estudio
             
        Case #detalle_agregar_estudios
          estudio.s = GetGadgetText(#detalle_agregar_estudios)
          AddGadgetItem(#detalle_estudios, -1, estudio)
          
        Case #boton_quitar_estudio
          posicion = GetGadgetState(#detalle_estudios)
          If posicion <> -1
            RemoveGadgetItem(#detalle_estudios, posicion)
          Else
            MessageRequester("Error","No selecciono ningun estudio",#PB_MessageRequester_Error)
          EndIf 
        Case #detalle_guardar
          actualizar_base_datos()
          actualizar_lista_pacientes()
          desactivar_detalles()
      EndSelect
    Case #PB_Event_Menu
      
      Select EventMenu()
        Case #acerca_de
          ventana_acercade()
      EndSelect  
  EndSelect
Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 656
; FirstLine = 118
; Folding = IAAA-
; Markers = 64
; EnableXP
; HideErrorLog