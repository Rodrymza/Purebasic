Procedure guardar_log(detalle.s, tecnico.s)
  dbname.s = "resources\gestion_tomografia.db"
  fecha.s = FormatDate("%dd-%mm-%yyyy %hh:%ii:%ss", Date())
  registro.s = detalle + " - " + tecnico
  If OpenDatabase(0, dbname, "", "")
    query.s = "INSERT INTO log (fecha, registro) " + 
              "VALUES ('" + fecha + "', '" + registro + "')"
    If DatabaseUpdate(0, query)
    Else
      MessageRequester("Error", "Error al guardar log")
    EndIf 
    CloseDatabase(#PB_All)
  Else
    MessageRequester("Error","Error al conectarse a la base de datos")
  EndIf 
EndProcedure

Procedure crear_backup(ruta_original.s, ruta_copia.s)
  borrado = #False  
  nombre_backup.s = ruta_copia + "backup-" + FormatDate("%yyyy-%mm-%dd %hh_%ii_%ss", Date()) + ".db"
  If CopyFile(ruta_original, nombre_backup)
    guardar_log("Copia de seguridad" + nombre_backup, "Sistema")
  Else 
    guardar_log("Error en la copia de seguridad", "Sistema")
  EndIf
  
  NewList copias.s()
  
  If ExamineDirectory(0, ruta_copia, "*.db*")
    total_archivos = 0
    While NextDirectoryEntry(0)
      AddElement(copias())
      copias() = ruta_copia + DirectoryEntryName(0)
      total_archivos + 1
    Wend
  EndIf 
  SortList(copias(), #PB_Sort_Ascending)
  
  While ListSize(copias()) > 15
    FirstElement(copias())
    borrado = #True
    DeleteFile(copias())
    DeleteElement(copias())
  Wend  
  
  If borrado
    guardar_log("Borrado de archivos antiguos", "Sistema")
  EndIf 
  
EndProcedure

Procedure.s capitalize(text.s)
  ProcedureReturn UCase(Mid(text,1,1))+LCase(Mid(text,2,Len(text)))
EndProcedure

Procedure$ title(palabra$)  ;Formatea el texto a primera de cada palabra mayuscula
  
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

Procedure ventana_acercade() ;del menu de ayuda-acerca de
  OpenWindow(0, 0, 0, 480, 190, "Acerca de", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  SendMessage_(WindowID(0), #WM_SETICON, 0, LoadImage(1, "resources\about.ico"))
  TextGadget(#PB_Any, 30, 50, 260, 25, "Registro pacientes tomografia Hospital Central v1.0")
  TextGadget(#PB_Any, 30, 90, 260, 25, "Rodry Ramirez (c) 2024")
  TextGadget(#PB_Any, 30, 130, 260, 25, "rodrymza@gmail.com")
  ImageGadget(#PB_Any, 320, 32, 128, 128,  LoadImage(2, "resources\medical.ico"))
  Repeat  
    event=WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(0) 
    EndSelect
  Until event= #PB_Event_CloseWindow
EndProcedure

Procedure.b pedir_contrasenia(contrasenia.s) ; pedir contrasenia para ciertas funciones limitadas
  If InputRequester("Contraseña requerida", "Ingrese contraseña de administrador", "") = contrasenia
    ProcedureReturn #True
  Else
    MessageRequester("Error", "La contrasenia ingresada es incorrecta", #PB_MessageRequester_Error)
    ProcedureReturn #False  
  EndIf   
EndProcedure

Procedure ventana_modificar_datos(dbname.s, dni.s, tecnico.s)
  ventana_principal = OpenWindow(#PB_Any, 0, 0, 500, 280, "Actualizacion de datos", #PB_Window_SystemMenu)
  TextGadget(#PB_Any, 50, 70, 130, 25, "DNI")
  campo_documento = StringGadget(#PB_Any, 200, 70, 250, 25, "")
  DisableGadget(campo_documento, 1)
  TextGadget(#PB_Any, 30, 20, 450, 25, "Actualizar Datos", #PB_Text_Center)
  TextGadget(#PB_Any, 50, 120, 130, 25, "Apellido")
  campo_apellido = StringGadget(#PB_Any, 200, 120, 250, 25, "")
  TextGadget(#PB_Any, 50, 170, 130, 25, "Nombre")
  campo_nombre = StringGadget(#PB_Any, 200, 170, 250, 25, "")
  boton_guardar = ButtonGadget(#PB_Any, 160, 220, 170, 35, "Guardar")
  
  If OpenDatabase(database, dbname, "", "")
    If DatabaseQuery(database, "SELECT dni, apellido, nombre FROM pacientes where dni = " + dni)
      While NextDatabaseRow(database)
        documento.s = GetDatabaseString(database, 0)
        apellido.s = GetDatabaseString(database, 1)
        nombre.s = GetDatabaseString(database, 2)
      Wend
      SetGadgetText(campo_documento, documento)
      SetGadgetText(campo_apellido, apellido)
      SetGadgetText(campo_nombre, nombre)
      FinishDatabaseQuery(database)
    Else
      MessageRequester("Error", "Error al gestionar request: " + DatabaseError())
    EndIf
    CloseDatabase(database)
  Else
    MessageRequester("Error", "Error al abrir base de datos: " + DatabaseError())
  EndIf 
  
  
  Repeat
    event = WindowEvent()
    If event = #PB_Event_CloseWindow
      CloseWindow(ventana_principal)
    EndIf 
    If event = #PB_Event_Gadget And EventGadget() = boton_guardar 
      request.s = "UPDATE pacientes " +
                  "set nombre = '" + title(GetGadgetText(campo_nombre)) + 
                  "', apellido = '" + title(GetGadgetText(campo_apellido)) + 
                  "' where dni = '" + GetGadgetText(campo_documento) + "';"
      If OpenDatabase(database, dbname, "", "")
        If DatabaseUpdate(database, request)
          MessageRequester("OK", "Datos del paciente actualizados")
          guardar_log("Datos del paciente " + documento + " actualizados" , tecnico)
          CloseWindow(ventana_principal)
          salir = #True
        Else
          MessageRequester("Error al procesar la solicitiud", DatabaseError())
        EndIf
        CloseDatabase(#PB_All)
      Else
        MessageRequester("Error de conexion", DatabaseError())
      EndIf 
    EndIf 
    
  Until event = #PB_Event_CloseWindow Or salir = #True
EndProcedure

Procedure guardar_registro_paciente(dbname.s, dni.s, apellido.s, nombre.s) ; guarda un nuevo paciente en la tabla "pacientes"  
  If OpenDatabase(0, dbname, "", "")
    request.s = "INSERT INTO pacientes (dni, apellido, nombre) VALUES ('" +
                dni + "', '" + 
                apellido + "', '" +
                nombre + "')"
    Debug request
    If DatabaseUpdate(0, request)
      MessageRequester("OK","Registro de paciente guardado satisfactoriamente")
    Else
      MessageRequester("Error",DatabaseError())
    EndIf
    CloseDatabase(#PB_All)
  Else  
    MessageRequester("Error","Error al conectarse a la base de datos", #PB_MessageRequester_Error)
  EndIf 
  
  
EndProcedure

Procedure.b buscar_registro_paciente(dbname.s, dni.s) ;buscar un paciente por dni dentro de la base de datos
  
  If OpenDatabase(0, dbname, "", "")
    request.s = "SELECT count(dni) FROM pacientes where dni ='" + dni + "';"
    If DatabaseQuery(0, request)
      While NextDatabaseRow(0)
        If GetDatabaseLong(0, 0) > 0
          retorno = #True
        Else
          FinishDatabaseQuery(0)
          retorno =  #False
        EndIf
      Wend
      FinishDatabaseQuery(0)
    Else
      MessageRequester("Error", DatabaseError())
    EndIf
    CloseDatabase(#PB_All)
  EndIf 
  ProcedureReturn retorno
EndProcedure

Procedure autocompletar_datos(dbname.s, dni.s, gadget_apellido, gadget_nombre) ; autocompletado de datos para pacientes que estan guardados
  
  If OpenDatabase(base_datos, dbname, "", "")
    request.s = "SELECT * FROM pacientes where dni = '" + dni + "';"
    If DatabaseQuery(base_datos, request)
      While NextDatabaseRow(base_datos)
        apellido.s = GetDatabaseString(base_datos, 1)
        nombre.s = GetDatabaseString(base_datos, 2)
      Wend  
      SetGadgetText(gadget_apellido, apellido)
      SetGadgetText(gadget_nombre, nombre)
      FinishDatabaseQuery(base_datos)
    Else
      MessageRequester("Error", DatabaseError())
    EndIf 
    CloseDatabase(base_datos)
  Else
    MessageRequester("Error", DatabaseError())
    
  EndIf 
  
EndProcedure

Procedure llenar_listado_pacientes(dbname.s, gadget)
  If OpenDatabase(0, dbname, "", "")
    If DatabaseQuery(0, "SELECT * FROM pacientes")
      While NextDatabaseRow(0)
        dni.s = GetDatabaseString(0, 0)
        apellido.s = GetDatabaseString(0, 1)
        nombre.s = GetDatabaseString(0, 2)
        AddGadgetItem(gadget, -1, dni + Chr(10) + apellido + Chr(10) + nombre)
        If i%2 = 0
          SetGadgetItemColor(gadget, i, #PB_Gadget_BackColor, $CCD148)
        EndIf 
        i+1
      Wend 
      FinishDatabaseQuery(0)
    Else
      MessageRequester("Error", DatabaseError())
    EndIf 
  CloseDatabase(#PB_All)  
  Else
    MessageRequester("Error", DatabaseError())
  EndIf 
EndProcedure

Procedure base_datos_pacientes(dbname.s, tecnico.s) ; ventana para ver total de pacientes en la base de datos (mas funcionalidades a implementar)
  i = 0
  ventana_pacientes = OpenWindow(#PB_Any, 0, 0, 600, 530, "Registro de pacientes", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(#PB_Any, 10, 10, 580, 25, "Base de datos pacientes", #PB_Text_Center)
  lista_pacientes = ListIconGadget(#PB_Any, 20, 70, 560, 450, "DNI", 150, #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(lista_pacientes, 1, "Apellido", 200)
  AddGadgetColumn(lista_pacientes, 2, "Nombre", 200)
  
  llenar_listado_pacientes(dbname, lista_pacientes)
  
 Repeat 
    event = WindowEvent()
    If event = #PB_Event_CloseWindow
      CloseWindow(ventana_pacientes)
    EndIf 
    If event = #PB_Event_Gadget And EventGadget() = lista_pacientes And EventType() = #PB_EventType_LeftDoubleClick
      ventana_modificar_datos(dbname, GetGadgetText(lista_pacientes), tecnico)
      ClearGadgetItems(lista_pacientes)
      llenar_listado_pacientes(dbname, lista_pacientes)
      EndIf 
  Until event = #PB_Event_CloseWindow
EndProcedure

Procedure estudio_duplicado(estudio.s, gadget)
  For i = 0 To CountGadgetItems(gadget)
    If   estudio.s = GetGadgetItemText(gadget, i)
      MessageRequester("Atencion","La region ya se encuentra dentro del estudio", #PB_MessageRequester_Warning)
      ProcedureReturn #True
    EndIf 
  Next
    ProcedureReturn #False  
  EndProcedure
  
 Procedure asignar_bd_a_gadget(dbname.s, tablename.s, gadget, filtro.s = "" , orden.s = "", seleccion.s = "*", columna = 0) ;asigna valores de un base de datos a un gadget
  If OpenDatabase(0, dbname, "", "")
    If DatabaseQuery(0, "SELECT " + seleccion + " FROM " + tablename + filtro + orden)
      ClearGadgetItems(gadget)
      While NextDatabaseRow(0)
        texto.s = GetDatabaseString(0, columna)
        AddGadgetItem(gadget, -1, texto)
      Wend
      FinishDatabaseQuery(0)
    Else
      MessageRequester("Error", DatabaseError())
    EndIf 
    CloseDatabase(#PB_All)
  Else
    MessageRequester("Error", DatabaseError())
  EndIf 
  
EndProcedure

Macro desactivar_campos_tecnico(desactivar = 1)
  DisableGadget(#campo_apellido, desactivar)
  DisableMenuItem(#menu_principal ,#bd_pacientes, desactivar)
  DisableGadget(#campo_nombre, desactivar)
  DisableGadget(#estudios_cabeza, desactivar)
  DisableGadget(#estudios_columna, desactivar)
  DisableGadget(#lista_contraste, desactivar)
  DisableGadget(#estudios_torso, desactivar)
  DisableGadget(#campo_diagnostico, desactivar)
  DisableGadget(#campo_medico, desactivar)
  DisableGadget(#boton_guardar, desactivar)
  DisableGadget(#boton_limpiar, desactivar)
  DisableGadget(#campo_dni, desactivar)
  DisableGadget(#campo_sala, desactivar)
  DisableGadget(#lista_ubicacion, desactivar)
  DisableGadget(#campo_comentarios, desactivar)  
  
EndMacro  

Macro borrar_campos() ;borra los campos de ingreso de datos
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
  
EndMacro

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 329
; FirstLine = 12
; Folding = AA9
; EnableXP
; HideErrorLog