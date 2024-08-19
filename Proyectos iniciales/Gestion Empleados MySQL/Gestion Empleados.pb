Enumeration
  #busqueda_text : #Combo_sectores
  #boton_nuevo : #apellido_text
  #dni_text : #telefono_text
  #nombre_text : #sector_text
  #mail_text : #boton_modificar
  #boton_eliminar : #main_window
  #panel_principal : #lista_principal
  #basedatos : #barra_estado
  #boton_buscar
EndEnumeration

UseMySQLDatabase()
;variables 

Global dbname.s="host=localhost port=3306 dbname=rodry_datos", tablename.s="gestion_empleados", user.s="rodry", pass.s="rodry1234"

;Funciones
Procedure actualizar_lista()
  ClearGadgetItems(#lista_principal)
  OpenDatabase(#basedatos,dbname,user,pass)
  DatabaseQuery(#basedatos,"SELECT * FROM " + tablename)
  While NextDatabaseRow(#basedatos)
    AddGadgetItem(#lista_principal,-1,Str(GetDatabaseLong(#basedatos,0)) + Chr(10) + GetDatabaseString(#basedatos,1) + ", " + GetDatabaseString(#basedatos,2) + Chr(10) +GetDatabaseString(#basedatos,5))
  Wend
  CloseDatabase(#basedatos)
EndProcedure

;Main
OpenWindow(#main_window, 0, 0, 560, 600, "Gestion de empleados", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
TextGadget(#PB_Any, 40, 20, 130, 25, "Gestion de Personal")
PanelGadget(#panel_principal, 20, 50, 520, 520)
AddGadgetItem(#panel_principal, -1, "Listado")
ListIconGadget(#lista_principal, 10, 60, 500, 388, "DNI", 100,#PB_ListIcon_GridLines)
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
StringGadget(#apellido_text, 170, 138, 180, 25, "")
TextGadget(#PB_Any, 60, 138, 100, 25, "Apellido")
StringGadget(#dni_text, 170, 98, 180, 25, "", #PB_String_Numeric)
TextGadget(#PB_Any, 60, 98, 100, 25, "DNI")
StringGadget(#telefono_text, 170, 218, 180, 25, "", #PB_String_Numeric)
TextGadget(#PB_Any, 60, 218, 100, 25, "Telefono")
StringGadget(#nombre_text, 170, 178, 180, 25, "")
TextGadget(#PB_Any, 60, 178, 100, 25, "Nombre")
StringGadget(#sector_text, 170, 298, 180, 25, "")
TextGadget(#PB_Any, 60, 298, 100, 25, "Sector")
StringGadget(#mail_text, 170, 258, 180, 25, "")
TextGadget(#PB_Any, 60, 258, 100, 25, "Mail")
TextGadget(#PB_Any, 40, 28, 170, 25, "Editar Empleado")
ButtonGadget(#PB_Any, 310, 358, 160, 30, "Guardar Cambios")
CloseGadgetList()
CreateStatusBar(#barra_estado,WindowID(#main_window))
AddStatusBarField(350)

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
          busqueda.s="'%" + GetGadgetText(#busqueda_text) + "%'"
          OpenDatabase(#basedatos, dbname, user, pass)
          If DatabaseQuery(#basedatos,"SELECT dni, apellido, nombre, sector FROM " + tablename + " WHERE apellido like " + busqueda)
            ClearGadgetItems(#lista_principal)
            While NextDatabaseRow(#basedatos)
              AddGadgetItem(#lista_principal,-1,Str(GetDatabaseLong(#basedatos,0)) + Chr(10) + GetDatabaseString(#basedatos,1) + ", " + GetDatabaseString(#basedatos,2) + Chr(10) + GetDatabaseString(#basedatos,3))
            Wend
          EndIf 
        
      EndSelect
  EndSelect
Until event=#PB_Event_CloseWindow

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 83
; FirstLine = 45
; Folding = -
; Optimizer
; EnableXP
; HideErrorLog