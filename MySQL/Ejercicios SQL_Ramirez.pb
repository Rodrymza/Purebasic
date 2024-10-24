Enumeration
  #database
  #main_window
  #panel_principal
  #listicon
  #menu_buscar
  #menu_ppal
EndEnumeration

UseMySQLDatabase()

Global dbname.s="host=localhost port=3306 dbname=ventas", user.s="root", pass.s=""

Procedure contar_columnas(tablename.s)
  OpenDatabase(#database, dbname, user, pass)
  DatabaseQuery(#database, "describe " + tablename)
  cont = 0
  While NextDatabaseRow(#database)
    cont + 1
  Wend
  FinishDatabaseQuery(#database)
  ProcedureReturn cont
EndProcedure

Procedure actualizar_tabla_clientes()
  If OpenDatabase(#database, dbname, user, pass)
    total_columnas = contar_columnas("cliente")
    If DatabaseQuery(#database, "select * from cliente order by apellido1 asc;")
      While NextDatabaseRow(#database)
        texto.s=""
        For i = 0 To total_columnas
          texto + GetDatabaseString(#database, i) + Chr(10)
        Next
        AddGadgetItem(#listicon, -1, texto)   
      Wend
      FinishDatabaseQuery(#database)
    EndIf 
  EndIf 
EndProcedure

Procedure busqueda()
  ingreso.s = InputRequester("Busqueda","Ingrese apellido o nombre a buscar","") 
  Debug "select * from cliente where nombre like %" + ingreso + "% or apellido1 like %" + ingreso + "% order by apellido1 asc;"
  OpenDatabase(#database, dbname, user, pass)
      total_columnas = contar_columnas("cliente")
  ClearGadgetItems(#listicon)
  If DatabaseQuery(#database, "select * from cliente where nombre like '%" + ingreso + "%' or apellido1 like '%" + ingreso + "%' order by apellido1 asc;")
    
      While NextDatabaseRow(#database)
        texto.s=""
        For i = 0 To total_columnas
          texto + GetDatabaseString(#database, i) + Chr(10)
        Next
        AddGadgetItem(#listicon, -1, texto)   
      Wend
      FinishDatabaseQuery(#database)
    EndIf 
EndProcedure


OpenWindow(#main_window, 0, 0, 610, 470, "Ejercicios MySQL", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CreateMenu(#menu_ppal, WindowID(#main_window))
MenuTitle("Archivo")
MenuItem(#menu_buscar, "Buscar")
PanelGadget(#panel_principal, 20, 20, 580, 450)
AddGadgetItem(#panel_principal, -1, "Clientes")
ListIconGadget(#listicon, 10, 138, 550, 270, "ID", 50,  #PB_ListIcon_FullRowSelect)
AddGadgetColumn(#listicon, 1, "Nombre", 100)
AddGadgetColumn(#listicon, 2, "Apellido", 100)
AddGadgetColumn(#listicon, 3, "2do Apellido", 100)
AddGadgetColumn(#listicon, 4, "Ciudad", 100)
AddGadgetColumn(#listicon, 5, "Categoria", 80)
AddGadgetItem(#panel_principal, -1, "Comercial")

CloseGadgetList()

actualizar_tabla_clientes()

Repeat 
  event = WindowEvent()
  Select event
    Case #PB_Event_Menu
      Select EventMenu()
        Case #menu_buscar
          busqueda()
      EndSelect
      
  EndSelect
Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 12
; FirstLine = 3
; Folding = 9
; EnableXP
; Compiler = PureBasic 6.12 LTS (Windows - x64)