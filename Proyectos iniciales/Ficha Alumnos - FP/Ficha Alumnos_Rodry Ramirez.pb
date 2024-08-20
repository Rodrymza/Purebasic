;Programa que guardar informacion de una ficha de alumnos con fotos
;Base de datos SQL y foto en carpeta local
;Rodry Ramirez(c) 2024

Enumeration
  #main_window : #apellido
  #titulo : #nombre : #acerca_de
  #domicilio : #telefono
  #boton_guardar : #boton_anterior
  #boton_siguiente : #legajo
  #boton_modificar : #boton_borrar
  #panel_principal : #lista_principal
  #foto_principal :#imagen
EndEnumeration

UseJPEGImageDecoder() : UseMySQLDatabase() : UsePNGImageDecoder()
Structure datos
  nombre.s
  apellido.s
  domicilio.s
  telefono.l
EndStructure

LoadImage(#imagen,"sin_foto.png") 
ResizeImage(#imagen,160,160)

OpenWindow(#main_window, 0, 0, 560, 440, "Gestion de Alumnos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CreateMenu(#PB_Any, WindowID(#main_window))
  MenuTitle("Archivo")
  MenuItem(#acerca_de, "Acerca de")
  TextGadget(#PB_Any, 190, 10, 190, 25, "Ficha de Alumnos", #PB_Text_Center)
  PanelGadget(#panel_principal, 20, 40, 520, 360)
  AddGadgetItem(#panel_principal, -1, "Ingreso y Modificacion")
  TextGadget(#PB_Any, 20, 108, 80, 25, "Apellido")
  StringGadget(#apellido, 110, 108, 210, 30, "")
  TextGadget(#titulo, 80, 18, 180, 25, "Ingreso de Nuevo Alumno")
  TextGadget(#PB_Any, 20, 148, 80, 25, "Nombre")
  StringGadget(#nombre, 110, 148, 210, 30, "")
  TextGadget(#PB_Any, 20, 188, 80, 25, "Domicilio")
  StringGadget(#domicilio, 110, 188, 210, 30, "")
  TextGadget(#PB_Any, 20, 228, 80, 25, "Telefono")
  StringGadget(#telefono, 110, 228, 210, 30, "", #PB_String_Numeric)
  ButtonGadget(#boton_guardar, 350, 288, 120, 25, "Guardar")
  ButtonGadget(#boton_anterior, 40, 288, 120, 25, "<- Anterior")
  ButtonGadget(#boton_siguiente, 180, 288, 120, 25, "Siguiente ->")
  ImageGadget(#foto_principal, 340, 78, 160, 160, (ImageID(#imagen)))
  TextGadget(#PB_Any, 20, 68, 80, 25, "Legajo")
  StringGadget(#legajo, 110, 68, 100, 30, "")
  DisableGadget(#legajo, 1)
  AddGadgetItem(#panel_principal, -1, "Lista de Alumnos", 0, 1)
  ListIconGadget(#lista_principal, 10, 30, 500, 258, "Apellido y Nombre", 210)
  AddGadgetColumn(#lista_principal, 1, "Domicilio", 190)
  AddGadgetColumn(#lista_principal, 2, "Telefono", 90)
  ButtonGadget(#boton_modificar, 100, 298, 150, 25, "Modificar")
  ButtonGadget(#boton_borrar, 270, 298, 150, 25, "Borrar")
  CloseGadgetList()
  
  Repeat : event=WindowEvent()
    
  Until event=#PB_Event_CloseWindow
  
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 23
; FirstLine = 14
; EnableXP
; HideErrorLog