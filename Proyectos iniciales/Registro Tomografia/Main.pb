;Registro pacientes de tomografia
;Rodry Ramirez (c) 2024
;rodrymza@gmail.com

IncludeFile "funciones.pb"

Enumeration
  #archivo_turnos : #ventana_principal : #icono : #acerca_de : #menu_principal : #menu_copia
  #panel_principal : #lista_turnos : #about_image : #about_ico :#ventana_ayuda : #bd_pacientes : #ver_log : #menu_exportar_csv : #menu_exportar_fecha
  
  #lista_tecnicos : #campo_fecha :#campo_dni :#campo_apellido
  #campo_nombre : #lista_ubicacion : #campo_id
  #campo_diagnostico  : #lista_contraste : #campo_comentarios : #campo_medico
  
  #fuente_principal : #campo_sala
  #estudios_cabeza : #estudios_torso : #estudios_columna
  #boton_guardar : #boton_limpiar
  #reloj : #base_datos 
  
  #listado_pacientes : #campo_busqueda : #date_inicio
  #date_fin : #boton_mes_actual : #boton_borrar_estudio
  #boton_busqueda : #boton_fecha_hoy : #texto_estadistica_tabla
  #filtro_tecnico : #boton_limpiar_filtro : #boton_mostrar_detalles
  
  #detalle_tecnico : #detalle_fecha : #detalle_apellido : #modificar_detalles : #detalle_id
  #detalle_nombre : #detalle_ubicacion : #detalle_solicitante : #detalle_guardar : #boton_quitar_estudio
  #detalle_diagnostico : #detalle_dni: #detalle_estudios : #texto_contraste : #detalle_agregar_estudios : #activar_borrado
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
LoadImage(#icono, "resources\tac.ico")
texto_auxiliar.s = ""
ascendente = #True
oculto = #True
encontrado = #False
UseSQLiteDatabase()


Global dbname.s = "resources\gestion_tomografia.db" : Global user.s = "" : Global pass.s = "" : backup_dir.s = "resources\backups\" : contrasenia.s = "tomo_central_2024"


Procedure.s leer_estudios() ;lee los estudios marcados el las listicon y los guarda en un texto
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

Procedure comprobar_region() ;comprueba que al menos una region este seleccionada
  
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

Procedure adquirir_datos() ;adquisicion de datos y guardado en la base de datos
  id.s = GetGadgetText(#campo_id)
  fecha.s = FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss", Date())
  tecnico.s = GetGadgetText(#lista_tecnicos) : contraste.s = GetGadgetText(#lista_contraste)
  dni.s = GetGadgetText(#campo_dni)  : nombre.s = title(GetGadgetText(#campo_nombre))
  apellido.s = title(GetGadgetText(#campo_apellido)) :  ubicacion.s = GetGadgetText(#lista_ubicacion) + " " + GetGadgetText(#campo_sala)
  
  regiones.s = leer_estudios()
  
  solicitante.s = title(GetGadgetText(#campo_medico)) : diagnostico.s = capitalize(GetGadgetText(#campo_diagnostico))
  comentarios.s = capitalize(GetGadgetText(#campo_comentarios))
  
  If OpenDatabase(#base_datos, dbname, user, pass)
    
    tabla.s = "INSERT INTO registro_pacientes (id_registro, fecha, dni, apellido, nombre, ubicacion, region, solicitante, diagnostico, comentarios,tecnico_asignado, contraste) "
    valores.s = " VALUES ("  + id + ", '" + fecha + "', '" + dni + "', '" + apellido + "', '" + nombre + "', '" + ubicacion + "', '" + regiones + "', '" + solicitante + "', '" + diagnostico + "', '"+ comentarios + "', '" + tecnico + "', '" + contraste + "')"
    query.s = tabla + valores
    ;Debug query
    If DatabaseUpdate(#base_datos, query) 
      MessageRequester("Registro guardado", "Registro guardado en la base de datos exitosamente")
    Else 
      MessageRequester("Error", DatabaseError())
    EndIf
    CloseDatabase(#PB_All)
  Else
    MessageRequester("Error",DatabaseError(), #PB_MessageRequester_Error)
  EndIf 
  
EndProcedure

Procedure actualizar_base_datos() ;actualizacion de base de datos de pestaña modificacion
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
    CloseDatabase(#PB_All)
  Else
    MessageRequester("Error", "Error al conectarse a la base de datos", #PB_MessageRequester_Error)
  EndIf 
  
  
EndProcedure

Procedure comprobar_campos_vacios() ; comprobar que no hay campos obligatorios vacios
  
  For i = #lista_tecnicos To #lista_contraste
    If GetGadgetText(i) = ""
      MessageRequester("Error", "Falta completar campos obligatorios")
      ProcedureReturn #True 
    EndIf 
  Next
  
  ProcedureReturn #False 
EndProcedure

Procedure actualizar_lista_pacientes(filtro.s = "") ; actualizacion de gadget lista pacientes
  
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
        tecnico.s = StringField(GetDatabaseString(#base_datos, 11), 1, ",") + "," + Mid(StringField(GetDatabaseString(#base_datos, 11), 2, ","), 1, 2) + "."
        diagnostico.s = GetDatabaseString(#base_datos, 9)
        
        AddGadgetItem(#listado_pacientes, -1, nro + Chr(10) + fecha + Chr(10) + nombre + Chr(10) + dni + Chr(10) + estudios + Chr(10) + diagnostico + Chr(10) + tecnico)
        If i%2 = 0
          SetGadgetItemColor(#listado_pacientes, i, #PB_Gadget_BackColor, $EEE58E)          
        EndIf 
        i + 1
      Wend 
      FinishDatabaseQuery(#base_datos)
      barra_total_estudios()
    Else
      MessageRequester("Error", DatabaseError())
    EndIf
    CloseDatabase(#PB_All)
  Else
    MessageRequester("Error", DatabaseError())
    
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
  actualizar_lista_pacientes(query)
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
      FinishDatabaseQuery(#base_datos)
    Else
      MessageRequester("Error", DatabaseError())
    EndIf
    CloseDatabase(#PB_All)
  Else
    MessageRequester("Error", DatabaseError())
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
  SetGadgetText(#detalle_contraste_combo, contraste)
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
  DisableGadget(#detalle_contraste_combo, desactivar)
  DisableGadget(#detalle_guardar, desactivar)
  HideGadget(#detalle_agregar_estudios, desactivar)
  HideGadget(#texto_estudios_detalle, desactivar)
  DisableGadget(#modificar_detalles, Bool(Not desactivar))
  DisableGadget(#boton_quitar_estudio, desactivar)
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
  
  OpenWindow(#ventana_principal, 0, 0, 1010, 810, "Registro Tomografia", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget)
  SendMessage_(WindowID(#ventana_principal), #WM_SETICON, 0, ImageID(#icono))
  SetGadgetFont(#PB_Any, FontID(#fuente_principal))
  TextGadget(#PB_Any, 260, 20, 280, 25, "Gestion Ingreso Tomografia")
  PanelGadget(#panel_principal, 20, 60, 970, 690)
  AddGadgetItem(#panel_principal, 0, "Gestion de Ingreso")
  CreateMenu(#menu_principal, WindowID(#ventana_principal))
  MenuTitle("Ayuda")
  MenuItem(#acerca_de, "Acerca de")
  MenuItem(#bd_pacientes, "Pacientes")
  MenuTitle("Sistema")
  MenuItem(#ver_log, "Ver log")
  MenuItem(#menu_copia, "Crear backup")
  MenuItem(#menu_exportar_csv, "Exportar archivo csv")
  MenuItem(#menu_exportar_fecha, "Exportar cvs entre fechas")
  DisableMenuItem(#menu_principal, #ver_log, 1)
  
  TextGadget(#PB_Any, 40, 28, 130, 25, "Fecha y hora")
  StringGadget(#campo_fecha, 180, 28, 180, 25, "", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 370, 28, 20, 25, "N°")
  StringGadget(#campo_id, 400, 28, 70, 25, "", #PB_String_ReadOnly)
  SetGadgetColor(#campo_id, #PB_Gadget_BackColor, $ADDEFF)
  TextGadget(#PB_Any, 40, 68, 130, 25, "DNI")
  StringGadget(#campo_dni, 180, 68, 290, 25, "", #PB_String_Numeric)
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
  TextGadget(#PB_Any, 500, 108, 130, 25, "Contraste")
  ComboBoxGadget(#lista_contraste, 640, 108, 290, 25)
  AddGadgetItem(#lista_contraste, -1, "Sin Contraste")
  AddGadgetItem(#lista_contraste, -1, "Contraste Oral", 0, 1)
  AddGadgetItem(#lista_contraste, -1, "Contraste EV", 0, 2)
  AddGadgetItem(#lista_contraste, -1, "Contraste Oral y EV", 0, 3) : SetGadgetState(#lista_contraste, 0)
  TextGadget(#PB_Any, 500, 148, 130, 25, "Solicitante")
  StringGadget(#campo_medico, 640, 148, 290, 25, "")
  TextGadget(#PB_Any, 500, 188, 130, 25, "Sala")
  StringGadget(#campo_sala, 640, 188, 290, 25, "")
  
  ListIconGadget(#estudios_cabeza, 40, 248, 280, 190, "Cabreza y Cuello", 270, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
  ListIconGadget(#estudios_torso, 340, 248, 280, 190, "Torso", 270, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
  ListIconGadget(#estudios_columna, 640, 248, 280, 190, "Columna y Extremidades", 270, #PB_ListIcon_CheckBoxes | #PB_ListIcon_GridLines)
  
  TextGadget(#PB_Any, 70, 458, 130, 25, "Diagnostico")
  StringGadget(#campo_diagnostico, 220, 458, 700, 25, "") 
  ButtonGadget(#boton_guardar, 560, 588, 190, 60, "Guardar")
  TextGadget(#PB_Any, 70, 498, 130, 50, "Comentarios")
  EditorGadget(#campo_comentarios, 220, 498, 700, 70)
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
  HideGadget(#boton_borrar_estudio, 1)
  TextGadget(#texto_estadistica_tabla, 20, 628, 280, 25, "Total estudios listados: ")
  
  AddGadgetItem(#panel_principal, 2, "Detalles Estudio")
  TextGadget(#PB_Any, 330, 8, 230, 25, "Detalles Estudio")
  TextGadget(#PB_Any, 30, 38, 120, 25, "ID")
  StringGadget(#detalle_id, 160, 38, 300, 25, "")
  DisableGadget(#detalle_id, 1)
  TextGadget(#PB_Any, 480, 78, 120, 25, "Tecnico")
  ComboBoxGadget(#detalle_tecnico, 610, 78, 300, 25)
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
  ComboBoxGadget(#detalle_contraste_combo, 160, 408, 300, 25)
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
  AddStatusBarField(250)
  AddWindowTimer(#ventana_principal, #reloj, 1000)
  AddKeyboardShortcut(#ventana_principal, #PB_Shortcut_F9, #activar_borrado)
EndProcedure

Procedure asignar_id()
  If OpenDatabase(#base_datos, dbname, user, pass)
    If DatabaseQuery(#base_datos, "SELECT max(id_registro) FROM registro_pacientes;")
      While NextDatabaseRow(#base_datos)
        total =  GetDatabaseLong(#base_datos, 0) + 1
      Wend  
      FinishDatabaseQuery(#base_datos)
      SetGadgetText(#campo_id, Str(total))
    Else
      MessageRequester("Error", DatabaseError())
    EndIf 
    CloseDatabase(#PB_All)
  Else
    MessageRequester("Error", DatabaseError())
    
  EndIf 
EndProcedure

Procedure borrar_estudio()
  nombre.s = GetGadgetItemText(#listado_pacientes, GetGadgetState(#listado_pacientes), 2) : result = MessageRequester("Atencion", "Desea borrar el estudio seleccionado?", #PB_MessageRequester_YesNo)
  If result = #PB_MessageRequester_Yes
    If OpenDatabase(#base_datos, dbname, user, pass)
      If DatabaseUpdate(#base_datos, "DELETE FROM registro_pacientes where id_registro = " + GetGadgetText(#listado_pacientes))
        guardar_log("Estudio (" + nombre + ") borrado", GetGadgetText(#lista_tecnicos))
        actualizar_lista_pacientes()
        barra_total_estudios()
        MessageRequester("Ok","El estudio ha sido borrado con exito")
      Else 
        MessageRequester("Error", DatabaseError())
      EndIf 
    Else 
      MessageRequester("Error", DatabaseError())
    EndIf 
  EndIf 
  
EndProcedure

Procedure inicializacion()
  ventana_principal()
  asignar_bd_a_gadget(dbname ,"lista_turnos", #lista_turnos)
  asignar_bd_a_gadget(dbname, "estudios", #estudios_cabeza, " where region = 'Cabeza'")
  asignar_bd_a_gadget(dbname, "estudios", #estudios_torso, " where region = 'Torso'")
  asignar_bd_a_gadget(dbname, "estudios", #estudios_columna, " where region = 'Columna'")
  asignar_bd_a_gadget(dbname, "estudios", #detalle_agregar_estudios, "", " order by nombre asc")
  asignar_bd_a_gadget(dbname, "tecnicos", #detalle_tecnico, "", " order by nombre asc ", " apellido || ', ' || nombre ")
  asignar_id()
  actualizar_lista_pacientes()
  asignar_bd_a_gadget(dbname, "tecnicos", #filtro_tecnico, "", " order by apellido asc ", " apellido || ', ' || nombre ")
  desactivar_detalles()
  barra_total_estudios()
  mostrar_total_lista()
  
  SetGadgetState(#lista_ubicacion, 0)
  SetGadgetState(#lista_contraste, 0)
EndProcedure

inicializacion()
Repeat 
  event = WindowEvent()
  
  If event = #PB_Event_Timer And EventTimer() = #reloj
    hora$=FormatDate("%dd-%mm-%yyyy %hh:%ii",Date())
    SetGadgetText(#campo_fecha,hora$)
  EndIf
  
  If Hour(Date()) % 12 = 0 And Minute(Date()) = 0 And Second(Date()) = 0
    crear_backup(dbname, backup_dir)
    StatusBarText(#barra_estado, 4, "Ultima copia " + FormatDate("%hh:%ii:%ss", Date()))
  EndIf 
  
  If event = #PB_Event_CloseWindow
    If  MessageRequester("Confirmacion", "Desea salir del programa", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      CloseWindow(#ventana_principal)
      salir = #True
      Break
    EndIf 
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
          
        Case #boton_limpiar
          borrar_campos()
          asignar_id()
          DisableGadget(#campo_apellido, 0) : DisableGadget(#campo_nombre, 0)
          
        Case #boton_guardar
          If Not comprobar_campos_vacios() And comprobar_region()
            If Not encontrado 
              guardar_registro_paciente(dbname, GetGadgetText(#campo_dni), title(GetGadgetText(#campo_apellido)), title(GetGadgetText(#campo_nombre)))
              StatusBarText(#barra_estado, 4, "Nuevo paciente registrado en BD")
            EndIf 
            adquirir_datos()
            borrar_campos()
            actualizar_lista_pacientes()
            asignar_id()
            encontrado = #False
            DisableGadget(#campo_apellido, 0) : DisableGadget(#campo_nombre, 0)
          EndIf 
          
        Case #lista_turnos
          asignar_bd_a_gadget(dbname, "tecnicos", #lista_tecnicos, " where turno = '" + GetGadgetText(#lista_turnos) + "' ", " order by apellido asc ", " apellido || ', ' || nombre " )
          
        Case #boton_mes_actual
          SetGadgetState(#date_inicio, Date(Year(Date()),Month(Date()),1,0,0,0))
          filtrar_fecha(GetGadgetState(#date_inicio), GetGadgetState(#date_fin))
          mostrar_total_lista()
          StatusBarText(#barra_estado, 4, "Mostrando estudios del mes")
          
        Case #boton_busqueda
          If GetGadgetState(#date_inicio) > GetGadgetState(#date_fin)
            MessageRequester("Error","La fecha de inicio no puede ser superior a la de fin",#PB_MessageRequester_Error)
          Else
            busqueda(GetGadgetState(#date_inicio), GetGadgetState(#date_fin))
          EndIf 
          mostrar_total_lista()
          StatusBarText(#barra_estado, 4, "Mostrando estudios por busqueda")
          
        Case #filtro_tecnico
          filtro.s = " where tecnico_asignado = '" + GetGadgetText(#filtro_tecnico) + "'"
          actualizar_lista_pacientes(filtro)
          mostrar_total_lista()
          StatusBarText(#barra_estado, 4, "Tecnico: " + StringField(GetGadgetText(#filtro_tecnico), 1, ","))
          
        Case #boton_fecha_hoy
          filtrar_fecha(Date(), Date())
          mostrar_total_lista()
          StatusBarText(#barra_estado, 4, "Mostrando estudios de hoy")
          
        Case #boton_limpiar_filtro
          actualizar_lista_pacientes()
          mostrar_total_lista()
          SetGadgetText(#campo_busqueda, "")
          StatusBarText(#barra_estado, 4, "Mostrando total de estudios")
          SetGadgetState(#filtro_tecnico, -1)
          
        Case #campo_dni
          If EventType() = #PB_EventType_LostFocus
            dni.s = GetGadgetText(#campo_dni)
            encontrado =  buscar_registro_paciente(dbname, dni)
            If encontrado 
              autocompletar_datos(dbname, dni, #campo_apellido, #campo_nombre)
              DisableGadget(#campo_apellido, 1) : DisableGadget(#campo_nombre, 1)
            Else
              DisableGadget(#campo_apellido, 0) : DisableGadget(#campo_nombre, 0)
              SetGadgetText(#campo_apellido, "") : SetGadgetText(#campo_nombre, "")
              SetActiveGadget(#campo_apellido)
            EndIf
          EndIf 
          
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
            If pedir_contrasenia(contrasenia)
              desactivar_detalles(#False)
              DisableGadget(#modificar_detalles, 1)
            EndIf 
          Else
            MessageRequester("Error","No hay ningun estudio seleccionado")
          EndIf 
          
        Case #boton_borrar_estudio
          If GetGadgetText(#listado_pacientes) <> "" And pedir_contrasenia(contrasenia)
            borrar_estudio()
          Else 
            MessageRequester("Error", "No seleccionaste ningun estudio")
          EndIf    
        Case #detalle_agregar_estudios
          estudio.s = GetGadgetText(#detalle_agregar_estudios)
          If Not estudio_duplicado(estudio, #detalle_estudios)
            AddGadgetItem(#detalle_estudios, -1, estudio)
          EndIf 
          
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
          detalle.s = "Paciente modificado: " + GetGadgetText(#detalle_apellido) + ", " + GetGadgetText(#detalle_nombre) + "(id: " + GetGadgetText(#detalle_id) + ")"
          guardar_log(detalle, GetGadgetText(#lista_tecnicos))
          desactivar_detalles()
      EndSelect
    Case #PB_Event_Menu
      
      Select EventMenu()
        Case #acerca_de
          ventana_acercade()
        Case #activar_borrado
          If pedir_contrasenia("RoDrY")
            oculto = Bool(Not oculto)
            HideGadget(#boton_borrar_estudio, oculto)
            DisableMenuItem(#menu_principal, #ver_log, oculto)
          Else
            guardar_log("Intento de acceso indebido", GetGadgetText(#lista_tecnicos))
          EndIf 
          
        Case #bd_pacientes
          base_datos_pacientes(dbname, GetGadgetText(#lista_tecnicos))
          
        Case #ver_log
          ventana_log()
          
        Case #menu_copia
          crear_backup(dbname, backup_dir)
          StatusBarText(#barra_estado, 4, "Ultima copia " + FormatDate("%hh:%ii:%ss", Date()))
          
        Case #menu_exportar_csv
          exportar_csv()
          
        Case #menu_exportar_fecha
          date_requester()
      EndSelect  
  EndSelect
Until salir = #True


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 215
; FirstLine = 48
; Folding = gAw
; EnableXP
; UseIcon = resources\tac.ico
; Executable = C:\Users\Rodrigo\Desktop\Registro_pacientes\Registro TAC.exe
; HideErrorLog