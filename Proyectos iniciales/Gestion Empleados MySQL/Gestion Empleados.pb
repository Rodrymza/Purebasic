Enumeration
  #busqueda_text : #Combo_sectores
  #boton_nuevo : #apellido_text
  #dni_text : #telefono_text
  #nombre_text : #sector_text
  #mail_text : #boton_modificar
  #boton_eliminar : #main_window
  #panel_principal : #lista_principal
  #basedatos : #barra_estado
  #boton_buscar : #tecla_intro
  #titulo_panel_1 : #boton_guardar
EndEnumeration

UseMySQLDatabase()
;variables 

Global dbname.s="host=localhost port=3306 dbname=rodry_datos", tablename.s="gestion_empleados", user.s="rodry", pass.s="rodry1234"
Global Dim areas.s(5) : areas(0)="Recursos Humanos" : areas(1)="Ventas" : areas(2)="Marketing" : areas(3)="Contabilidad" : areas(4)="IT"
;Funciones

Procedure colores(i,area.s)
   Select area
      Case "Ventas" : SetGadgetItemColor(#lista_principal,i,#PB_Gadget_BackColor,$C1C1FF)
      Case "Contabilidad" : SetGadgetItemColor(#lista_principal,i,#PB_Gadget_BackColor,$98FB98)
      Case "Marketing" : SetGadgetItemColor(#lista_principal,i,#PB_Gadget_BackColor,$DDA0DD)
      Case "IT" : SetGadgetItemColor(#lista_principal,i,#PB_Gadget_BackColor,$EEEE8D)
      Case "Recursos Humanos" : SetGadgetItemColor(#lista_principal,i,#PB_Gadget_BackColor,RGB(238, 221, 130))
    EndSelect
EndProcedure

Procedure actualizar_lista()
  i=0
  ClearGadgetItems(#lista_principal)
  OpenDatabase(#basedatos,dbname,user,pass)
  DatabaseQuery(#basedatos,"SELECT * FROM " + tablename + " ORDER BY apellido")
  While NextDatabaseRow(#basedatos)
    AddGadgetItem(#lista_principal,-1,Str(GetDatabaseLong(#basedatos,0)) + Chr(10) + GetDatabaseString(#basedatos,1) + ", " + GetDatabaseString(#basedatos,2) + Chr(10) +GetDatabaseString(#basedatos,5))  
   colores(i,GetDatabaseString(#basedatos,5))
    i=i+1
  Wend
  CloseDatabase(#basedatos)
EndProcedure

Procedure busqueda()
  i=0
  busqueda.s="'%" + GetGadgetText(#busqueda_text) + "%'"
  ClearGadgetItems(#lista_principal)
  OpenDatabase(#basedatos, dbname, user, pass)
  If DatabaseQuery(#basedatos,"SELECT dni, apellido, nombre, sector FROM " + tablename + " WHERE apellido LIKE " + busqueda + " OR nombre LIKE " + busqueda)
    While NextDatabaseRow(#basedatos)
      AddGadgetItem(#lista_principal,-1,Str(GetDatabaseLong(#basedatos,0)) + Chr(10) + GetDatabaseString(#basedatos,1) + ", " + GetDatabaseString(#basedatos,2) + Chr(10) + GetDatabaseString(#basedatos,3))
      colores(i,GetDatabaseString(#basedatos,3))
      i=i+1
    Wend
  EndIf
EndProcedure

Procedure.s modificar_datos()
  SetGadgetText(#titulo_panel_1,"Editar Empleado")
  OpenDatabase(#basedatos, dbname, user, pass)
  DatabaseQuery(#basedatos, "SELECT * FROM " + tablename + " WHERE dni=" + GetGadgetText(#lista_principal))
  NextDatabaseRow(#basedatos)
  SetGadgetState(#panel_principal,1)
  SetGadgetText(#dni_text,Str(GetDatabaseLong(#basedatos,0))) : SetGadgetText(#apellido_text,GetDatabaseString(#basedatos,1))
  SetGadgetText(#nombre_text,GetDatabaseString(#basedatos,2)) : SetGadgetText(#mail_text,GetDatabaseString(#basedatos,4))
  SetGadgetText(#telefono_text,Str(GetDatabaseLong(#basedatos,3))) : SetGadgetText(#sector_text,GetDatabaseString(#basedatos,5))
  ProcedureReturn GetGadgetText(#lista_principal)
EndProcedure

        
;Main
OpenWindow(#main_window, 0, 0, 560, 600, "Gestion de empleados", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
TextGadget(#PB_Any, 40, 20, 130, 25, "Gestion de Personal")
PanelGadget(#panel_principal, 20, 50, 520, 520)
AddGadgetItem(#panel_principal, -1, "Listado")
ListIconGadget(#lista_principal, 10, 60, 500, 388, "DNI", 100,#PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
AddGadgetColumn(#lista_principal, 1, "Apellido y Nombre", 200)
AddGadgetColumn(#lista_principal, 2, "Sector", 150)
TextGadget(#PB_Any, 20, 28, 70, 25, "Busqueda")
StringGadget(#busqueda_text, 90, 28, 160, 25, "")
ButtonGadget(#boton_buscar, 260, 28, 100, 25, "Buscar")
ComboBoxGadget(#Combo_sectores, 370, 28, 130, 25)
ButtonGadget(#boton_nuevo, 50, 458, 130, 30, "Nuevo")
ButtonGadget(#boton_modificar, 200, 458, 130, 30, "Modificar")
ButtonGadget(#boton_eliminar, 350, 458, 130, 30, "Eliminar")
AddGadgetItem(#panel_principal, -1, "Gestion Individuo", 0, 1)
StringGadget(#dni_text, 170, 98, 180, 25, "", #PB_String_Numeric)
TextGadget(#PB_Any, 60, 98, 100, 25, "DNI")
StringGadget(#apellido_text, 170, 138, 180, 25, "")
TextGadget(#PB_Any, 60, 138, 100, 25, "Apellido")
StringGadget(#nombre_text, 170, 178, 180, 25, "")
TextGadget(#PB_Any, 60, 178, 100, 25, "Nombre")
StringGadget(#telefono_text, 170, 218, 180, 25, "", #PB_String_Numeric)
TextGadget(#PB_Any, 60, 218, 100, 25, "Telefono")
StringGadget(#mail_text, 170, 258, 180, 25, "")
TextGadget(#PB_Any, 60, 258, 100, 25, "Mail")
ComboBoxGadget(#sector_text, 170, 298, 180, 25)
TextGadget(#PB_Any, 60, 298, 100, 25, "Sector")
TextGadget(#titulo_panel_1, 40, 28, 170, 25, "Editar Empleado")
ButtonGadget(#boton_guardar, 310, 358, 160, 30, "Guardar Cambios")
CloseGadgetList()
CreateStatusBar(#barra_estado,WindowID(#main_window))
AddStatusBarField(350)
AddKeyboardShortcut(#main_window,#PB_Shortcut_Return,#tecla_intro)
For i=0 To 4
  AddGadgetItem(#Combo_sectores,-1,areas(i))
  AddGadgetItem(#sector_text,-1,areas(i))
Next
SetGadgetState(#Combo_sectores,0)

If OpenDatabase(#basedatos, dbname, user, pass)
  If DatabaseUpdate(#basedatos,"CREATE TABLE " + tablename + " (dni INT Not NULL, apellido VARCHAR(45), nombre VARCHAR(45), telefono INT, mail VARCHAR(45), sector VARCHAR(45), PRIMARY KEY (dni));")
    StatusBarText(#barra_estado,0,"Se creo la tabla correspondiente para almacenar datos")
  Else 
    StatusBarText(#barra_estado,0,"Conectado a la base de datos")
  EndIf 
Else
EndIf 
CloseDatabase(#basedatos)
actualizar_lista()
Repeat
  event = WindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_buscar
          busqueda()
        Case #busqueda_text
          If EventType()=#PB_EventType_Focus : stringactive=#True : EndIf 
          If EventType()=#PB_EventType_LostFocus : stringactive=#False : EndIf 
        Case #boton_modificar
          dni.s=modificar_datos()
        Case #boton_nuevo
          SetGadgetText(#titulo_panel_1,"Nuevo Empleado")
          SetGadgetText(#dni_text,"") : SetGadgetText(#apellido_text,"") : SetGadgetText(#nombre_text,"")
          SetGadgetText(#telefono_text,"") : SetGadgetText(#mail_text,"") : SetGadgetState(#sector_text,0)
          SetGadgetState(#panel_principal,1)
        Case #boton_guardar
          OpenDatabase(#basedatos,dbname,user,pass)
          If GetGadgetText(#titulo_panel_1)="Nuevo Empleado"
            If DatabaseUpdate(#basedatos,"INSERT INTO " + tablename + " (dni, apellido, nombre, telefono, mail, sector) VALUES (" + GetGadgetText(#dni_text) + ", '" + GetGadgetText(#apellido_text) + "', '" + GetGadgetText(#nombre_text) + "', " + GetGadgetText(#telefono_text) + ", '" + GetGadgetText(#mail_text) + "', '" + GetGadgetText(#sector_text) + "')")
              MessageRequester("Exito","Empleado " + GetGadgetText(#apellido_text) + " agregado exitosamente a la base de datos")
              actualizar_lista()  
            EndIf
          Else 
            If DatabaseUpdate(#basedatos,"UPDATE " + tablename + " SET dni=" + GetGadgetText(#dni_text) + ", apellido='" + GetGadgetText(#apellido_text) + "', nombre='" + GetGadgetText(#nombre_text) + "', telefono=" + GetGadgetText(#telefono_text) + ", mail='" + GetGadgetText(#mail_text) + "', sector='" + GetGadgetText(#sector_text) + "' WHERE dni=" + dni)
              MessageRequester("Exito","Se actualizaron lo valores")
              actualizar_lista()
            EndIf
          EndIf 
            
          Case #boton_eliminar
            If GetGadgetText(#lista_principal)=""
              MessageRequester("Atencion","No seleccionaste ningun empleado",#PB_MessageRequester_Error)
          Else
            OpenDatabase(#basedatos, dbname, user, pass)
            If DatabaseUpdate(#basedatos, "DELETE FROM " + tablename + " WHERE dni=" + GetGadgetText(#lista_principal))
              MessageRequester("Atencion","Se borro correctamente el empleado seleccionado",#PB_MessageRequester_Info)
              actualizar_lista()
            Else 
              MessageRequester("Error","Error al completar la operacion",#PB_MessageRequester_Error)
            EndIf 
          EndIf
          
        Case #lista_principal
          If EventType()=#PB_EventType_LeftDoubleClick : dni=modificar_datos() : EndIf 
        EndSelect
      Case #PB_Event_Menu
        Select EventMenu()
          
        Case #tecla_intro
          If stringactive=#True : busqueda() : EndIf
          
      EndSelect
      
  EndSelect
Until event=#PB_Event_CloseWindow

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 165
; FirstLine = 113
; Folding = 9
; Optimizer
; EnableXP
; HideErrorLog